import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:deepple_app/features/profile/domain/common/enum.dart';

part 'introduced_profile.freezed.dart';

@freezed
abstract class IntroducedProfile with _$IntroducedProfile {
  const factory IntroducedProfile({
    required int memberId,
    required String profileImageUrl, // imageUrl
    required String mbti,
    required List<String> hobbies, // 취미
    // required String interviewContent, // 인터뷰 첫 대답
    required bool isIntroduced, // 프로필 소개 여부
    required FavoriteType? favoriteType, // 좋아요 여부
    required String? religion, // 종교
    required int age, // 나이
    required String nickname, // 닉네임
    required String city, // 시
    required String district, // 구
  }) = _IntroducedProfile;
}
