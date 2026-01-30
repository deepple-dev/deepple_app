import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:deepple_app/features/profile/domain/common/enum.dart';

part 'introduced_profile.freezed.dart';

@freezed
abstract class IntroducedProfile with _$IntroducedProfile {
  const factory IntroducedProfile({
    required int memberId,
    required String profileImageUrl, // imageUrl
    required String mbti,
    required List<String> tags, // 취미 + 종교
    required bool isIntroduced, // 프로필 소개 여부
    required FavoriteType? favoriteType, // 좋아요 여부
    required int age, // 나이
    required String nickname, // 닉네임
    required String region, // 시 + 구
  }) = _IntroducedProfile;
}
