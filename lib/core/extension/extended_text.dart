import 'package:flutter/widgets.dart';

import 'package:deepple_app/core/util/string_util.dart';

/// TextStyle에 대한 확장 메서드
extension ExtendedTextStyle on TextStyle {
  /// 기울임꼴(이탤릭) 스타일로 복사
  TextStyle get italic => copyWith(fontStyle: FontStyle.italic);

  /// 굵은 글씨(볼드) 스타일로 복사
  TextStyle get bold => copyWith(fontWeight: FontWeight.bold);
}

/// String에 대한 확장 메서드
extension ExtendedString on String? {
  /// 문자열의 앞뒤 공백을 제거하고 중복된 공백(연속된 공백)을 하나의 공백으로 변경
  String? trimExtra() => this?.trim().replaceAll(RegExp(r'\s+'), ' ');

  /// 문자열을 오름차순(ASC)으로 비교
  /// - [caseSensitive]: 대소문자 구분 여부 (기본값은 false)
  /// 반환값:
  /// - 0: 두 문자열이 같음
  /// - <0: 현재 문자열이 비교 문자열보다 앞에 위치
  /// - >0: 현재 문자열이 비교 문자열보다 뒤에 위치
  int compareASC(String? text, {bool caseSensitive = false}) {
    if (caseSensitive) {
      return this?.compareTo(text ?? '') ?? 0;
    }
    return this?.toLowerCase().compareTo(text?.toLowerCase() ?? '') ?? 0;
  }

  /// 문자열을 내림차순(DESC)으로 비교
  /// - [caseSensitive]: 대소문자 구분 여부 (기본값은 false)
  int compareDESC(String? text, {bool caseSensitive = false}) {
    return -compareASC(text, caseSensitive: caseSensitive);
  }

  /// 전화번호 형식으로 문자열을 변환
  /// - 내부적으로 [StringUtil.phoneFormatString] 메서드를 사용
  /// - 예: '1234567890'.toPhoneString → '123-456-7890'
  String get toPhoneString => StringUtil.phoneFormatString(this ?? '');

  /// 전화번호 형식에서 하이픈을 제거
  /// - 내부적으로 [StringUtil.removePhoneFormat] 메서드를 사용
  /// - 예: '123-456-7890'.removePhoneFormat → '1234567890'
  String get removePhoneFormat => StringUtil.removePhoneFormat(this ?? '');

  /// 숫자를 천 단위 형식으로 변환
  /// - 내부적으로 [StringUtil.formatThousands] 메서드를 사용
  /// - 예: '1000000'.formatThousands → '1,000,000'
  String get formatThousands =>
      StringUtil.formatThousands(int.parse(this ?? ''));
}
