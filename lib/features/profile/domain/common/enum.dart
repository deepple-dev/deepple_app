import 'package:deepple_app/app/constants/icon_path.dart';
import 'package:deepple_app/core/util/string_extension.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

part 'enum.g.dart';

@HiveType(typeId: 11, adapterName: 'SmokingStatusAdapter')
enum SmokingStatus {
  @HiveField(0)
  none('비흡연'),
  @HiveField(1)
  quit('금연'),
  @HiveField(2)
  occasional('가끔 피움'),
  @HiveField(3)
  daily('매일 피움'),
  @HiveField(4)
  vape('전자담배');

  final String label;
  const SmokingStatus(this.label);

  static final Map<String, SmokingStatus> _byValue = {
    for (final status in SmokingStatus.values)
      status.name.toUpperCase(): status,
  };

  static final Map<String, SmokingStatus> _byLabel = {
    for (final status in SmokingStatus.values)
      status.label.toUpperCase(): status,
  };

  static SmokingStatus parse(String? value) =>
      _byValue[value?.toUpperCase()] ?? SmokingStatus.none;

  static SmokingStatus fromLabel(String? label) =>
      _byLabel[label?.toUpperCase()] ?? SmokingStatus.none;
}

@HiveType(typeId: 12, adapterName: 'DrinkingStatusAdapter')
enum DrinkingStatus {
  @HiveField(0)
  none('전혀 마시지 않음'),
  @HiveField(1)
  quit('금주'),
  @HiveField(2)
  social('사회적 음주'),
  @HiveField(3)
  occasional('가끔 마심'),
  @HiveField(4)
  frequent('술자리를 즐김');

  final String label;
  const DrinkingStatus(this.label);

  static final Map<String, DrinkingStatus> _byValue = {
    for (final status in DrinkingStatus.values)
      status.name.toUpperCase(): status,
  };

  static final Map<String, DrinkingStatus> _byLabel = {
    for (final status in DrinkingStatus.values)
      status.label.toUpperCase(): status,
  };

  static DrinkingStatus parse(String? value) =>
      _byValue[value?.toUpperCase()] ?? DrinkingStatus.none;

  static DrinkingStatus fromLabel(String? label) =>
      _byLabel[label?.toUpperCase()] ?? DrinkingStatus.none;
}

enum EducationLevel {
  highSchool('고등학교 졸업'),
  associate('전문대 졸업'),
  bachelorsLocal('지방 4년제 대학 졸업'),
  bachelorsSeoul('서울 4년제 대학 졸업'),
  bachelorsOverseas('해외 4년제 대학 졸업'),
  lawSchool('로스쿨 졸업'),
  masters('석사 졸업'),
  doctorate('박사 졸업'),
  other('기타');

  final String label;
  const EducationLevel(this.label);

  static final Map<String, EducationLevel> _byValue = {
    for (final level in EducationLevel.values)
      level.name.toUpperCase().replaceAll('_', ''): level,
  };

  static EducationLevel parse(String? value) =>
      _byValue[value?.toUpperCase()] ?? EducationLevel.other;
}

@HiveType(typeId: 13, adapterName: 'ReligionAdapter')
enum Religion {
  @HiveField(0)
  none('무교'),
  @HiveField(1)
  christian('기독교'),
  @HiveField(2)
  catholic('천주교'),
  @HiveField(3)
  buddhist('불교'),
  @HiveField(4)
  other('기타');

  final String label;
  const Religion(this.label);

  static final Map<String, Religion> _byValue = {
    for (final religion in Religion.values)
      religion.name.toUpperCase(): religion,
  };

  static final Map<String, Religion> _byLabel = {
    for (final religion in Religion.values)
      religion.label.toUpperCase(): religion,
  };

  static Religion parse(String? value) =>
      _byValue[value?.toUpperCase()] ?? Religion.none;

  static Religion fromLabel(String? label) =>
      _byLabel[label?.toUpperCase()] ?? Religion.none;
}

enum FavoriteType {
  interested(IconPath.generalFavorite, '관심있어요'),

  highlyInterested(IconPath.strongFavorite, '매우 관심있어요');

  final String iconPath;
  final String label;
  const FavoriteType([this.iconPath = '', this.label = '']);

  static final Map<String, FavoriteType> _byValue = {
    for (final type in FavoriteType.values)
      type.name.camelCaseToSnakeCase(): type,
  };

  static FavoriteType? tryParse(String? value) {
    return _byValue[value?.toUpperCase()];
  }
}

enum InterviewCategory {
  personal('나'),
  romantic('연인'),
  social('관계');

  final String label;
  const InterviewCategory(this.label);

  static final Map<String, InterviewCategory> _byValue = {
    for (final category in InterviewCategory.values)
      category.name.toUpperCase(): category,
  };

  static InterviewCategory parse(String? value) =>
      _byValue[value?.toUpperCase()] ?? InterviewCategory.personal;
}
