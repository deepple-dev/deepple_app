import 'package:deepple_app/app/provider/global_notifier.dart';
import 'package:deepple_app/core/util/log.dart';
import 'package:deepple_app/features/exam/domain/usecase/exam_optional_fetch_usecase.dart';
import 'package:deepple_app/features/exam/domain/usecase/exam_create_submit_usecase.dart';
import 'package:deepple_app/features/exam/domain/usecase/exam_remove_blur_usecase.dart';
import 'package:deepple_app/features/exam/domain/usecase/exam_required_fetch_usecase.dart';
import 'package:deepple_app/features/exam/domain/usecase/exam_soulmate_fetch_usecase.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:deepple_app/features/exam/domain/model/subject_answer.dart';

import 'package:deepple_app/features/exam/domain/provider/exam_state.dart';

part 'exam_notifier.g.dart';

enum ExamSubmitResult { nextSubject, examFinished, showResult, error }

@Riverpod(keepAlive: true)
class ExamNotifier extends _$ExamNotifier {
  @override
  ExamState build() {
    return ExamState.initial();
  }

  bool get isLastSubject =>
      state.currentSubjectIndex == state.questionList.questionList.length - 1;

  void selectAnswer(int questionId, int answerId) {
    final updatedAnswers = Map<int, int>.from(state.currentAnswerMap)
      ..[questionId] = answerId;
    state = state.copyWith(currentAnswerMap: updatedAnswers);
  }

  Future<void> handleDirectAccessResult() async {
    state = state.copyWith(isSubjectOptional: true, isDone: true);

    await fetchSoulmateList();
  }

  Future<ExamSubmitResult> submitCurrentSubject() async {
    try {
      final profileNotifier = ref.read(globalProvider.notifier);
      final currentSubject =
          state.questionList.questionList[state.currentSubjectIndex];

      final payload = SubjectAnswer(
        subjectId: currentSubject.id,
        answers: state.currentAnswerMap.entries
            .map((e) => QuestionAnswer(questionId: e.key, answerId: e.value))
            .toList(),
      );

      state = state.copyWith(isLoaded: false);
      await _submitAnswers(payload);
      await fetchSoulmateList();

      if (isLastSubject) {
        profileNotifier.profile = await profileNotifier
            .fetchProfileToHiveFromServer();

        state = state.copyWith(
          isSubjectOptional: true,
          isDone: state.isSubjectOptional ? true : false,
          currentAnswerMap: {},
          isLoaded: true,
        );
        return ExamSubmitResult.examFinished;
      }

      if (state.hasResultData && !state.isSubjectOptional) {
        state = state.copyWith(isLoaded: true);
        return ExamSubmitResult.showResult;
      }

      nextSubject();
      state = state.copyWith(isLoaded: true);
      return ExamSubmitResult.nextSubject;
    } catch (e) {
      Log.e('submit error: $e');
      state = state.copyWith(isLoaded: true);
      return ExamSubmitResult.error;
    }
  }

  void nextPage() {
    final currentSubject =
        state.questionList.questionList[state.currentSubjectIndex];
    if (state.currentPage < currentSubject.questions.length - 1) {
      state = state.copyWith(currentPage: state.currentPage + 1);
    }
  }

  void previousPage() {
    if (state.currentPage > 0) {
      state = state.copyWith(currentPage: state.currentPage - 1);
    }
  }

  void nextSubject() {
    state = state.copyWith(
      currentSubjectIndex: state.currentSubjectIndex + 1,
      currentAnswerMap: {},
      currentPage: 0,
    );
  }

  void resetCurrentSubjectIndex() {
    state = state.copyWith(
      currentSubjectIndex: 0,
      currentAnswerMap: {},
      currentPage: 0,
    );
  }

  void setCurrentSubjectIndex(int index) {
    state = state.copyWith(
      currentSubjectIndex: index,
      currentAnswerMap: {},
      currentPage: 0,
    );
  }

  void setSubjectOptional(bool isOptional) {
    state = state.copyWith(isSubjectOptional: isOptional);
  }

  void setExamDone() {
    state = state.copyWith(isDone: true);
  }

  Future<void> fetchOptionalQuestionList() async {
    state = state.copyWith(isLoaded: false);
    try {
      final optionalQuestionList = await ExamOptionalFetchUseCase(ref).call();

      state = state.copyWith(
        questionList: QuestionData(questionList: optionalQuestionList),
        isLoaded: true,
        error: null,
      );
    } catch (e) {
      Log.e(e);
      state = state.copyWith(
        isLoaded: true,
        error: QuestionListErrorType.network,
      );
    }
  }

  Future<void> fetchSoulmateList() async {
    state = state.copyWith(isLoaded: false);
    try {
      final examSoulmateList = await ExamSoulmateFetchUseCase(ref).call();
      final hasResultData = examSoulmateList.isNotEmpty;

      state = state.copyWith(
        soulmateList: SoulmateData(soulmateList: examSoulmateList),
        hasResultData: hasResultData,
        hasSoulmate: hasResultData,
        isLoaded: true,
        error: null,
      );
    } catch (e) {
      Log.e(e);
      state = state.copyWith(
        isLoaded: true,
        error: QuestionListErrorType.network,
      );
    }
  }

  Future<void> openProfile({
    required int memberId,
    required bool isSoulmate,
  }) async {
    try {
      final success = await ExamRemoveBlurUsecase(
        ref,
      ).call(memberId: memberId, isSoulmate: isSoulmate);

      if (!success) return;

      final updatedList = state.soulmateList.soulmateList
          .map(
            (profile) => profile.memberId == memberId
                ? profile.copyWith(isIntroduced: true)
                : profile,
          )
          .toList();

      // 하트 사용하여 프로필 열람 시 보유 하트 수 갱신
      await ref.read(globalProvider.notifier).fetchHeartBalance();

      state = state.copyWith(
        soulmateList: state.soulmateList.copyWith(soulmateList: updatedList),
      );
    } catch (e) {
      Log.e('프로필 블러 제거 실패: $e');
    }
  }

  int fetchUserHeartBalance() {
    return ref.watch(globalProvider).heartBalance.totalHeartBalance;
  }

  Future<void> _fetchRequiredQuestionList() async {
    try {
      final requiredQuestionList = await ExamRequiredFetchUseCase(ref).call();

      final filteredList = requiredQuestionList
          .where((subject) => subject.isSubmitted == false)
          .toList();

      state = state.copyWith(
        questionList: QuestionData(questionList: filteredList),
        isLoaded: true,
        currentSubjectIndex: 0,
        error: null,
      );
    } catch (e) {
      Log.e(e);
      state = state.copyWith(
        isLoaded: true,
        error: QuestionListErrorType.network,
      );
    }
  }

  Future<void> fetchRequiredQuestions() async {
    state = state.copyWith(isLoaded: false);

    await _fetchRequiredQuestionList();
  }

  Future<void> _submitAnswers(SubjectAnswer payload) async {
    try {
      await ExamCreateSubmitUsecase(ref).call(request: payload);
    } catch (e) {
      Log.e('답안 제출 실패: $e');
      rethrow;
    }
  }
}
