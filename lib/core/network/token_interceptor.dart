import 'dart:async';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:deepple_app/core/mixin/log_mixin.dart';
import 'package:deepple_app/core/network/logging_interceptor.dart';
import 'package:deepple_app/core/network/enum/token_unauthorized_code.dart';
import 'package:deepple_app/core/network/network_request_extras.dart';
import 'package:deepple_app/core/provider/auth_expired_provider.dart';
import 'package:deepple_app/core/storage/local_storage.dart';
import 'package:deepple_app/core/storage/local_storage_item.dart';
import 'package:deepple_app/core/util/log.dart';
import 'package:deepple_app/features/auth/data/usecase/auth_usecase_impl.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TokenInterceptor extends QueuedInterceptor with LogMixin {
  static const String _authorizationHeader = 'authorization';
  static const String _bearerPrefix = 'Bearer ';
  static const String _setCookieHeader = 'set-cookie';
  static const int _unauthorizedStatusCode = 401;
  static const String _refreshPath = 'member/refresh';
  static const Duration _refreshTimeout = Duration(seconds: 15);

  final Ref _ref;
  final Dio _dio;
  final PersistCookieJar _cookieJar;

  Dio? _refreshDio;

  Future<String?>? _refreshInFlight;

  TokenInterceptor({
    required Ref ref,
    required Dio dio,
    required PersistCookieJar cookieJar,
  }) : _ref = ref,
       _dio = dio,
       _cookieJar = cookieJar;

  Dio get _dioForRefresh {
    final existing = _refreshDio;
    if (existing != null) return existing;

    final newDio = Dio(_dio.options);
    newDio.httpClientAdapter = _dio.httpClientAdapter;
    newDio.transformer = _dio.transformer;
    newDio.interceptors.add(LoggingInterceptor());
    newDio.interceptors.add(CookieManager(_cookieJar));
    _refreshDio = newDio;
    return newDio;
  }

  Uri? _buildRefreshUri() {
    final baseUrl = _dio.options.baseUrl;
    if (baseUrl.isEmpty) return null;

    final base = Uri.parse(baseUrl);
    final normalizedBase = base.replace(
      path: base.path.endsWith('/') ? base.path : '${base.path}/',
    );
    return normalizedBase.resolve(_refreshPath);
  }

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final ok = await _waitForRefreshIfNeeded(options);
    if (!ok) {
      _ref.read(authExpiredProvider.notifier).execute();
      Log.i(
        'api call terminated: refresh failed; ${options.method} ${options.uri}',
      );
      return handler.reject(
        _buildUnauthorizedException(options, reason: 'refresh failed'),
      );
    }
    await _attachAccessTokenIfRequired(options);
    super.onRequest(options, handler);
  }

  @override
  Future<void> onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) async {
    final headers = response.headers.map;

    try {
      await _extractAndSaveTokens(headers, responseUri: response.realUri);
    } catch (e, st) {
      Log.e('token extraction/save failed: $e', stackTrace: st);
    }
    return super.onResponse(response, handler);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (!_isUnauthorizedError(err) || _shouldSkipAuth(err.requestOptions)) {
      return super.onError(err, handler);
    }

    final requiresAccessToken = _requiresAccessToken(err.requestOptions);
    if (!requiresAccessToken) {
      return super.onError(err, handler);
    }

    final code = _extractUnauthorizedCode(err);

    if (code != null && TokenUnauthorizedCode.isExpiredAccessToken(code)) {
      if (_alreadyRetriedOptions(err.requestOptions)) {
        _ref.read(authExpiredProvider.notifier).execute();
        return super.onError(err, handler);
      }

      final tokenForRetry = await _getTokenForRetry(err.requestOptions);
      if (tokenForRetry == null || tokenForRetry.isEmpty) {
        _ref.read(authExpiredProvider.notifier).execute();
        return super.onError(err, handler);
      }

      try {
        final retryResponse = await _retryRequestWithNewToken(
          err.requestOptions,
          tokenForRetry,
        );
        return handler.resolve(retryResponse);
      } on DioException catch (e, st) {
        Log.e('retry api call failed after token refresh: $e', stackTrace: st);
        return handler.reject(e);
      } catch (e, st) {
        Log.e('retry api call failed after token refresh: $e', stackTrace: st);
        return super.onError(err, handler);
      }
    }

    _ref.read(authExpiredProvider.notifier).execute();

    return super.onError(err, handler);
  }

  Future<String?> _getTokenForRetry(RequestOptions originalRequest) async {
    if (_ref.read(authExpiredProvider)) {
      Log.i('refresh already failed; skip refresh and propagate 401');
      return null;
    }

    final inFlight = _refreshInFlight;
    if (inFlight != null) {
      Log.i('refresh already in-flight; waiting for token');
      try {
        return await inFlight.timeout(_refreshTimeout);
      } catch (_) {
        return null;
      }
    }

    final currentToken = await _ref.read(authUsecaseProvider).getAccessToken();
    final usedToken = _extractBearerTokenFromRequestOptions(originalRequest);

    if (currentToken != null && currentToken.isNotEmpty) {
      if (usedToken != null &&
          usedToken.isNotEmpty &&
          usedToken != currentToken) {
        Log.i('access token already updated; retrying without refresh');
        return currentToken;
      }
    }

    Log.i(
      '401006 detected: starting refresh; original=${originalRequest.method} ${originalRequest.uri}',
    );
    return await _refreshAccessTokenSingleFlight();
  }

  String? _extractBearerTokenFromRequestOptions(RequestOptions options) {
    final dynamic headerValue =
        options.headers[_authorizationHeader] ??
        options.headers['Authorization'];
    if (headerValue is! String) return null;

    final value = headerValue.trim();
    if (!value.startsWith(_bearerPrefix)) return null;
    return value.substring(_bearerPrefix.length).trim();
  }

  Future<bool> _waitForRefreshIfNeeded(RequestOptions options) async {
    final requiresToken = _requiresAccessToken(options);
    if (!requiresToken) return true;
    if (_shouldSkipAuth(options) || _isRefreshRequest(options)) return true;

    if (_ref.read(authExpiredProvider)) {
      return false;
    }

    final inFlight = _refreshInFlight;
    if (inFlight == null) return true;

    try {
      final token = await inFlight.timeout(_refreshTimeout);
      return token != null && token.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  DioException _buildUnauthorizedException(
    RequestOptions options, {
    required String reason,
  }) {
    final response = Response<dynamic>(
      requestOptions: options,
      statusCode: _unauthorizedStatusCode,
      statusMessage: 'Unauthorized',
    );

    return DioException(
      requestOptions: options,
      response: response,
      type: DioExceptionType.badResponse,
      error: reason,
    );
  }

  Future<void> _attachAccessTokenIfRequired(RequestOptions options) async {
    final requiresToken = _requiresAccessToken(options);
    if (requiresToken) {
      final token = await _ref.read(authUsecaseProvider).getAccessToken();
      if (token != null) {
        options.headers[_authorizationHeader] = '$_bearerPrefix$token';
      }
    }
  }

  bool _requiresAccessToken(RequestOptions options) {
    if (options.extra.containsKey(requiresAccessTokenExtraKey)) {
      return options.extra[requiresAccessTokenExtraKey] == true;
    }
    return true;
  }

  Future<String?> _extractAndSaveTokens(
    Map<String, List<String>> headers, {
    required Uri responseUri,
  }) async {
    final newAccessToken = _extractAccessToken(headers);
    await _extractAndSaveRefreshToken(headers, responseUri: responseUri);

    if (newAccessToken != null) {
      _saveAccessToken(newAccessToken);
      return newAccessToken;
    }

    return null;
  }

  String? _extractAccessToken(Map<String, List<String>> headers) {
    final authHeader =
        headers[_authorizationHeader]?.first ?? headers['Authorization']?.first;

    if (authHeader != null && authHeader.startsWith(_bearerPrefix)) {
      return authHeader.replaceFirst(_bearerPrefix, '');
    }

    return null;
  }

  Future<void> _extractAndSaveRefreshToken(
    Map<String, List<String>> headers, {
    required Uri responseUri,
  }) async {
    final setCookieList = headers[_setCookieHeader];

    if (setCookieList == null || setCookieList.isEmpty) {
      return;
    }

    final cookies = setCookieList
        .map((cookie) => Cookie.fromSetCookieValue(cookie))
        .toList();

    final refreshDio = _refreshDio;
    final hasCookieManager =
        _dio.interceptors.any((i) => i is CookieManager) ||
        (refreshDio?.interceptors.any((i) => i is CookieManager) ?? false);
    if (!hasCookieManager) {
      await _cookieJar.saveFromResponse(responseUri, cookies);
    }

    final refreshToken = _extractRefreshTokenFromCookies(setCookieList);

    if (refreshToken != null && refreshToken.isNotEmpty) {
      await _ref
          .read(localStorageProvider)
          .saveEncrypted(SecureStorageItem.refreshToken, refreshToken);
      return;
    }

    return;
  }

  String? _extractRefreshTokenFromCookies(List<String> cookies) {
    final refreshTokenPattern = RegExp(r'refresh_token=([^;]+)');

    for (final cookie in cookies) {
      final match = refreshTokenPattern.firstMatch(cookie);
      if (match != null) {
        return match.group(1);
      }
    }

    return null;
  }

  void _saveAccessToken(String token) {
    _ref.read(authUsecaseProvider).setAccessToken(token);
  }

  bool _alreadyRetriedOptions(RequestOptions options) {
    return options.extra[retryExtraKey] == true;
  }

  Future<Response> _retryRequestWithNewToken(
    RequestOptions originalRequest,
    String accessToken,
  ) async {
    final newOptions = _buildRetryRequestOptions(originalRequest);

    newOptions.headers.remove('Authorization');
    newOptions.headers.remove('authorization');
    newOptions.headers[_authorizationHeader] = '$_bearerPrefix$accessToken';

    final response = await _dioForRefresh.fetch(newOptions);
    try {
      await _extractAndSaveTokens(
        response.headers.map,
        responseUri: response.realUri,
      );
    } catch (e, st) {
      Log.e('token extraction/save failed: $e', stackTrace: st);
    }
    return response;
  }

  RequestOptions _buildRetryRequestOptions(RequestOptions original) {
    return original.copyWith(
      headers: Map<String, dynamic>.of(original.headers),
      extra: {...original.extra, retryExtraKey: true},
    );
  }

  bool _isUnauthorizedError(DioException err) {
    return err.response?.statusCode == _unauthorizedStatusCode;
  }

  String? _extractUnauthorizedCode(DioException err) {
    final data = err.response?.data;
    if (data is! Map) return null;
    final code = data['code'];
    if (code is String && code.isNotEmpty) return code;
    return null;
  }

  bool _shouldSkipAuth(RequestOptions options) {
    return options.extra[skipAuthExtraKey] == true;
  }

  bool _isRefreshRequest(RequestOptions options) {
    final path = options.path;
    final uriPath = options.uri.path;
    return path.endsWith(_refreshPath) || uriPath.endsWith('/$_refreshPath');
  }

  Future<String?> _refreshAccessTokenSingleFlight() async {
    final inFlight = _refreshInFlight;
    if (inFlight != null) return inFlight;

    final completer = Completer<String?>();
    _refreshInFlight = completer.future;

    try {
      await _ensureRefreshTokenCookiePresent();

      final refreshUri = _buildRefreshUri();
      if (refreshUri == null) {
        Log.e('token refresh failed: missing baseUrl');
        completer.complete(null);
        return completer.future;
      }

      final response = await _dioForRefresh
          .postUri(
            refreshUri,
            data: null,
            options: Options(
              validateStatus: (status) => status != null && status < 500,
              extra: {
                skipAuthExtraKey: true,
                requiresAccessTokenExtraKey: false,
              },
            ),
          )
          .timeout(_refreshTimeout);

      if (response.statusCode != 200) {
        Log.e(
          'token refresh rejected: status=${response.statusCode} uri=${response.realUri} body=${_redactSensitiveBody(response.data)}',
        );
        completer.complete(null);
        return completer.future;
      }

      try {
        await _extractAndSaveTokens(
          response.headers.map,
          responseUri: response.realUri,
        );
      } catch (e, st) {
        Log.e('token extraction/save failed: $e', stackTrace: st);
      }

      final token = _extractAccessTokenFromRefreshBody(response.data);
      if (token != null && token.isNotEmpty) {
        _saveAccessToken(token);
      }
      completer.complete(token);
    } catch (e, st) {
      Log.e('token refresh failed: $e', stackTrace: st);
      completer.complete(null);
    } finally {
      _refreshInFlight = null;
    }

    return completer.future;
  }

  Future<void> _ensureRefreshTokenCookiePresent() async {
    final baseUrl = _dio.options.baseUrl;
    if (baseUrl.isEmpty) return;

    final refreshUri = _buildRefreshUri();
    if (refreshUri == null) return;
    final cookies = await _cookieJar.loadForRequest(refreshUri);
    final hasRefreshCookie = cookies.any(
      (c) => c.name == 'refresh_token' && c.value.isNotEmpty,
    );
    if (hasRefreshCookie) return;

    final refreshToken = await _ref.read(authUsecaseProvider).getRefreshToken();
    if (refreshToken == null || refreshToken.isEmpty) return;

    final seedCookie = Cookie('refresh_token', refreshToken)..path = '/';
    await _cookieJar.saveFromResponse(refreshUri, [seedCookie]);
  }

  String? _extractAccessTokenFromRefreshBody(dynamic body) {
    if (body is! Map || body['data'] is! Map) return null;
    final data = body['data'];

    final accessToken = data['accessToken'];
    if (accessToken is! String || accessToken.isEmpty) return null;
    return accessToken;
  }

  Object? _redactSensitiveBody(dynamic body) {
    if (body is Map) {
      final copy = <String, dynamic>{};
      for (final entry in body.entries) {
        final key = entry.key?.toString() ?? '';
        final value = entry.value;

        if (key == 'accessToken' || key == 'refreshToken' || key == 'token') {
          copy[key] = '***';
        } else if (value is Map || value is List) {
          copy[key] = _redactSensitiveBody(value);
        } else {
          copy[key] = value;
        }
      }
      return copy;
    }

    if (body is List) {
      return body.map(_redactSensitiveBody).toList();
    }

    return body;
  }
}
