import 'package:deepple_app/features/exam/data/repository/exam_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ExamRemoveBlurUsecase {
  final Ref ref;

  const ExamRemoveBlurUsecase(this.ref);

  Future<bool> call({required int memberId}) async {
    try {
      await ref
          .read(examRepositoryProvider)
          .removeSoulmateProfileBlur(memberId: memberId);
      return true;
    } catch (e) {
      return false;
    }
  }
}
