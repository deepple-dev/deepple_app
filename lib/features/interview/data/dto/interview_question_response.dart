import 'package:freezed_annotation/freezed_annotation.dart';

part 'interview_question_response.freezed.dart';
part 'interview_question_response.g.dart';

@freezed
abstract class InterviewQuestionResponse with _$InterviewQuestionResponse {
  const factory InterviewQuestionResponse({
    required int status,
    required String code,
    required String message,
    required List<InterviewQuestionItem> data,
  }) = _InterviewQuestionResponse;

  factory InterviewQuestionResponse.fromJson(Map<String, dynamic> json) =>
      _$InterviewQuestionResponseFromJson(json);
}

@JsonEnum(fieldRename: FieldRename.none)
enum InterviewCategory {
  @JsonValue('PERSONAL')
  personal,

  @JsonValue('SOCIAL')
  social,

  @JsonValue('ROMANTIC')
  romantic,
}

@freezed
abstract class InterviewQuestionItem with _$InterviewQuestionItem {
  const factory InterviewQuestionItem({
    required int questionId,
    required String questionContent,
    required InterviewCategory category,
    required bool isAnswered,
    int? answerId,
    String? answerContent,
  }) = _InterviewQuestionItem;

  factory InterviewQuestionItem.fromJson(Map<String, dynamic> json) =>
      _$InterviewQuestionItemFromJson(json);
}
