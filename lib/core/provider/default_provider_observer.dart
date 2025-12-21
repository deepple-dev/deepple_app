import 'dart:convert'; // JSON 포맷팅을 위한 패키지
import 'package:deepple_app/core/util/log.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


/// Provider의 생명주기 이벤트 및 상태 변화를 감지하고 디버그 로그를 출력하기 위한 클래스로,
/// /// ProviderObserver를 확장하여 상태 변경 및 에러를 로깅
final class DefaultProviderObserver extends ProviderObserver {
  @override
  void didAddProvider(ProviderObserverContext context, Object? value) {
    final provider = context.provider;
    Log.d('provider added: ${provider.name ?? provider.runtimeType}');
    super.didAddProvider(context, value);
  }

  @override
  void didUpdateProvider(
    ProviderObserverContext context,
    Object? previousValue,
    Object? newValue,
  ) {
    final provider = context.provider;
    final formattedNewValue = _formatState(newValue);

    Log.d(
      'provider updated: ${provider.name ?? provider.runtimeType} / new value: $formattedNewValue}',
    );
    super.didUpdateProvider(context, previousValue, newValue);
  }

  @override
  void didDisposeProvider(ProviderObserverContext context) {
    final provider = context.provider;
    Log.d('provider disposed: ${provider.name ?? provider.runtimeType}');
    super.didDisposeProvider(context);
  }

  @override
  void providerDidFail(
    ProviderObserverContext context,
    Object error,
    StackTrace stackTrace,
  ) {
    final provider = context.provider;
    Log.e('provider throw [${error.runtimeType}]: ${provider.name ?? provider.runtimeType} ');

    super.providerDidFail(context, error, stackTrace);
  }

  // JSON 형식으로 변환하는 헬퍼 함수
  String _formatState(Object? state) {
    try {
      return const JsonEncoder.withIndent('  ').convert(state);
    } catch (e) {
      // JSON 변환에 실패하면 기본 toString 사용
      return state.toString();
    }
  }
}
