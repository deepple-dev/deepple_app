import 'package:deepple_app/core/util/log.dart';
import 'package:deepple_app/features/introduce/domain/provider/introduce_add_state.dart';
import 'package:deepple_app/features/introduce/domain/usecase/introduce_add_use_case.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'introduce_add_notifier.g.dart';

@Riverpod(keepAlive: false)
class IntroduceAddNotifier extends _$IntroduceAddNotifier {
  @override
  IntroduceAddState build() {
    return const IntroduceAddState(canSubmit: false);
  }

  void setTitle(String t) {
    final title = t.trim();
    state = state.copyWith(
      title: title,
      canSubmit: title.isNotEmpty && (state.content?.isNotEmpty ?? false),
    );
  }

  void setContent(String t) {
    final content = t.trim();
    state = state.copyWith(
      content: content,
      canSubmit: content.isNotEmpty && (state.title?.isNotEmpty ?? false),
    );
  }

  /// 셀프 소개 입력
  Future<void> addIntroduce({
    required String title,
    required String content,
  }) async {
    try {
      await IntroduceAddUseCase(
        ref,
      ).call(title: title.trim(), content: content.trim());
    } catch (e) {
      Log.e('Failed to add introduce to server: $e');
      rethrow;
    }
  }
}
