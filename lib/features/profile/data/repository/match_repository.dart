import 'package:deepple_app/app/enum/contact_method.dart';
import 'package:deepple_app/core/network/base_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final matchRepositoryProvider = Provider<MatchRepository>((ref) {
  return MatchRepository(ref);
});

class MatchRepository extends BaseRepository {
  MatchRepository(Ref ref) : super(ref, '/match');

  Future<void> requestMatch({
    required int targetId,
    required String message,
    required ContactMethod contactMethod,
  }) async {
    await apiService.postJson(
      '$path/request',
      data: {
        'responderId': targetId,
        'requestMessage': message,
        'contactType': contactMethod.value,
      },
    );
  }

  Future<void> rejectMatch(int matchId) async {
    await apiService.patchJson('$path/$matchId/reject');
  }

  Future<void> resetMatchStatus(int matchId) async {
    await apiService.patchJson('$path/$matchId/check');
  }

  Future<void> approveMatch({
    required int matchId,
    required String message,
    required ContactMethod contactMethod,
  }) async {
    await apiService.patchJson(
      '$path/$matchId/approve',
      data: {'responseMessage': message, 'contactType': contactMethod.value},
    );
  }
}
