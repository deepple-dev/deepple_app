import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:deepple_app/core/util/log.dart';

/*
비동기 작업을 실행하기 전에 onStart, 성공 시 onSuccess, 실패 시 onError,
완료 시 onComplete를 선택적으로 제공 가능
 */
abstract class BaseNotifier<T> extends AsyncNotifier<T> {
  // ignore: use_super_parameters
  BaseNotifier(T state) : super();

  /// 안전한 함수 실행을 위한 `runNotifierCatching`
  Future<void> runNotifierCatching({
    required Future<void> Function() action,
    Future<void> Function()? onStart,
    Future<void> Function()? onSuccess,
    Future<void> Function(Object error)? onError,
    Future<void> Function()? onComplete,
    bool showToastOnError = true,
  }) async {
    try {
      if (onStart != null) await onStart();
      await action();
      if (onSuccess != null) await onSuccess();
    } catch (e, stackTrace) {
      if (onError != null) {
        await onError(e);
      }
      // 에러 알람 toast로 띄우기
      if (showToastOnError) {
        Fluttertoast.showToast(
          msg: 'Error: $e',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
      }
      Log.e('Error in BaseNotifier: ${e.runtimeType}');
    } finally {
      if (onComplete != null) await onComplete();
    }
  }
}

/*
< 사용 예시 >
final exampleProvider = StateNotifierProvider<ExampleNotifier, String>(
  (ref) => ExampleNotifier(),
);

class ExampleNotifier extends BaseNotifier<String> {
  ExampleNotifier() : super("Initial State");

  Future<void> loadData() async {
    await runNotifierCatching(
      action: () async {
        // 비동기 작업 실행
        await Future.delayed(Duration(seconds: 2));
        state = "Data Loaded!";
      },
      onStart: () async {
        // 시작 시 로딩 상태 표시
        state = "Loading...";
      },
      onSuccess: () async {
        // 성공 시 로그
        Log.d("Data loaded successfully.");
      },
      onError: (error) async {
        // 에러 발생 시 상태 설정
        state = "Error occurred!";
      },
    );
  }
}


class ExampleScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(exampleNotifierProvider);

    return Scaffold(
      appBar: AppBar(title: Text("Example")),
      body: Center(
        child: Text(state),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => ref.read(exampleNotifierProvider.notifier).loadData(),
        child: Icon(Icons.download),
      ),
    );
  }
}

 */
