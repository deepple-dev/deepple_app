import 'package:deepple_app/app/enum/contact_method.dart';
import 'package:deepple_app/features/profile/data/repository/match_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileMatchApproveUseCase {
  final Ref ref;

  const ProfileMatchApproveUseCase(this.ref);

  Future<void> call({
    required int matchId,
    required String message,
    required ContactMethod contactMethod,
  }) async {
    await ref
        .read(matchRepositoryProvider)
        .approveMatch(
          matchId: matchId,
          message: message,
          contactMethod: contactMethod,
        );
  }
}
