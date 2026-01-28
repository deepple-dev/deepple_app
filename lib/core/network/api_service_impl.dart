import 'dart:async';

import 'package:deepple_app/core/config/config.dart';
import 'package:deepple_app/core/network/logging_interceptor.dart';
import 'package:deepple_app/core/storage/local_storage.dart';
import 'package:deepple_app/core/storage/local_storage_item.dart';
import 'package:deepple_app/core/util/log.dart';
import 'package:deepple_app/features/auth/data/usecase/auth_usecase_impl.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';

import 'package:deepple_app/core/network/api_service.dart';
import 'package:deepple_app/core/network/dio_service.dart';
import 'package:deepple_app/core/network/network_exception.dart';
import 'package:deepple_app/core/network/token_interceptor.dart';

final apiServiceProvider = Provider<ApiServiceImpl>((ref) {
  return ApiServiceImpl(
    ref: ref,
    baseUrl: Config.baseUrl,
    enableAuth: true,
    timeout: Config.timeout,
  );
});

class ApiServiceImpl implements ApiService {
  final Ref ref;
  late final String _baseUrl;
  late final DioService _dioService;
  late final PersistCookieJar _cookieJar;
  final Completer<void> _initCompleter = Completer();

  Future<void> ensureInitialized() => _initCompleter.future;

  PersistCookieJar get cookieJar => _cookieJar;

  DioService get dioService => _dioService;

  ApiServiceImpl({
    required this.ref,
    String? baseUrl,
    bool enableAuth = false,
    Duration? timeout,
  }) {
    _initialize(
      enableAuth: enableAuth,
      baseUrl: baseUrl,
      timeout: timeout ?? Config.timeout,
    );
  }

  Future<void> _initialize({
    required bool enableAuth,
    required String? baseUrl,
    required Duration timeout,
  }) async {
    try {
      _baseUrl = baseUrl ?? Config.baseUrl;
      final appDocDir = await getApplicationDocumentsDirectory();
      _cookieJar = PersistCookieJar(storage: FileStorage(appDocDir.path));

      _dioService = DioService(
        BaseOptions(
          baseUrl: _baseUrl,
          sendTimeout: timeout,
          connectTimeout: timeout,
          receiveTimeout: timeout,
        ),
      );

      if (enableAuth) {
        _dioService.interceptors.add(
          TokenInterceptor(ref: ref, dio: _dioService, cookieJar: cookieJar),
        );
      }

      if (!kReleaseMode) {
        _dioService.interceptors.add(LoggingInterceptor());
      }

      _dioService.interceptors.add(CookieManager(_cookieJar));
    } catch (e, st) {
      Log.e('초기화 실패: $e', stackTrace: st);
      if (!_initCompleter.isCompleted) {
        _initCompleter.completeError(e, st);
      }
      return;
    } finally {
      // 성공 case만 처리
      if (!_initCompleter.isCompleted) {
        _initCompleter.complete();
      }
    }
  }

  Future<Map<String, dynamic>> _prepareHeaders({
    Map<String, dynamic>? headers,
    bool requiresAccessToken = true,
  }) async {
    await _initCompleter.future;
    final finalHeaders = <String, dynamic>{'Accept': '*/*', ...?headers};

    if (!requiresAccessToken) return finalHeaders;

    final accessToken = await ref.read(authUsecaseProvider).getAccessToken();
    if (accessToken == null) return finalHeaders;

    finalHeaders['authorization'] = 'Bearer $accessToken';

    return finalHeaders;
  }

  Future<void> _handleLoginResponse(Response response) async {
    await _initCompleter.future;
    final setCookieHeaders = response.headers.map['set-cookie'];
    if (setCookieHeaders == null || setCookieHeaders.isEmpty) return;

    final refreshToken = _extractRefreshToken(setCookieHeaders);
    if (refreshToken == null) return;

    final uri = Uri.parse(_baseUrl);
    final cookies = setCookieHeaders
        .map((value) => Cookie.fromSetCookieValue(value))
        .toList();
    await _cookieJar.saveFromResponse(uri, cookies);

    await ref
        .read(localStorageProvider)
        .saveEncrypted(SecureStorageItem.refreshToken, refreshToken);
  }

  String? _extractRefreshToken(List<String> cookies) {
    return cookies
        .map((cookie) => RegExp(r'refresh_token=([^;]+)').firstMatch(cookie))
        .firstWhere((match) => match != null, orElse: () => null)
        ?.group(1);
  }

