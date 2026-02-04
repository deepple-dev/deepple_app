import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

part 'enum.g.dart';

// Enum → 백엔드 대문자 스네이크_CASE 변환
extension EnumToJson on Enum {
  String toJson() {
    final converted = name
        .replaceAllMapped(RegExp(r'[A-Z]'), (match) => '_${match.group(0)}')
        .toUpperCase();

    return converted.startsWith('_') ? converted.substring(1) : converted;
  }
}

// 백엔드 응답을 Enum으로 변환
extension StringToEnum on String {
  T toEnum<T extends Enum>(
    List<T> values,
    //  ,{required T defaultValue}
  ) {
    return values.firstWhere(
      (e) => e.toJson() == this, // 백엔드 값과 매칭
      // orElse: () => defaultValue, // 기본값 설정
    );
  }
}

// 성별
@HiveType(typeId: 7, adapterName: 'GenderAdapter')
enum Gender {
  @HiveField(0)
  male('남자'),
  @HiveField(1)
  female('여자');

  final String label;
  const Gender(this.label);

  static final Map<String, Gender> _byValue = {
    for (final value in Gender.values) value.name.toUpperCase(): value,
  };

  static final Map<String, Gender> _byLabel = {
    for (final value in Gender.values) value.label.toUpperCase(): value,
  };

  static Gender parse(String value) =>
      _byValue[value.toUpperCase()] ?? Gender.male;

  static Gender fromLabel(String value) =>
      _byLabel[value.toUpperCase()] ?? Gender.male;
}

@HiveType(typeId: 8, adapterName: 'EducationAdapter')
enum Education {
  @HiveField(0)
  highSchool('고등학교 졸업'),
  @HiveField(1)
  associate('전문대'),
  @HiveField(2)
  bachelorsLocal('지방 4년제 대학'),
  @HiveField(3)
  bachelorsSeoul('서울 4년제 대학'),
  @HiveField(4)
  bachelorsOverseas('해외 4년제 대학'),
  @HiveField(5)
  lawSchool('로스쿨'),
  @HiveField(6)
  masters('석사'),
  @HiveField(7)
  doctorate('박사'),
  @HiveField(8)
  other('기타');

  final String label;
  const Education(this.label);

  static final Map<String, Education> _byLabel = {
    for (final value in Education.values) value.label: value,
  };

  // label을 enum으로 변환
  static Education fromLabel(String? value) =>
      _byLabel[value] ?? Education.other;

  // 서버 데이터를 enum으로 변환
  static final Map<String, Education> _byServerData = {
    for (final value in Education.values) value.toJson(): value,
  };

  static Education parse(String? value) =>
      _byServerData[value] ?? Education.other;
}

@HiveType(typeId: 9, adapterName: 'HobbyAdapter')
enum Hobby {
  @HiveField(0)
  travel('국내여행/해외여행'),
  @HiveField(1)
  performanceAndExhibition('공연/전시회관람'),
  @HiveField(2)
  webtoonAndComics('웹툰/만화'),
  @HiveField(3)
  dramaAndEntertainment('드라마/예능보기'),
  @HiveField(4)
  pcAndMobileGames('PC/모바일게임'),
  @HiveField(5)
  animation('애니메이션'),
  @HiveField(6)
  golf('골프'),
  @HiveField(7)
  theaterAndMovies('연극/영화'),
  @HiveField(8)
  writing('글쓰기'),
  @HiveField(9)
  boardGames('보드게임'),
  @HiveField(10)
  photography('사진촬영'),
  @HiveField(11)
  singing('노래'),
  @HiveField(12)
  badmintonAndTennis('배드민턴/테니스'),
  @HiveField(13)
  dance('댄스'),
  @HiveField(14)
  driving('드라이브'),
  @HiveField(15)
  hikingAndClimbing('등산/클라이밍'),
  @HiveField(16)
  walking('산책'),
  @HiveField(17)
  foodHunt('맛집탐방'),
  @HiveField(18)
  shopping('쇼핑'),
  @HiveField(19)
  skiAndSnowboard('스키/스노우보드'),
  @HiveField(20)
  playingInstruments('악기연주'),
  @HiveField(21)
  wine('와인'),
  @HiveField(22)
  workout('운동/헬스'),
  @HiveField(23)
  yogaAndPilates('요가/필라테스'),
  @HiveField(24)
  cooking('요리'),
  @HiveField(25)
  interiorDesign('인테리어'),
  @HiveField(26)
  cycling('자전거'),
  @HiveField(27)
  camping('캠핑'),
  @HiveField(28)
  others('기타');

