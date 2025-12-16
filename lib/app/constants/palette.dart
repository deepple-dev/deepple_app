import 'package:flutter/material.dart';

/// 다양한 색상 테마와 다크 / 라이트 모드 지원
class Palette {
  static Color mixWithWhite({required Color color, required double opacity}) =>
      Color.lerp(
        Colors.white.withAlpha((opacity * 255).round()),
        color,
        opacity,
      )!;

  static Color mixColors({
    required Color baseColor,
    required Color mixColor,
    required double baseOpacity,
  }) => Color.lerp(
    baseColor.withAlpha((baseOpacity * 255).round()),
    mixColor,
    1 - baseOpacity,
  )!.withAlpha(128);

  // 색상 정의
  static const colorPrimary50 = Color(0xffF7F6FD);
  static const colorPrimary100 = Color(0xffEBE9FC);
  static const colorPrimary200 = Color(0xffD4CEFC);
  static const colorPrimary300 = Color(0xffB8AFF3);
  static const colorPrimary400 = Color(0xff9D90EF);
  static const colorPrimary500 = Color(0xff7462E8);
  static const colorPrimary600 = Color(0xff4F37E2);
  static const colorPrimary700 = Color(0xff351DC8);
  static const colorPrimary800 = Color(0xff29179C);
  static const colorPrimary900 = Color(0xff1E106F);

  static const colorSecondary50 = Color(0xffE6F8FF);
  static const colorSecondary100 = Color(0xffD1F2FF);
  static const colorSecondary200 = Color(0xffA3E5FF);
  static const colorSecondary300 = Color(0xff75D8FF);
  static const colorSecondary400 = Color(0xff47CBFF);
  static const colorSecondary500 = Color(0xff1ABEFF);
  static const colorSecondary600 = Color(0xff00A8EB);
  static const colorSecondary700 = Color(0xff0087BD);
  static const colorSecondary800 = Color(0xff00668F);
  static const colorSecondary900 = Color(0xff004561);

  static const colorGrey50 = Color(0xffF8F8F8);
  static const colorGrey100 = Color(0xffEDEEF0);
  static const colorGrey200 = Color(0xffDCDEE3);
  static const colorGrey300 = Color(0xffB4B8C0);
  static const colorGrey400 = Color(0xff9BA0AB);
  static const colorGrey500 = Color(0xff8D92A0);
  static const colorGrey600 = Color(0xff6B7180);
  static const colorGrey700 = Color(0xff565B67);
  static const colorGrey800 = Color(0xff41454E);
  static const colorGrey900 = Color(0xff2C2F35);
  static const colorDisable = Color(0xffBDBDBD);

  static const colorBlack = Color(0xff222222);
  static const colorWhite = Color(0xffFFFFFF);

  static const Color red = Color.fromARGB(255, 239, 64, 54);

  // Grayscale colors
  static const Color gray10 = Color(0xFFF8F8F8);
  static const Color gray500 = Color(0xFF808080);

  // Transparent blacks
  static const Color black50 = Color(0x80000000); // 50% transparent black

  // 색상 스키마
  static const ColorScheme lightScheme = ColorScheme.light(
    primary: Palette.colorPrimary500,
    onPrimary: Palette.colorWhite,
    surface: Palette.colorWhite,
    onSurface: Palette.colorBlack,
    error: Palette.red,
    onError: Palette.colorWhite,
    secondary: Palette.colorGrey800,
    onSecondary: Palette.colorWhite,
    tertiary: Palette.colorGrey600,
    outline: Palette.colorGrey100,
    outlineVariant: Palette.colorGrey50,
    shadow: Palette.colorGrey100,
  );

  static const ColorScheme darkScheme = ColorScheme.dark(
    primary: Palette.colorPrimary500,
    onPrimary: Palette.colorWhite,
    surface: Palette.colorBlack,
    onSurface: Palette.colorWhite,
    error: Palette.red,
    onError: Palette.colorBlack,
    secondary: Palette.colorGrey800,
    onSecondary: Palette.colorWhite,
    tertiary: Palette.colorGrey600,
    outline: Palette.colorGrey100,
    outlineVariant: Palette.colorGrey50,
    shadow: Palette.colorGrey100,
  );
}

ThemeData createThemeData(ColorScheme colorScheme) {
  TextTheme baseTextTheme =
      Typography.material2018(platform: TargetPlatform.android).black.apply(
        bodyColor: colorScheme.onSurface,
        displayColor: colorScheme.onSurface,
      );

  return ThemeData(
    appBarTheme: const AppBarTheme(
      // backgroundColor: colorScheme.surface,
      // elevation: 0,
      scrolledUnderElevation: 0,
    ),
    colorScheme: colorScheme,
    scaffoldBackgroundColor: colorScheme.surface,
    useMaterial3: true, // Material 3 디자인 사용
    // TextTheme 커스터마이징
    textTheme: baseTextTheme.copyWith(
      bodyMedium: baseTextTheme.bodyMedium?.copyWith(color: Palette.gray500),
    ),
  );
}