  @override
  Future<T> request<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    void Function(int, int)? onSendProgress,
    void Function(int, int)? onReceiveProgress,
    required String method,
    required String contentType,
    bool requiresAccessToken = true,
    bool requiresRefreshToken = false,
    bool requiresRefreshCookie = false,
    Converter<T>? converter,
    Map<String, dynamic>? headers,
  }) async {
    await _initCompleter.future;
    try {
      final finalHeaders = await _prepareHeaders(
        headers: headers,
        requiresAccessToken: requiresAccessToken,
      );

      final response = await _dioService.request(
        path,
        data: data,
        options: Options(
          method: method,
          contentType: contentType,
          headers: finalHeaders,
        ),
        queryParameters: queryParameters,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
        cancelToken: cancelToken,
      );

      if (path.contains('/login')) {
        await _handleLoginResponse(response);
      }

      return converter?.call(response.data) ?? response.data as T;
    } on DioException catch (e) {
      throw NetworkException.getException(e);
    } catch (error) {
      throw NetworkException.otherException(error.runtimeType);
    }
  }

  @override
  Future<void> cancelRequests({CancelToken? cancelToken}) async {
    await _initCompleter.future;
    _dioService.cancelRequests(cancelToken: cancelToken);
  }

  @override
  Future<T> deleteJson<T>(
    String path, {
    Json? queryParameters,
    bool requiresAccessToken = true,
    bool requiresRefreshToken = false,
    bool requiresRefreshCookie = false,
    Converter<T>? converter,
  }) => request(
    path,
    method: 'DELETE',
    contentType: Headers.jsonContentType,
    queryParameters: queryParameters,
    requiresAccessToken: requiresAccessToken,
    requiresRefreshToken: requiresRefreshToken,
    requiresRefreshCookie: requiresRefreshCookie,
    converter: converter,
  );

  @override
  Future<T> getJson<T>(
    String path, {
    Json? queryParameters,
    bool requiresAccessToken = true,
    bool requiresRefreshToken = false,
    bool requiresRefreshCookie = false,
    Converter<T>? converter,
    String? contentType,
    Map<String, dynamic>? headers,
  }) => request(
    path,
    method: 'GET',
    contentType: contentType ?? Headers.jsonContentType,
    queryParameters: queryParameters,
    requiresAccessToken: requiresAccessToken,
    requiresRefreshToken: requiresRefreshToken,
    requiresRefreshCookie: requiresRefreshCookie,
    converter: converter,
    headers: headers,
  );

  @override
  Future<T> putJson<T>(
    String path, {
    Object? data,
    Json? queryParameters,
    bool requiresAccessToken = true,
    bool requiresRefreshToken = false,
    bool requiresRefreshCookie = false,
    Converter<T>? converter,
    Map<String, dynamic>? headers,
  }) => request(
    path,
    method: 'PUT',
    contentType: headers?['Content-Type'] ?? Headers.jsonContentType,
    data: data,
    queryParameters: queryParameters,
    requiresAccessToken: requiresAccessToken,
    requiresRefreshToken: requiresRefreshToken,
    requiresRefreshCookie: requiresRefreshCookie,
    converter: converter,
  );

  @override
  Future<T> postJson<T>(
    String path, {
    required Object? data,
    Json? queryParameters,
    bool requiresAccessToken = true,
    bool requiresRefreshToken = false,
    bool requiresRefreshCookie = false,
    Converter<T>? converter,
    Map<String, dynamic>? headers,
  }) => request(
    path,
    method: 'POST',
    contentType: Headers.jsonContentType,
    data: data,
    queryParameters: queryParameters,
    requiresAccessToken: requiresAccessToken,
    requiresRefreshToken: requiresRefreshToken,
    requiresRefreshCookie: requiresRefreshCookie,
    converter: converter,
    headers: headers,
  );

  @override
  Future<T> postFormUrlEncoded<T>(
    String path, {
    required Object? data,
    Json? queryParameters,
    bool requiresAccessToken = true,
    bool requiresRefreshToken = false,
    bool requiresRefreshCookie = false,
    Converter<T>? converter,
  }) => request(
    path,
    method: 'POST',
    contentType: Headers.formUrlEncodedContentType,
    data: data,
    queryParameters: queryParameters,
    requiresAccessToken: requiresAccessToken,
    requiresRefreshToken: requiresRefreshToken,
    requiresRefreshCookie: requiresRefreshCookie,
    converter: converter,
  );

  @override
  Future<T> postFormData<T>(
    String path, {
    required FormData data,
    Json? queryParameters,
    bool requiresAccessToken = true,
    bool requiresRefreshToken = false,
    bool requiresRefreshCookie = false,
    Converter<T>? converter,
  }) => request(
    path,
    method: 'POST',
    contentType: Headers.multipartFormDataContentType,
    data: data,
    queryParameters: queryParameters,
    requiresAccessToken: requiresAccessToken,
    requiresRefreshToken: requiresRefreshToken,
    requiresRefreshCookie: requiresRefreshCookie,
    converter: converter,
  );

  @override
  Future<T> putFormUrlEncoded<T>(
    String path, {
    Object? data,
    Json? queryParameters,
    bool requiresAccessToken = true,
    bool requiresRefreshToken = false,
    bool requiresRefreshCookie = false,
    Converter<T>? converter,
  }) => request(
    path,
    method: 'PUT',
    contentType: Headers.formUrlEncodedContentType,
    data: data,
    queryParameters: queryParameters,
    requiresAccessToken: requiresAccessToken,
    requiresRefreshToken: requiresRefreshToken,
    requiresRefreshCookie: requiresRefreshCookie,
    converter: converter,
  );

  @override
  Future<T> patchJson<T>(
    String path, {
    Object? data,
    Json? queryParameters,
    bool requiresAccessToken = true,
    bool requiresRefreshToken = false,
    bool requiresRefreshCookie = false,
    Converter<T>? converter,
    Map<String, dynamic>? headers,
  }) => request(
    path,
    method: 'PATCH',
    contentType: Headers.jsonContentType,
    data: data,
    queryParameters: queryParameters,
    requiresAccessToken: requiresAccessToken,
    requiresRefreshToken: requiresRefreshToken,
    requiresRefreshCookie: requiresRefreshCookie,
    converter: converter,
    headers: headers,
  );
}
