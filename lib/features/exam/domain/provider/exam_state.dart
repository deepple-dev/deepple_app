import 'package:deepple_app/features/exam/data/data.dart';
import 'package:deepple_app/features/home/domain/model/introduced_profile.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'exam_state.freezed.dart';

enum QuestionListErrorType { network }

@freezed
abstract class ExamState with _$ExamState {
  const factory ExamState({
    required QuestionData questionList,
    required SoulmateData soulmateList,
    required int currentSubjectIndex,
    required bool isSubjectOptional,
    required bool isDone,
    required bool hasResultData,
    required bool hasSoulmate,
    @Default(false) bool isLoaded,
    @Default(0) int currentPage,
    @Default({}) Map<int, int> currentAnswerMap,
    QuestionListErrorType? error,
  }) = _ExamState;

  const ExamState._();

  factory ExamState.initial() => const ExamState(
    questionList: QuestionData(),
    soulmateList: SoulmateData(),
    currentSubjectIndex: 0,
    isSubjectOptional: false,
    isDone: false,
    hasResultData: false,
    hasSoulmate: false,
  );
}

@freezed
abstract class QuestionData with _$QuestionData {
  const factory QuestionData({@Default([]) List<SubjectItem> questionList}) =
      _QuestionData;
}

@freezed
abstract class SoulmateData with _$SoulmateData {
  const factory SoulmateData({
    @Default([]) List<IntroducedProfile> soulmateList,
  }) = _SoulmateData;
}
