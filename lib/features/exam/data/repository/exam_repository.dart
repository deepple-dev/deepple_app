import 'package:deepple_app/core/network/base_repository.dart';
import 'package:deepple_app/core/util/util.dart';
import 'package:deepple_app/features/exam/data/dto/exam_answer_request.dart';
import 'package:deepple_app/features/exam/data/dto/exam_result_response.dart';
import 'package:deepple_app/features/home/data/dto/introduced_profile_dto.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:deepple_app/core/network/network_exception.dart';
import 'package:deepple_app/features/exam/data/dto/exam_question_response.dart';
import 'package:deepple_app/features/exam/domain/model/subject_answer.dart';

final examRepositoryProvider = Provider<ExamRepository>((ref) {
  return ExamRepository(ref);
});

class ExamRepository extends BaseRepository {
  ExamRepository(Ref ref) : super(ref, '/dating-exam');

  Future<List<SubjectItem>> getRequiredQuestionList() async {
    try {
      final response = await apiService.getJson<Map<String, dynamic>>(
        '$path/required',
      );

      final result = ExamQuestionResponse.fromJson(response);

      return result.data.subjects;
    } catch (e) {
      Log.e(e);
      return [];
    }
  }

  Future<void> submitAnswerList({required SubjectAnswer request}) async {
    final dto = SubjectAnswerItem.fromDomain(request);

    await apiService.postJson('$path/submit', data: dto.toJson());
  }

  Future<List<IntroducedProfileDto>> getSoulmateList() async {
    try {
      final response = await apiService.getJson<Map<String, dynamic>>(
        '/member/introduction/soulmate',
      );

      if (response['data'] is! List) {
        throw const NetworkException.formatException();
      }

      return (response['data'] as List)
          .map((e) => IntroducedProfileDto.fromJson(e))
          .toList();
    } catch (e) {
      Log.e(e);
      return [];
    }
  }

  Future<ExamResultResponse> getExamResult() async {
    final res = await apiService.getJson<Map<String, dynamic>>(
      '$path/personality-type',
    );

    final data = res['data'];

    if (data is! Map<String, Object?>) {
      throw const NetworkException.formatException();
    }

    try {
      return ExamResultResponse.fromJson(Map<String, dynamic>.from(data));
    } catch (e) {
      Log.e('exam result parse failed: $e');

      throw const NetworkException.formatException();
    }
  }

  Future<void> removeSoulmateProfileBlur({required int memberId}) async {
    await apiService.postJson(
      '/member/introduction/soulmate',
      data: {'introducedMemberId': memberId},
    );
  }
}
