import 'package:deepple_app/app/constants/enum.dart';
import 'package:deepple_app/app/constants/region_data.dart';
import 'package:deepple_app/features/home/domain/model/cached_user_profile.dart';
import 'package:deepple_app/core/util/util.dart';
import 'package:deepple_app/features/my/data/dto/profile_update_request_dto.dart';
import 'package:deepple_app/features/my/domain/domain.dart';

extension MyProfileMapper on CachedUserProfile {
  MyProfile toMyProfile() {
    return MyProfile(
      profileImages: [],
      job: job,
      region: addressData.getLocationString(city, district),
      education: education,
      smokingStatus: smokingStatus,
      drinkingStatus: drinkingStatus,
      religion: religion,
      mbti: mbti,
      hobbies: hobbies,
      nickname: nickname,
      age: age,
      height: height,
      gender: gender,
      phoneNum: const PhoneNumberTextFormatter().formatPhoneNumber(phoneNumber),
      interviews: interviewInfoView,
    );
  }
}

extension ProfileUpdateRequestDtoMapper on MyProfile {
  ProfileUpdateRequestDto toProfileUpdateRequestDto() {
    return ProfileUpdateRequestDto(
      nickname: nickname,
      gender: gender.name.toUpperCase(),
      yearOfBirth: DateTime.now().year - age + 1,
      height: height,
      district: addressData.getDistrictValue(region) ?? '',
      highestEducation: education.toJson(),
      mbti: mbti,
      smokingStatus: smokingStatus.name.toUpperCase(),
      drinkingStatus: drinkingStatus.name.toUpperCase(),
      religion: religion.name.toUpperCase(),
      hobbies: hobbies.map((e) => e.toJson()).toList(),
      job: job.toJson(),
    );
  }
}
