import 'package:deepple_app/app/constants/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 앱의 텍스트 스타일, 폰트, 스케일 등을 커스텀하는 설정
class Fonts {
  const Fonts._();

  static const String fontPretendardBold = 'PretendardBold';
  static const String fontPretendardSemiBold = 'PretendardSemiBold';
  static const String fontPretendardMedium = 'PretendardMedium';
  static const String fontPretendardRegular = 'PretendardRegular';
  static const String fontMontserratBold = 'MontserratBold';
  static const String fontMontserratMedium = 'MontserratMedium';

  /// Title
  static TextStyle title([Color? color]) => TextStyle(
    fontFamily: fontPretendardBold,
    color: color ?? Palette.colorBlack,
    fontSize: 32.sp,
    height: 1.h,
  );

  /// Header
  static TextStyle header01([Color? color]) => TextStyle(
    fontFamily: fontPretendardBold,
    color: color ?? Palette.colorBlack,
    fontSize: 24.sp,
    height: 1.h,
  );

  static TextStyle header02([Color? color]) => TextStyle(
    fontFamily: fontPretendardSemiBold,
    color: color ?? Palette.colorBlack,
    fontSize: 20.sp,
    height: 1.h,
  );

  static TextStyle header03([Color? color]) => TextStyle(
    fontFamily: fontPretendardSemiBold,
    color: color ?? Palette.colorBlack,
    fontSize: 18.sp,
    height: 1.h,
  );

  static TextStyle header04([Color? color]) => TextStyle(
    fontFamily: fontPretendardSemiBold,
    fontWeight: FontWeight.w700,
    color: color ?? Palette.colorBlack,
    fontSize: 18.sp,
    height: 1.4.h,
  );

  /// Body
  static TextStyle body01Medium([Color? color]) => TextStyle(
    fontFamily: fontPretendardMedium,
    color: color ?? Palette.colorBlack,
    fontSize: 16.sp,
    height: 1.h,
  );

  static TextStyle body01Regular([Color? color]) => TextStyle(
    fontFamily: fontPretendardRegular,
    color: color ?? Palette.colorBlack,
    fontSize: 16.sp,
    height: 1.h,
  );

  static TextStyle body01Link([
    Color? color,
    Color underLineColor = Palette.colorBlack,
    double underLineThickness = 1.0,
  ]) => TextStyle(
    fontFamily: fontPretendardRegular,
    color: color ?? Palette.colorBlack,
    fontSize: 16.sp,
    height: 1.h,
    decoration: TextDecoration.underline,
    decorationColor: underLineColor,
    decorationThickness: underLineThickness,
  );

  static TextStyle body02Link([
    Color? color,
    Color underLineColor = Palette.colorBlack,
    double underLineThickness = 1.0,
  ]) => TextStyle(
    fontFamily: fontPretendardRegular,
    color: color ?? Palette.colorBlack,
    fontSize: 14.sp,
    height: 1.h,
    decoration: TextDecoration.underline,
    decorationColor: underLineColor,
    decorationThickness: underLineThickness,
  );

  static TextStyle body02Medium([Color? color]) => TextStyle(
    fontFamily: fontPretendardMedium,
    color: color ?? Palette.colorBlack,
    fontSize: 14.sp,
    height: 1.h,
  );

  static TextStyle body02Regular([Color? color]) => TextStyle(
    fontFamily: fontPretendardRegular,
    color: color ?? Palette.colorBlack,
    fontSize: 14.sp,
    height: 1.h,
  );

  static TextStyle body03Regular([Color? color]) => TextStyle(
    fontFamily: fontPretendardRegular,
    color: color ?? Palette.colorBlack,
    fontSize: 12.sp,
    height: 1.h,
  );

  /// Button
  static TextStyle button14([Color? color, double? lineHeight]) => TextStyle(
    fontFamily: fontPretendardRegular,
    color: color ?? Palette.colorBlack,
    fontSize: 14.sp,
    height: lineHeight ?? 1.h,
  );

  static TextStyle button16([Color? color]) => TextStyle(
    fontFamily: fontPretendardBold,
    color: color ?? Palette.colorBlack,
    fontSize: 16.sp,
    height: 1.h,
  );

  // Numeric
  static TextStyle numeric01Bold([Color? color]) => TextStyle(
    fontFamily: fontMontserratBold,
    color: color ?? Palette.colorBlack,
    fontSize: 20.sp,
    height: 1.h,
  );

  static TextStyle numeric01Medium([Color? color]) => TextStyle(
    fontFamily: fontMontserratMedium,
    color: color ?? Palette.colorGrey500,
    fontSize: 14.sp,
    height: 1.h,
  );

  static TextStyle bold({double? fontSize, Color? color, double? lineHeight}) =>
      TextStyle(
        fontFamily: fontPretendardBold,
        color: color ?? Palette.colorBlack,
        fontSize: fontSize ?? 32.sp,
        height: lineHeight ?? 1.h,
      );

  static TextStyle semibold({
    double? fontSize,
    Color? color,
    double? lineHeight,
  }) => TextStyle(
    fontFamily: fontPretendardSemiBold,
    color: color ?? Palette.colorBlack,
    fontSize: fontSize ?? 32.sp,
    height: lineHeight ?? 1.h,
  );

  static TextStyle regular({
    double? fontSize,
    Color? color,
    double? lineHeight,
  }) => TextStyle(
    fontFamily: fontPretendardRegular,
    color: color ?? Palette.colorBlack,
    fontSize: fontSize ?? 32.sp,
    height: lineHeight ?? 1.h,
  );

  static TextStyle medium({
    double? fontSize,
    Color? color,
    double? lineHeight,
  }) => TextStyle(
    fontFamily: fontPretendardMedium,
    color: color ?? Palette.colorBlack,
    fontSize: fontSize ?? 32.sp,
    height: lineHeight ?? 1.h,
  );
}
