import 'package:flutter_riverpod/flutter_riverpod.dart';

final authExpiredProvider = NotifierProvider<AuthExpiredNotifier, bool>(
  AuthExpiredNotifier.new,
);

class AuthExpiredNotifier extends Notifier<bool> {
  @override
  bool build() => false;

  /// 401 발생 시 호출
  void execute() {
    if (state) return; // 중복 방지
    state = true;
  }

  /// 처리 완료 후 reset
  void reset() {
    state = false;
  }
}
