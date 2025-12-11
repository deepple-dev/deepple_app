
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

/// Format string date
class DateTimeFormatter {
  const DateTimeFormatter._();

  // Convert
  static final dateTimeConvert = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS");

  static final dateConvert = DateFormat('yyyy-MM-dd');
  static final summaryConvert = DateFormat('yy.MM.dd');

  // Format
  static final dateTimeFormatSlash = DateFormat('yyyy/MM/dd HH:mm:ss');
  static final dateFormatSlash = DateFormat('yyyy/MM/dd');
  static final dateTimeFormatHyphen = DateFormat('yyyy-MM-dd HH:mm:ss');
  static final dateFormatHyphen = DateFormat('yyyy-MM-dd');
  static final monthFormatHyphen = DateFormat('yyyy-MM');
  static final dateTimeFormatDot = DateFormat('yyyy.MM.dd HH:mm:ss');
  static final dateFormatDot = DateFormat('yyyy.MM.dd');
  static final timeFormat = DateFormat('HH:mm:ss');
  static final timeNoSecondFormat = DateFormat('HH:mm');
}

/// Using TextField Date
class DateTextFormatter extends TextInputFormatter {
  const DateTextFormatter({this.seperator = '-'});

  final String seperator;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = _format(newValue.text, seperator);
    return newValue.copyWith(text: text, selection: updateCursorPosition(text));
  }

  String _format(String value, String separator) {
    final cleanValue = value.replaceAll(separator, '');
    return cleanValue
        .split('')
        .asMap()
        .entries
        .take(8) // 8자리까지만 유지
        .map((entry) {
          final index = entry.key;
          final char = entry.value;
          return (index == 3 || index == 5) && index != cleanValue.length - 1
              ? '$char$separator'
              : char;
        })
        .join();
  }

  TextSelection updateCursorPosition(String text) {
    return TextSelection.fromPosition(TextPosition(offset: text.length));
  }
}

/// Using TextField Time
class TimeTextFormatter extends TextInputFormatter {
  const TimeTextFormatter();

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = _format(newValue.text, ':');
    return newValue.copyWith(text: text, selection: updateCursorPosition(text));
  }

  String _format(String value, String seperator) {
    final cleanValue = value.replaceAll(seperator, '');
    return cleanValue.split('').asMap().entries.map((entry) {
      final index = entry.key;
      final char = entry.value;
      return (index == 1) && index != cleanValue.length - 1
          ? '$char$seperator'
          : char;
    }).join();
  }

  TextSelection updateCursorPosition(String text) {
    return TextSelection.fromPosition(TextPosition(offset: text.length));
  }
}

/// Using TextField phone
class PhoneNumberTextFormatter extends TextInputFormatter {
  const PhoneNumberTextFormatter();

  // 전화번호 포맷팅을 위한 메서드 추가
  String formatPhoneNumber(String phoneNumber) {
    return _format(phoneNumber, '-');
  }

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = _format(newValue.text, '-');
    return newValue.copyWith(text: text, selection: updateCursorPosition(text));
  }

  String _format(String value, String separator) {
    final cleanValue = value.replaceAll(separator, '');
    return cleanValue
        .split('')
        .asMap()
        .entries
        .take(13) // 최대 13자리까지만 유지
        .map((entry) {
          final index = entry.key;
          final char = entry.value;
          return (index == 2 || index == 6) && index != cleanValue.length - 1
              ? '$char$separator'
              : char;
        })
        .join();
  }

  TextSelection updateCursorPosition(String text) =>
      TextSelection.collapsed(offset: text.length);
}
