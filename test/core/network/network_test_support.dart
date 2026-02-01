import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:deepple_app/core/network/api_service_impl.dart';
import 'package:deepple_app/core/network/token_interceptor.dart';
import 'package:deepple_app/core/provider/auth_expired_provider.dart';
import 'package:deepple_app/core/storage/local_storage.dart';
import 'package:deepple_app/core/storage/local_storage_item.dart';
import 'package:deepple_app/features/auth/data/dto/profile_upload_request.dart';
import 'package:deepple_app/features/auth/data/dto/user_response.dart';
import 'package:deepple_app/features/auth/data/dto/user_sign_in_request.dart';
import 'package:deepple_app/features/auth/data/usecase/auth_usecase_impl.dart';
import 'package:deepple_app/features/auth/domain/usecase/auth_usecase.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class LogoutOn401Widget extends ConsumerWidget {
  const LogoutOn401Widget({super.key, required this.adapter});

  final HttpClientAdapter adapter;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dio = ref.watch(dioWithTokenInterceptorProvider(adapter));

    ref.listen<bool>(authExpiredProvider, (prev, next) async {
      if (!next) return;
      await ref.read(authUsecaseProvider).signOut(isTokenExpiredSignOut: true);
      ref.read(authExpiredProvider.notifier).reset();
    });

    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: ElevatedButton(
            key: const Key('call'),
            onPressed: () async {
              try {
                await dio.get('/resource');
              } catch (_) {}
            },
            child: const Text('call'),
          ),
        ),
      ),
    );
  }
}

class QueueHttpClientAdapter implements HttpClientAdapter {
  QueueHttpClientAdapter(this._stubs);

  final List<ResponseBody Function(RequestOptions)> _stubs;
  var _i = 0;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    if (_i >= _stubs.length) {
      throw StateError('No stub left for ${options.method} ${options.uri}');
    }
    return _stubs[_i++](options);
  }

  @override
  void close({bool force = false}) {}
}

class FakeAuthUseCase implements AuthUseCase {
  var signOutCalls = 0;
  bool? lastIsTokenExpiredSignOut;

  @override
  Future<bool> signOut({bool isTokenExpiredSignOut = false}) async {
    signOutCalls++;
    lastIsTokenExpiredSignOut = isTokenExpiredSignOut;
    return true;
  }

  @override
  Future<String?> getAccessToken() async => null;

  @override
  Future<String?> getRefreshToken() async => null;

  @override
  Future<void> activateAccount(String phoneNumber) async {}

  @override
  Future<void> rescreenProfile() async {}

  @override
  Future<void> sendSmsVerificationCode(String phoneNumber) async {}

  @override
  void setAccessToken(String accessToken) {}

  @override
  Future<UserData> signIn(UserSignInRequest user) {
    throw UnimplementedError();
  }

  @override
  Future<void> uploadProfile(ProfileUploadRequest profileData) async {}
}

class MockLocalStorage extends Mock implements LocalStorage {}

class MockAuthUseCase extends Mock implements AuthUseCase {}

class MockPersistCookieJar extends Mock implements PersistCookieJar {}

class TestLocalStorageNotifier extends LocalStorageNotifier {
  TestLocalStorageNotifier(this._storage);
  final LocalStorage _storage;

  @override
  LocalStorage build() => _storage;
}

class InterceptorArgs {
  const InterceptorArgs({required this.dio, required this.cookieJar});
  final Dio dio;
  final PersistCookieJar cookieJar;
}

final tokenInterceptorProvider =
    Provider.family<TokenInterceptor, InterceptorArgs>((ref, args) {
      return TokenInterceptor(
        ref: ref,
        dio: args.dio,
        cookieJar: args.cookieJar,
      );
    });

final dioWithTokenInterceptorProvider = Provider.family<Dio, HttpClientAdapter>(
  (ref, adapter) {
    final dio = Dio(BaseOptions(baseUrl: 'https://mockserver'));
    dio.httpClientAdapter = adapter;

    final cookieDir = Directory.systemTemp.createTempSync('deepple_cookie_');
    final cookieJar = PersistCookieJar(storage: FileStorage(cookieDir.path));
    dio.interceptors.add(
      ref.read(
        tokenInterceptorProvider(
          InterceptorArgs(dio: dio, cookieJar: cookieJar),
        ),
      ),
    );
    return dio;
  },
);

ResponseBody jsonResponseBody(
  Object json,
  int statusCode, {
  Map<String, List<String>>? headers,
}) {
  return ResponseBody.fromString(
    jsonEncode(json),
    statusCode,
    headers: {
      Headers.contentTypeHeader: [Headers.jsonContentType],
      ...?headers,
    },
  );
}

Future<void> mockPathProvider(Directory appDocDir) async {
  const channel = MethodChannel('plugins.flutter.io/path_provider');
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(channel, (call) async {
        if (call.method == 'getApplicationDocumentsDirectory') {
          return appDocDir.path;
        }
        return null;
      });
}

Future<ApiServiceImpl> createInitializedApiService({
  required ProviderContainer container,
  bool enableAuth = false,
}) async {
  final apiProvider = Provider<ApiServiceImpl>((ref) {
    return ApiServiceImpl(
      ref: ref,
      baseUrl: 'https://mockserver',
      enableAuth: enableAuth,
    );
  });

  final api = container.read(apiProvider);
  await api.ensureInitialized();
  return api;
}

ProviderContainer createTestContainer({
  AuthUseCase? authUseCase,
  LocalStorage? localStorage,
}) {
  return ProviderContainer(
    overrides: [
      if (authUseCase != null)
        authUsecaseProvider.overrideWithValue(authUseCase),
      if (localStorage != null)
        localStorageProvider.overrideWith(
          () => TestLocalStorageNotifier(localStorage),
        ),
    ],
  );
}

void registerNetworkTestFallbacks() {
  registerFallbackValue(RequestOptions(path: '/'));
  registerFallbackValue(SecureStorageItem.accessToken);
  registerFallbackValue(Uri.parse('https://mockserver'));
}

Future<void> expectTokenSaved({
  required MockLocalStorage localStorage,
  required String accessToken,
  required String refreshToken,
}) async {
  verify(
    () =>
        localStorage.saveEncrypted(SecureStorageItem.accessToken, accessToken),
  ).called(1);
  verify(
    () => localStorage.saveEncrypted(
      SecureStorageItem.refreshToken,
      refreshToken,
    ),
  ).called(1);
}

Future<Map<String, dynamic>> runSimpleGet(ApiServiceImpl api) {
  return api.getJson<Map<String, dynamic>>('/hello');
}

Future<Response<dynamic>> runDioGet(Dio dio) {
  return dio.get('/resource');
}

void expectLogoutCalled(FakeAuthUseCase auth) {
  expect(auth.signOutCalls, 1);
  expect(auth.lastIsTokenExpiredSignOut, true);
}

Future<void> trigger401AndWait(WidgetTester tester, Finder callButton) async {
  await tester.tap(callButton);
  await tester.pumpAndSettle();
}

Future<Directory> createTempDir(String prefix) {
  return Directory.systemTemp.createTemp(prefix);
}
