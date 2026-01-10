import 'package:flutter/widgets.dart';

/// 앱의 디폴트 설정(size, pading, border,...)
class Dimens {
  Dimens._();

  static const double imageSize = 50.0;
  static const double imageHeight = 50.0;
  static const double imageWidth = 80.0;
  static const BorderRadius imageRadius = BorderRadius.all(Radius.circular(10));

  static const double iconSize = 24.0;

  static const double buttonHeight = 54.0;
  static const BorderRadius buttonRadius = BorderRadius.all(
    Radius.circular(10),
  );
  static const double buttonRadiusValue = 10;
  static const EdgeInsets buttonPadding = EdgeInsets.symmetric(horizontal: 20);

  static const double bottomSheetGap = 24.0;
  static const BorderRadius bottomSheetRadius = BorderRadius.vertical(
    top: Radius.circular(10),
  );

  static const double bottomPadding = 36.0;

  static const double dialogWidth = 300.0;
  static const double dialogGap = 24.0;
  static const EdgeInsets dialogPadding = EdgeInsets.symmetric(
    horizontal: 15.0,
    vertical: 24.0,
  );
  static const BorderRadius dialogRadius = BorderRadius.all(
    Radius.circular(10),
  );

  static const double appbarHeight = 64.0;
  static const double appbarLeadingSize = 18.0;
  static const EdgeInsets appbarLeadingPading = EdgeInsets.only(
    right: 10,
    left: 20,
  );

  static const double creadcrumbHeight = 32.0;

  static const double drawerWidth = 300.0;

  static const EdgeInsets cardPadding = EdgeInsets.symmetric(
    horizontal: 16.0,
    vertical: 10.0,
  );
  static const BorderRadius cardRadius = BorderRadius.all(Radius.circular(10));
  static const double cardGap = 12.0;

  static const double navigationBarHeight = 10.0;

  static const int profileImageMaxCount = 6;

  // 남성 소개 프로필 오픈 하트 수
  static const int maleIntroducedProfileOpenHeartCount = 10;

  // 여성 소개 프로필 오픈 하트 수
  static const int femaleIntroducedProfileOpenHeartCount = 4;

  // 연애모의고사 프로필 오픈 하트 수
  static const int examProfileOpenHeartCount = 4;

  // 이상형 설정 최소 나이 수
  static const int minSelectableAge = 20;

  // 이상형 설정 최대 나이 수
  static const int maxSelectableAge = 46;

  // 메시지 전송에 필요한 하트 수
  static const int messageSendHeartCount = 20;

  // 프로필 교환하기 하트 수
  static const int profileExchangeHeartCount = 3;

  // 취미 선택 최대 개수
  static const int maxSelectableHobbiesCount = 3;
}
