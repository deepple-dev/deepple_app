import 'package:deepple_app/features/exam/domain/model/personality_type.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'exam_result_response.freezed.dart';
part 'exam_result_response.g.dart';

@freezed
abstract class ExamResultResponse with _$ExamResultResponse {
  const factory ExamResultResponse({required PersonalityType personalityType}) =
      _ExamResultResponse;

  factory ExamResultResponse.fromJson(Map<String, dynamic> json) =>
      _$ExamResultResponseFromJson(json);
}
