import 'dart:async';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:deepple_app/core/mixin/log_mixin.dart';
import 'package:deepple_app/core/network/enum/token_unauthorized_code.dart';
import 'package:deepple_app/core/provider/auth_expired_provider.dart';
import 'package:deepple_app/core/storage/local_storage.dart';
import 'package:deepple_app/core/storage/local_storage_item.dart';
import 'package:deepple_app/core/util/log.dart';
import 'package:deepple_app/features/auth/data/usecase/auth_usecase_impl.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TokenInterceptor extends QueuedInterceptor with LogMixin {
  static const String _requiresAccessTokenKey = 'requiresAccessToken';
  static const String _authorizationHeader = 'authorization';
  static const String _bearerPrefix = 'Bearer ';
  static const String _setCookieHeader = 'set-cookie';
  static const String _retryExtraKey = 'retry';
  static const String _skipAuthExtraKey = 'skipAuth';
  static const String _requiresAccessTokenExtraKey = 'requiresAccessTokenExtra';
  static const int _unauthorizedStatusCode = 401;
  static const String _refreshPath = '/member/refresh';
  static const Duration _refreshTimeout = Duration(seconds: 15);

  final Ref _ref;
  final Dio _dio;
  final PersistCookieJar _cookieJar;

  Future<String?>? _refreshInFlight;

  TokenInterceptor({
    required Ref ref,
    required Dio dio,
    required PersistCookieJar cookieJar,
  }) : _ref = ref,
       _dio = dio,
       _cookieJar = cookieJar;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final ok = await _waitForRefreshIfNeeded(options);
    if (!ok) {
      _ref.read(authExpiredProvider.notifier).execute();
      return handler.reject(
        DioException(
          requestOptions: options,
          error: StateError('Token refresh failed'),
          type: DioExceptionType.unknown,
        ),
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

    await _extractAndSaveTokens(headers, responseUri: response.realUri);
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

    final requiresAccessToken =
        err.requestOptions.extra[_requiresAccessTokenExtraKey] == true;
    if (!requiresAccessToken) {
      return super.onError(err, handler);
    }

    final code = _extractUnauthorizedCode(err);

    if (code != null && TokenUnauthorizedCode.isExpiredAccessToken(code)) {
      if (!requiresAccessToken || _alreadyRetriedOptions(err.requestOptions)) {
        _ref.read(authExpiredProvider.notifier).execute();
        return super.onError(err, handler);
      }

      final newAccessToken = await _refreshAccessTokenSingleFlight();
      if (newAccessToken == null || newAccessToken.isEmpty) {
        _ref.read(authExpiredProvider.notifier).execute();
        return super.onError(err, handler);
      }

      try {
        final retryResponse = await _retryRequestWithNewToken(
          err.requestOptions,
          newAccessToken,
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

  Future<bool> _waitForRefreshIfNeeded(RequestOptions options) async {
    final requiresToken = options.headers[_requiresAccessTokenKey] == true;
    if (!requiresToken) return true;
    if (_shouldSkipAuth(options) || _isRefreshRequest(options)) return true;

    final inFlight = _refreshInFlight;
    if (inFlight == null) return true;

    try {
      final token = await inFlight.timeout(_refreshTimeout);
      return token != null && token.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  Future<void> _attachAccessTokenIfRequired(RequestOptions options) async {
    final requiresToken = options.headers[_requiresAccessTokenKey];

    if (requiresToken == true) {
      options.extra[_requiresAccessTokenExtraKey] = true;
    }

    if (requiresToken == true) {
      final token = await _ref.read(authUsecaseProvider).getAccessToken();
      if (token != null) {
        options.headers[_authorizationHeader] = '$_bearerPrefix$token';
      }
    }

    options.headers.remove(_requiresAccessTokenKey);
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
    await _cookieJar.saveFromResponse(responseUri, cookies);

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
    return options.extra[_retryExtraKey] == true;
  }

  Future<Response> _retryRequestWithNewToken(
    RequestOptions originalRequest,
    String accessToken,
  ) async {
    final newOptions = _buildRetryRequestOptions(originalRequest);

    newOptions.headers.remove('Authorization');
    newOptions.headers.remove('authorization');
    newOptions.headers[_authorizationHeader] = '$_bearerPrefix$accessToken';

    return _dio.fetch(newOptions);
  }

  RequestOptions _buildRetryRequestOptions(RequestOptions original) {
    return original.copyWith(
      headers: Map<String, dynamic>.of(original.headers),
      extra: {...original.extra, _retryExtraKey: true},
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
    return options.extra[_skipAuthExtraKey] == true;
  }

  bool _isRefreshRequest(RequestOptions options) {
    return options.path == _refreshPath || options.path.endsWith(_refreshPath);
  }

  Future<String?> _refreshAccessTokenSingleFlight() async {
    final inFlight = _refreshInFlight;
    if (inFlight != null) return inFlight;

    final completer = Completer<String?>();
    _refreshInFlight = completer.future;

    try {
      await _ensureRefreshTokenCookiePresent();

      final response = await _dio
          .post(
            _refreshPath,
            data: null,
            options: Options(
              headers: {_requiresAccessTokenKey: false},
              extra: {_skipAuthExtraKey: true},
            ),
          )
          .timeout(_refreshTimeout);

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

    final refreshUri = Uri.parse(baseUrl).resolve(_refreshPath);
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
}
