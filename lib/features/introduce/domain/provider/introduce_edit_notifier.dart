import 'package:deepple_app/core/util/log.dart';
import 'package:deepple_app/features/introduce/domain/provider/introduce_edit_state.dart';
import 'package:deepple_app/features/introduce/domain/usecase/introduce_edit_use_case.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'introduce_edit_notifier.g.dart';

@Riverpod(keepAlive: false)
class IntroduceEditNotifier extends _$IntroduceEditNotifier {
  @override
  IntroduceEditState build({required String title, required String content}) {
    return IntroduceEditState(
      title: title,
      content: content,
      canSubmit: false,
    );
  }

  void setTitle(String t) {
    final newTitle = t.trim();
    if (newTitle == title) return;
    state = state.copyWith(
      title: newTitle,
      canSubmit:
          title.isNotEmpty &&
          (state.content != null && state.content!.isNotEmpty),
    );
  }

  void setContent(String t) {
    final newContent = t.trim();
    if (newContent == content) return;
    state = state.copyWith(
      content: newContent,
      canSubmit:
          content.isNotEmpty &&
          (state.title != null && state.title!.isNotEmpty),
    );
  }

  /// 셀프 소개 수정
  Future<void> editIntroduce({
    required int id,
    required String title,
    required String content,
  }) async {
    try {
      await IntroduceEditUseCase(
        ref,
      ).call(id: id, title: title.trim(), content: content.trim());
    } catch (e) {
      // TODO: 에러 발생 처리 어떻게???
      Log.e('Failed to edit introduce to server: $e');
      rethrow;
    }
  }
}
