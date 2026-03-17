import 'package:deepple_app/features/exam/data/data.dart';
import 'package:deepple_app/features/exam/domain/model/personality_type.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ExamResultFetchUseCase {
  final Ref ref;

  const ExamResultFetchUseCase(this.ref);

  Future<PersonalityType> call() async {
    final response = await ref.read(examRepositoryProvider).getExamResult();

    return response.personalityType;
  }
}
