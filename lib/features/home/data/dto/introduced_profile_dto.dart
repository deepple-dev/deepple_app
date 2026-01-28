import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_ce/hive.dart';

part 'introduced_profile_dto.freezed.dart';
part 'introduced_profile_dto.g.dart';

@freezed
@HiveType(typeId: 6, adapterName: 'IntroducedProfileDtoAdapter')
abstract class IntroducedProfileDto with _$IntroducedProfileDto {
  const factory IntroducedProfileDto({
    // HiveField 어노테이션은 그대로 유지
    @HiveField(0) required int memberId,
    @HiveField(1) required String profileImageUrl,
    @HiveField(2) required List<String> hobbies,
    @HiveField(3) required String mbti,
    @HiveField(4) required String? religion,
    // @HiveField(5) required String? interviewAnswerContent,
    @HiveField(6) String? likeLevel,
    @HiveField(7) required bool isIntroduced,
    @HiveField(8) required int age,
    @HiveField(9) required String nickname,
    @HiveField(10) required String city,
    @HiveField(11) required String district,
  }) = _IntroducedProfileDto;

  factory IntroducedProfileDto.fromJson(Map<String, dynamic> json) =>
      _$IntroducedProfileDtoFromJson(json);

  static String get boxName => 'IntroducedProfileDto';
}
