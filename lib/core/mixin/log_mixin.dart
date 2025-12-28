import 'package:deepple_app/core/util/log.dart';

/// Common using log data, log error in class
// mixin: 여러 클래스에 공통 기능을 추가할 수 있는 Dart의 기능
// mixin을 통해 클래스에 중복 없이 로직을 추가할 수 있다.
// 상속과 다르게 여러 클래스에 동시에 적용할 수 있다.
mixin LogMixin on Object {
  // on Object: Object를 상속하는 클래스에서만 LogMixin 믹스인을 사용 가능
  // 사실상 모든 클래스에서 사용 가능함

  // 디버그 로그 출력 메서드 logE()
  void logD(String message, {DateTime? time}) {
    Log.d(message, name: runtimeType.toString(), time: time);
  }

  void logE(
    Object? errorMessage, {
    Object? errorObject,
    StackTrace? stackTrace,
    DateTime? time,
  }) {
    Log.e(
      errorMessage,
      name: runtimeType.toString(), // 호출된 클래스 이름(runtimeType)을 자동으로 로그에 포함
      errorObject: errorObject,
      stackTrace: stackTrace,
      time: time,
    );
  }
}
