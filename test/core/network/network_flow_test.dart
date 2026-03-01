import 'package:deepple_app/core/provider/auth_expired_provider.dart';
import 'package:deepple_app/features/auth/data/usecase/auth_usecase_impl.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'network_test_support.dart';

void main() {
  setUpAll(registerNetworkTestFallbacks);

  group('ApiService / TokenInterceptor flows (mocked responses)', () {
    test('API 응답 확인 (ApiServiceImpl.request)', () async {
      // given
      TestWidgetsFlutterBinding.ensureInitialized();
      final appDocDir = await createTempDir('deepple_test_');
      await mockPathProvider(appDocDir);

      final auth = FakeAuthUseCase();
      final container = createTestContainer(authUseCase: auth);
      addTearDown(container.dispose);

      final api = await createInitializedApiService(container: container);
      api.dioService.httpClientAdapter = QueueHttpClientAdapter([
        (_) => jsonResponseBody({'ok': true}, 200),
      ]);

      // when
      final res = await runSimpleGet(api);

      // then
      expect(res['ok'], true);
    });

    test(
      '토큰 재발급(401006) + API 응답 확인 (TokenInterceptor refresh + retry)',
      () async {
        // given
        final dio = Dio(BaseOptions(baseUrl: 'https://mockserver'));

        final auth = MockAuthUseCase();
        final localStorage = MockLocalStorage();
        final cookieJar = MockPersistCookieJar();

        when(() => auth.getAccessToken()).thenAnswer((_) async => 'old');
        when(
          () => auth.getRefreshToken(),
        ).thenAnswer((_) async => 'stored_refresh');
        when(
          () => localStorage.saveEncrypted(any(), any()),
        ).thenAnswer((_) async => true);
        when(() => cookieJar.loadForRequest(any())).thenAnswer((_) async => []);
        when(
          () => cookieJar.saveFromResponse(any(), any()),
        ).thenAnswer((_) async {});

        final container = createTestContainer(
          authUseCase: auth,
          localStorage: localStorage,
        );
        addTearDown(container.dispose);

        dio.httpClientAdapter = QueueHttpClientAdapter([
          (_) => jsonResponseBody({'code': '401006'}, 401),
          (options) {
            expect(options.method, 'POST');
            expect(options.path, '/member/refresh');
            expect(options.extra['skipAuth'], true);
            return jsonResponseBody(
              {
                'status': 0,
                'code': 'OK',
                'message': '',
                'data': {'accessToken': 'new_access'},
              },
              200,
              headers: {
                'set-cookie': ['refresh_token=new_refresh; Path=/;'],
              },
            );
          },
          (options) {
            expect(options.extra['retry'], true);
            expect(options.headers['authorization'], 'Bearer new_access');
            return jsonResponseBody({'ok': true}, 200);
          },
        ]);
        dio.interceptors.add(
          container.read(
            tokenInterceptorProvider(
              InterceptorArgs(dio: dio, cookieJar: cookieJar),
            ),
          ),
        );

        // when
        final response = await runDioGet(dio);

        // then
        expect(response.data, isA<Map>());
        expect(response.data['ok'], true);
        verify(() => auth.setAccessToken('new_access')).called(1);
        await expectTokenSaved(
          localStorage: localStorage,
          refreshToken: 'new_refresh',
        );
        verify(() => cookieJar.saveFromResponse(any(), any())).called(2);
        expect(container.read(authExpiredProvider), false);
      },
    );

    testWidgets('401 응답시 로그아웃 로직 확인', (tester) async {
      // given
      final auth = FakeAuthUseCase();
      final adapter = QueueHttpClientAdapter([
        (_) => jsonResponseBody({'code': '401002'}, 401),
      ]);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [authUsecaseProvider.overrideWithValue(auth)],
          child: LogoutOn401Widget(adapter: adapter),
        ),
      );

      // when
      await trigger401AndWait(tester, find.byKey(const Key('call')));

      // then
      expectLogoutCalled(auth);
    });

    test('토큰 재발급 실패 시(401006 -> refresh error) 로그아웃 플래그 설정', () async {
      // given
      final dio = Dio(BaseOptions(baseUrl: 'https://mockserver'));
      final auth = FakeAuthUseCase();
      final cookieJar = MockPersistCookieJar();

      when(() => cookieJar.loadForRequest(any())).thenAnswer((_) async => []);
      when(
        () => cookieJar.saveFromResponse(any(), any()),
      ).thenAnswer((_) async {});

      final container = createTestContainer(authUseCase: auth);
      addTearDown(container.dispose);

      dio.httpClientAdapter = QueueHttpClientAdapter([
        (_) => jsonResponseBody({'code': '401006'}, 401),
        (options) {
          expect(options.method, 'POST');
          expect(options.path, '/member/refresh');
          return jsonResponseBody({'message': 'refresh failed'}, 500);
        },
      ]);
      dio.interceptors.add(
        container.read(
          tokenInterceptorProvider(
            InterceptorArgs(dio: dio, cookieJar: cookieJar),
          ),
        ),
      );

      // when
      try {
        await runDioGet(dio);
      } catch (_) {}

      // then
      expect(container.read(authExpiredProvider), true);
    });
  });
}
