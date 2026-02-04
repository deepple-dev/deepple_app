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

class TokenInterceptor extends Interceptor with LogMixin {
  static const String _requiresAccessTokenKey = 'requiresAccessToken';
  static const String _authorizationHeader = 'authorization';
  static const String _bearerPrefix = 'Bearer ';
  static const String _setCookieHeader = 'set-cookie';
  static const String _retryExtraKey = 'retry';
  static const int _unauthorizedStatusCode = 401;
  static const int _tokenRefreshStatusCode = 205;

  final Ref _ref;
  final Dio _dio;
  final PersistCookieJar _cookieJar;

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
    await _attachAccessTokenIfRequired(options);
    super.onRequest(options, handler);
  }

  @override
  Future<void> onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) async {
    final headers = response.headers.map;

    if (!_isTokenRefreshResponse(response) || _alreadyRetried(response)) {
      await _extractAndSaveTokens(headers, responseUri: response.realUri);
      return super.onResponse(response, handler);
    }

    final newAccessToken = await _extractAndSaveTokens(
      headers,
      responseUri: response.realUri,
    );

    if (newAccessToken == null) {
      return super.onResponse(response, handler);
    }

    try {
      final retryResponse = await _retryRequestWithNewToken(
        response.requestOptions,
        newAccessToken,
      );
      return handler.resolve(retryResponse);
    } on DioException catch (e, st) {
      Log.e('retry api call failed after token refresh: $e', stackTrace: st);
      return handler.reject(e);
    } catch (e, st) {
      Log.e('retry api call failed after token refresh: $e', stackTrace: st);
      return super.onResponse(response, handler);
    }
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (_isUnauthorizedError(err) && _isTokenUnauthorized(err)) {
      _ref.read(authExpiredProvider.notifier).execute();
    }

    super.onError(err, handler);
  }

  Future<void> _attachAccessTokenIfRequired(RequestOptions options) async {
    final requiresToken = options.headers[_requiresAccessTokenKey];

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
    _ref
        .read(localStorageProvider)
        .saveEncrypted(SecureStorageItem.accessToken, token);
  }

  bool _isTokenRefreshResponse(Response response) {
    return response.statusCode == _tokenRefreshStatusCode;
  }

  bool _alreadyRetried(Response response) {
    return response.requestOptions.extra[_retryExtraKey] == true;
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

  bool _isTokenUnauthorized(DioException err) {
    final data = err.response?.data;

    if (data is! Map) return true;

    final code = data['code'];
    if (code is! String) return true;

    return TokenUnauthorizedCode.contains(code);
  }
}
