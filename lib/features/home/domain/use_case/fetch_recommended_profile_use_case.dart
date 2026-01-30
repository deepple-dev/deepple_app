import 'package:deepple_app/app/constants/enum.dart';
import 'package:deepple_app/core/util/util.dart';
import 'package:deepple_app/features/home/data/mapper/introduced_profile_mapper.dart';
import 'package:deepple_app/features/home/data/repository/recommended_profile_repository_impl.dart';
import 'package:deepple_app/features/home/domain/model/introduced_profile.dart';
import 'package:deepple_app/features/profile/domain/common/enum.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final fetchRecommendedProfileUseCaseProvider =
    Provider<FetchRecommendedProfileUseCase>(
      (ref) => FetchRecommendedProfileUseCase(ref: ref),
    );

class FetchRecommendedProfileUseCase {
  final Ref _ref;

  FetchRecommendedProfileUseCase({required Ref ref}) : _ref = ref;

  Future<List<IntroducedProfile>> execute() async {
    try {
      final profiles = await _ref
          .read(recommendedProfileRepositoryProvider)
          .getProfiles();

      return profiles.map((profile) {
        final hobbyLabels = profile.hobbies
            .map((e) => Hobby.parse(e).label)
            .toList(); // 취미

        final religion = Religion.parse(profile.religion).label;

        final tags = [
          ...hobbyLabels,
          religion,
        ].whereType<String>().toList(); // null 제거

        // 글자 수가 적은 순서대로 정렬
        tags.sort((a, b) => a.length.compareTo(b.length));

        return profile.toIntroducedProfile(tags);
      }).toList();
    } catch (e) {
      Log.e('소개 받은 이성 리스트 호출 실패: $e');
      return [];
    }
  }
}
