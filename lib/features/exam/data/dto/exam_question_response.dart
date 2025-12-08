import 'package:freezed_annotation/freezed_annotation.dart';

part 'exam_question_response.freezed.dart';
part 'exam_question_response.g.dart';

@freezed
abstract class ExamQuestionResponse with _$ExamQuestionResponse {
  const factory ExamQuestionResponse({
    required int status,
    required String code,
    required String message,
    required ExamQuestionItem data,
  }) = _ExamQuestionResponse;

  factory ExamQuestionResponse.fromJson(Map<String, dynamic> json) =>
      _$ExamQuestionResponseFromJson(json);
}

@freezed
abstract class ExamQuestionItem with _$ExamQuestionItem {
  const factory ExamQuestionItem({required List<SubjectItem> subjects}) =
      _ExamQuestionItem;

  factory ExamQuestionItem.fromJson(Map<String, dynamic> json) =>
      _$ExamQuestionItemFromJson(json);
}

enum ExamType {
  @JsonValue('REQUIRED')
  required,

  @JsonValue('OPTIONAL')
  optional,
}

@freezed
abstract class SubjectItem with _$SubjectItem {
  const factory SubjectItem({
    required int id,
    required ExamType type,
    required String name,
    required bool isSubmitted,
    required List<QuestionItem> questions,
  }) = _SubjectItem;

  factory SubjectItem.fromJson(Map<String, dynamic> json) =>
      _$SubjectItemFromJson(json);
}

@freezed
abstract class QuestionItem with _$QuestionItem {
  const factory QuestionItem({
    required int id,
    required String content,
    required List<AnswerItem> answers,
  }) = _QuestionItem;

  factory QuestionItem.fromJson(Map<String, dynamic> json) =>
      _$QuestionItemFromJson(json);
}

@freezed
abstract class AnswerItem with _$AnswerItem {
  const factory AnswerItem({required int id, required String content}) =
      _AnswerItem;

  factory AnswerItem.fromJson(Map<String, dynamic> json) =>
      _$AnswerItemFromJson(json);
}
