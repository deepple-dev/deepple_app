import 'package:deepple_app/app/constants/enum.dart';
import 'package:deepple_app/core/util/util.dart';
import 'package:deepple_app/features/home/data/dto/introduced_profile_dto.dart';
import 'package:deepple_app/features/home/data/mapper/introduced_profile_mapper.dart';
import 'package:deepple_app/features/home/home.dart';
import 'package:deepple_app/features/profile/domain/common/enum.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce/hive.dart';

final saveIntroducedProfilesUseCaseProvider = Provider(
  (ref) => SaveIntroducedProfilesUseCase(ref: ref),
);

class SaveIntroducedProfilesUseCase {
  final Ref _ref;

  SaveIntroducedProfilesUseCase({required Ref ref}) : _ref = ref;

  Future<List<IntroducedProfile>> execute(IntroducedCategory category) async {
    try {
      final box = await Hive.openBox<Map>(IntroducedProfileDto.boxName);

      final categoryKey = category.name;

      final cachedProfiles = _getValidCachedProfiles(box, categoryKey);
      if (cachedProfiles != null) return cachedProfiles;

      // 캐시 없거나 만료된 경우 서버에서 가져와서 저장
      final profileDtos = await _fetchProfilesFromServer(categoryKey);

      await _saveProfilesToCache(box, categoryKey, profileDtos);

      return convertToIntroducedProfiles(profileDtos);
    } catch (e, stackTrace) {
      Log.e('소개 받은 이성 리스트 호출 실패: $e\n$stackTrace');
      rethrow;
    }
  }

  /// 캐시에서 유효한 IntroducedProfile 리스트를 꺼냄, 만료 시 null 반환
  List<IntroducedProfile>? _getValidCachedProfiles(Box box, String key) {
    final data = box.get(key);

    if (data is! Map) return null;

    final profiles = data['profiles'];
    final expiresAt = data['expiresAt'];

    if (profiles is! List<IntroducedProfileDto> || expiresAt is! DateTime) {
      return null;
    }

    final List<IntroducedProfileDto> profileDtos;
    try {
      profileDtos = profiles.cast<IntroducedProfileDto>().toList();
    } catch (e) {
      Log.e('Hive 캐시 리스트 요소 타입 불일치: $e');
      return null;
    }

    if (DateTime.now().isBefore(expiresAt)) {
      return convertToIntroducedProfiles(profileDtos);
    }

    return null;
  }

  /// 서버에서 IntroducedProfileDto 리스트 불러오기
  Future<List<IntroducedProfileDto>> _fetchProfilesFromServer(
    String key,
  ) async {
    return await _ref
        .read(introducedProfileRepositoryProvider)
        .getProfiles(key);
  }

  /// IntroducedProfileDto 리스트를 캐시에 저장
  Future<void> _saveProfilesToCache(
    Box box,
    String key,
    List<IntroducedProfileDto> dtos,
  ) async {
    await box.put(key, {
      'profiles': dtos,
      'expiresAt': DateTime.now().add(const Duration(hours: 1)),
    });
  }
}

/// Dto -> 도메인 객체로 변환 + 해시태그 필터/정렬
List<IntroducedProfile> convertToIntroducedProfiles(
  List<IntroducedProfileDto> profileDtos,
) {
  return profileDtos.map((profile) {
    final hobbyLabels = profile.hobbies.map((e) => Hobby.parse(e).label); // 취미
    final religion = Religion.parse(profile.religion).label;

    final tags = [
      ...hobbyLabels,
      religion,
    ].whereType<String>().toList(); // null 제거

    tags.sort((a, b) => a.length.compareTo(b.length)); // 텍스트 길이순 오름차순

    return profile.toIntroducedProfile(tags); // dto -> 모델 변환
  }).toList();
}
