import 'package:cookie_jar/cookie_jar.dart';
import 'package:deepple_app/core/config/config.dart';
import 'package:deepple_app/core/mixin/log_mixin.dart';
import 'package:deepple_app/core/provider/auth_expired_provider.dart';
import 'package:deepple_app/core/storage/local_storage.dart';
import 'package:deepple_app/core/storage/local_storage_item.dart';
import 'package:deepple_app/core/util/log.dart';
import 'package:deepple_app/features/auth/data/usecase/auth_usecase_impl.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// HTTP 요청에 인증 토큰을 자동으로 추가하고
/// 응답에서 토큰 갱신을 처리하는 Interceptor
class TokenInterceptor extends Interceptor with LogMixin {
  // Constants
  static const String _requiresAccessTokenKey = 'requiresAccessToken';
  static const String _authorizationHeader = 'authorization';
  static const String _bearerPrefix = 'Bearer ';
  static const String _setCookieHeader = 'set-cookie';
  static const String _retryExtraKey = 'retry';
  static const int _unauthorizedStatusCode = 401;

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
    Log.d(headers);

    // 응답 헤더에서 새 토큰 추출 및 저장
    final newAccessToken = await _extractAndSaveTokens(headers);

    // 토큰만 내려온 경우 재요청 처리
    final shouldRetry = _shouldRetryRequest(response);
    if (newAccessToken != null && shouldRetry) {
      final retryResponse = await _retryRequestWithNewToken(
        response,
        newAccessToken,
      );
      if (retryResponse != null) {
        return handler.resolve(retryResponse);
      }
    }

    super.onResponse(response, handler);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    _logError(err);

    if (_isUnauthorizedError(err)) {
      _ref.read(authExpiredProvider.notifier).execute();
    }

    super.onError(err, handler);
  }

  /// 요청에 Access Token 첨부 (필요한 경우에만)
  Future<void> _attachAccessTokenIfRequired(RequestOptions options) async {
    final requiresToken = options.headers[_requiresAccessTokenKey];

    if (requiresToken == true) {
      final token = await _ref.read(authUsecaseProvider).getAccessToken();
      if (token != null) {
        options.headers[_authorizationHeader] = '$_bearerPrefix$token';
      }
    }

    // 커스텀 헤더 제거
    options.headers.remove(_requiresAccessTokenKey);
  }

  /// 응답 헤더에서 새 토큰들을 추출하고 저장
  Future<String?> _extractAndSaveTokens(
    Map<String, List<String>> headers,
  ) async {
    final newAccessToken = _extractAccessToken(headers);
    await _extractAndSaveRefreshToken(headers);

    if (newAccessToken != null) {
      _saveAccessToken(newAccessToken);
      return newAccessToken;
    }

    return null;
  }

  /// Access Token 추출
  String? _extractAccessToken(Map<String, List<String>> headers) {
    final authHeader = headers[_authorizationHeader]?.first;

    if (authHeader != null && authHeader.startsWith(_bearerPrefix)) {
      return authHeader.replaceFirst(_bearerPrefix, '');
    }

    return null;
  }

  /// Refresh Token 추출 및 저장
  Future<void> _extractAndSaveRefreshToken(
    Map<String, List<String>> headers,
  ) async {
    final setCookieList = headers[_setCookieHeader];

    if (setCookieList == null || setCookieList.isEmpty) {
      return;
    }

    // CookieJar에 쿠키 저장
    final uri = Uri.parse(Config.baseUrl);
    final cookies = setCookieList
        .map((cookie) => Cookie.fromSetCookieValue(cookie))
        .toList();

    await _cookieJar.saveFromResponse(uri, cookies);

    // Refresh Token 추출 및 안전한 저장소에 저장
    final refreshToken = _extractRefreshTokenFromCookies(setCookieList);

    if (refreshToken != null && refreshToken.isNotEmpty) {
      await _ref
          .read(localStorageProvider)
          .saveEncrypted(SecureStorageItem.refreshToken, refreshToken);
      return;
    }

    return;
  }

  /// 쿠키 리스트에서 Refresh Token 추출
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

  /// Access Token 저장
  void _saveAccessToken(String token) {
    _ref
        .read(localStorageProvider)
        .saveEncrypted(SecureStorageItem.accessToken, token);
  }

  /// 재요청이 필요한지 판단
  bool _shouldRetryRequest(Response response) {
    final headers = response.headers.map;
    final hasNewAccessToken = _extractAccessToken(headers) != null;
    final hasNewRefreshToken = headers[_setCookieHeader]?.isNotEmpty ?? false;
    final hasEmptyBody = _hasEmptyResponseBody(response);
    final alreadyRetried =
        response.requestOptions.extra[_retryExtraKey] == true;

    return hasNewAccessToken &&
        hasNewRefreshToken &&
        hasEmptyBody &&
        !alreadyRetried;
  }

  /// 응답 바디가 비어있는지 확인
  bool _hasEmptyResponseBody(Response response) {
    return response.data == null ||
        (response.data is Map && (response.data as Map).isEmpty);
  }

  /// 새 토큰으로 요청 재시도
  Future<Response?> _retryRequestWithNewToken(
    Response originalResponse,
    String accessToken,
  ) async {
    try {
      final newOptions = _buildRetryRequestOptions(
        originalResponse.requestOptions,
      );

      newOptions.headers[_authorizationHeader] = '$_bearerPrefix$accessToken';

      return await _dio.fetch(newOptions);
    } catch (e) {
      Log.e('재요청 실패: $e');
      return null;
    }
  }

  /// 재요청용 RequestOptions 생성
  RequestOptions _buildRetryRequestOptions(RequestOptions original) {
    return original.copyWith(
      headers: Map<String, dynamic>.of(original.headers),
      extra: {...original.extra, _retryExtraKey: true},
    );
  }

  /// 401 Unauthorized 에러인지 확인
  bool _isUnauthorizedError(DioException err) {
    return err.response?.statusCode == _unauthorizedStatusCode;
  }

  /// API 에러 로깅
  void _logError(DioException err) {
    final method = err.requestOptions.method;
    final path = err.requestOptions.path;
    final message = err.response?.statusMessage;

    Log.e('[$method $path] API 에러: $message');
  }
}
