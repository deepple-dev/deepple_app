import 'package:deepple_app/core/util/log.dart';
import 'package:deepple_app/features/interview/data/data.dart';
import 'package:deepple_app/features/interview/domain/usecase/delete_interview_to_hive_usecase.dart';
import 'package:deepple_app/features/interview/domain/usecase/interview_add_usecase.dart';
import 'package:deepple_app/features/interview/domain/usecase/interview_remove_usecase.dart';
import 'package:deepple_app/features/interview/domain/usecase/interview_fetch_usecase.dart';
import 'package:deepple_app/features/interview/domain/usecase/interview_update_usecase.dart';
import 'package:deepple_app/features/interview/domain/usecase/save_interview_to_hive_usecase.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:deepple_app/features/interview/domain/provider/interview_state.dart';

part 'interview_notifier.g.dart';

class AnswerSubmitResult {
  final bool isSuccess;
  final bool hasProcessedMission;

  AnswerSubmitResult({
    required this.isSuccess,
    required this.hasProcessedMission,
  });
}

@riverpod
class InterviewNotifier extends _$InterviewNotifier {
  @override
  InterviewState build() {
    _initializeInterviewQuestionList(InterviewCategory.personal);
    return InterviewState.initial();
  }

  Future<void> _initializeInterviewQuestionList(
    InterviewCategory category,
  ) async {
    try {
      final questionList = await InterviewFetchUseCase(ref).call(category);

      state = state.copyWith(
        questionList: InterviewData(questionList: questionList),
        isLoaded: true,
        error: null,
      );
    } catch (e) {
      Log.e(e);
      state = state.copyWith(
        isLoaded: true,
        error: InterviewListErrorType.network,
      );
    }
  }

  Future<void> fetchQuestionList(InterviewCategory category) async {
    await _initializeInterviewQuestionList(category);
  }

  Future<AnswerSubmitResult> addAnswer(
    int questionId,
    String question,
    String answerContent,
  ) async {
    try {
      final response = await InterviewAddUseCase(
        ref,
      ).call(questionId: questionId, answerContent: answerContent);

      final isSuccess = response.code == '200';
      if (isSuccess) {
        await _saveInterviewToHive(questionId, question, answerContent);
      }

      return AnswerSubmitResult(
        isSuccess: isSuccess,
        hasProcessedMission: response.data.hasProcessedMission,
      );
    } catch (e) {
      Log.e('Failed to add interview to server: $e');
      return AnswerSubmitResult(isSuccess: false, hasProcessedMission: false);
    }
  }

  Future<bool> removeAnswer(int answerId, int questionId) async {
    try {
      await InterviewRemoveUseCase(ref).call(answerId: answerId);
      await _deleteInterviewToHive(questionId);
      return true;
    } catch (e) {
      Log.e('Failed to remove interview to server: $e');
      return false;
    }
  }

  Future<void> updateAnswer(
    int questionId,
    int answerId,
    String question,
    String answerContent,
  ) async {
    try {
      await InterviewUpdateUseCase(
        ref,
      ).call(answerId: answerId, answerContent: answerContent);
    } catch (e) {
      Log.e('Failed to update interview to server: $e');
    }

    await _saveInterviewToHive(questionId, question, answerContent);
  }

  Future<void> _saveInterviewToHive(
    int questionId,
    String question,
    String answerContent,
  ) async {
    try {
      await ref
          .read(saveInterviewToHiveUseCaseProvider)
          .execute(
            questionId: questionId,
            title: question,
            content: answerContent,
          );
    } catch (e) {
      Log.e('Failed to save interview to local cache: $e');
    }
  }

  Future<void> _deleteInterviewToHive(int questionId) async {
    try {
      await ref
          .read(deleteInterviewToHiveUseCaseProvider)
          .execute(questionId: questionId);
    } catch (e) {
      Log.e('Failed to delete interview to local cache: $e');
    }
  }
}
