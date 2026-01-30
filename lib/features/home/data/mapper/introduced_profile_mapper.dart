import 'package:deepple_app/app/constants/region_data.dart';
import 'package:deepple_app/features/home/data/dto/introduced_profile_dto.dart';
import 'package:deepple_app/features/home/home.dart';
import 'package:deepple_app/features/profile/domain/common/enum.dart';

extension IntroducedProfileMapper on IntroducedProfileDto {
  IntroducedProfile toIntroducedProfile(List<String> tags) {
    return IntroducedProfile(
      memberId: memberId,
      mbti: mbti,
      profileImageUrl: profileImageUrl,
      tags: tags,
      isIntroduced: isIntroduced,
      favoriteType: FavoriteType.tryParse(likeLevel),
      age: age,
      nickname: nickname,
      region: addressData.getLocationString(city, district),
    );
  }
}