  final String label;
  const Hobby(this.label);

  static final Map<String, Hobby> _byLabel = {
    for (final value in Hobby.values) value.label: value,
  };

  // label을 enum으로 변환
  static Hobby fromLabel(String? value) => _byLabel[value] ?? Hobby.others;

  // 서버 데이터를 enum으로 변환
  static final Map<String, Hobby> _byServerData = {
    for (final value in Hobby.values) value.toJson(): value,
  };

  static Hobby parse(String? value) => _byServerData[value] ?? Hobby.others;
}

@HiveType(typeId: 10, adapterName: 'JobAdapter')
enum Job {
  @HiveField(0)
  researchAndEngineering('연구개발/엔지니어'),
  @HiveField(1)
  selfEmployment('개인사업/자영업'),
  @HiveField(2)
  sales('영업/판매'),
  @HiveField(3)
  managementAndPlanning('경영/기획'),
  @HiveField(4)
  studyingForFuture('미래를 위한 공부중'),
  @HiveField(5)
  jobSearching('취업 준비중'),
  @HiveField(6)
  education('교육'),
  @HiveField(7)
  artsAndSports('예술/체육'),
  @HiveField(8)
  foodService('요식업'),
  @HiveField(9)
  medicalAndHealth('의료/보건'),
  @HiveField(10)
  mechanicalAndConstruction('기계/건설'),
  @HiveField(11)
  design('디자인'),
  @HiveField(12)
  marketingAndAdvertising('마케팅/광고'),
  @HiveField(13)
  tradeAndDistribution('무역/유통'),
  @HiveField(14)
  mediaAndEntertainment('방송언론/연예'),
  @HiveField(15)
  legalAndPublic('법률/공공'),
  @HiveField(16)
  productionAndManufacturing('생산/제조'),
  @HiveField(17)
  customerService('서비스'),
  @HiveField(18)
  travelAndTransport('여행/운송'),
  @HiveField(19)
  others('기타');

  final String label;
  const Job(this.label);

  static final Map<String, Job> _byLabel = {
    for (final value in Job.values) value.label: value,
  };

  // label을 enum으로 변환
  static Job fromLabel(String? value) => _byLabel[value] ?? Job.others;

  // 서버 데이터를 enum으로 변환
  static final Map<String, Job> _byServerData = {
    for (final value in Job.values) value.toJson(): value,
  };

  static Job parse(String? value) => _byServerData[value] ?? Job.others;
}

enum IntroducedCategory {
  grade('상위 5%'),
  recent('새로 가입했어요'),
  city('지금 근처인 사람!'),
  religion('종교가 같아요'),
  hobby('취미가 같아요');

  final String label;
  const IntroducedCategory(this.label);

  static final Map<String, IntroducedCategory> _byValue = {
    for (final category in IntroducedCategory.values)
      category.label.toUpperCase(): category,
  };

  static IntroducedCategory parse(String? value) =>
      _byValue[value?.toUpperCase()] ?? IntroducedCategory.grade;
}

enum ProfileExchangeStatus {
  @JsonValue('')
  none,
  @JsonValue('WAITING')
  waiting,
  @JsonValue('APPROVE')
  approve,
  @JsonValue('REJECTED')
  rejected;

  bool get isWaiting => this == waiting;

  static ProfileExchangeStatus parse(String? value) {
    if (value == null) return ProfileExchangeStatus.none;

    switch (value.toUpperCase()) {
      case 'WAITING':
        return ProfileExchangeStatus.waiting;
      case 'APPROVE':
        return ProfileExchangeStatus.approve;
      case 'REJECTED':
        return ProfileExchangeStatus.rejected;
      default:
        return ProfileExchangeStatus.none;
    }
  }
}

enum ActivityStatus {
  initial('INITIAL'),
  active('ACTIVE'),
  suspendedTemporarily('SUSPENDED_TEMPORARILY'),
  suspendedPermanently('SUSPENDED_PERMANENTLY'),
  waitingScreening('WAITING_SCREENING'),
  rejectedScreening('REJECTED_SCREENING'),
  dormant('DORMANT'),
  deleted('DELETED');

  final String label;
  const ActivityStatus(this.label);

  static final _byValue = {
    for (final value in ActivityStatus.values) value.label: value,
  };

  static ActivityStatus? parse(String? value) =>
      _byValue[value] ?? ActivityStatus.active;
}

enum IntroduceFilter {
  all('전체 보기'),
  opposite('이성만 보기');

  final String label;
  const IntroduceFilter(this.label);
}
