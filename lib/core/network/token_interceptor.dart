import 'package:deepple_app/app/router/router.dart';
import 'package:deepple_app/core/mixin/log_mixin.dart';
import 'package:deepple_app/core/util/log.dart';
import 'package:deepple_app/features/auth/data/usecase/auth_usecase_impl.dart';
import 'package:deepple_app/app/router/routing.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Add token in header call API
class TokenInterceptor extends Interceptor with LogMixin {
  final Ref ref;

  TokenInterceptor(this.ref) : super();

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (options.headers.containsKey('requiresAccessToken')) {
      if (options.headers['requiresAccessToken'] == true) {
        final token = await ref.read(authUsecaseProvider).getAccessToken();
        options.headers.addAll(<String, Object?>{
          'Authorization': 'Bearer $token',
        });
      }

      options.headers.remove('requiresAccessToken');
    }
    return handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final authService = ref.read(authUsecaseProvider);
    final router = ref.read(routerProvider);

    if (err.response?.statusCode == 401) {
      final authService = ref.read(authUsecaseProvider);
      // TODO(helljh): token 갱신 시나리오
      // final newToken = await authService.getAccessToken();

      authService.signOut();
      router.goNamed(AppRoute.onboard.name);
    }

    super.onError(err, handler);
  }
}
