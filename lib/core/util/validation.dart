import 'package:intl/intl.dart';

/// TextFormField 검증
// TODO: 나중에 백엔드랑 맞춰야 함 습습...
class Validation {
  const Validation._();

  // 닉네임은 2-10자리 특수문자를 제외한 한글, 영문, 숫자를 포함해야 함.
  static final RegExp nickname = RegExp(r'^[a-zA-Z0-9ㄱ-ㅎ가-힣]{2,10}$');
  // 비밀번호가 숫자, 소문자, 대문자, 특수문자를 포함해야 함.
  static final RegExp password = RegExp(
    r'(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*\W)',
  );
  static final RegExp email = RegExp(r'^(([\w-\.]+@([\w-]+\.)+[\w-]{2,4}))$');
  // 휴대폰 번호 검증: 010 포함 11자리 숫자만 허용. e.g. 01012345678
  static final RegExp phoneMobile = RegExp(r'^010\d{8}$');
  // dateDMY: DD-MM-YYYY 또는 DD/MM/YYYY 형태
  static final RegExp dateDMY = RegExp(
    r'([0-2][0-9]|3[0-1])?(\\|\/|\-|\.|\,|\s)?(0[1-9]|1[0-2])(\\|\/|\-|\.|\,|\s)([0-9]{4}|[0-9]{2})',
  );
  // dateYMD: YYYY-MM-DD 또는 YYYY/MM/DD 형태
  static final RegExp dateYMD = RegExp(
    r'([0-9]{4}|[0-9]{2})(\\|\/|\-|\.|\,|년|\s)\s?(0?[1-9]|1[0-2])(\\|\/|\-|\.|\,|월|\s)\s?([1-2][0-9]|0?[1-9]|3[0-1])?',
  );
  // 위 두 날짜 형식 중 하나라도 만족하면 true
  static final RegExp date = RegExp('${dateDMY.pattern}|${dateYMD.pattern}');
  // prices: 숫자 및 화폐 기호 검증. e.g. ₩1,000, 1,000원
  static final RegExp prices = RegExp(
    r'(^((\d{1,3}[.,])+(\d{1,3})$|[₩wW]\s?(\d{1,3}[.,])*(\d{1,3})|(\d{1,3}[.,])*(\d{1,3})\s?[원]))',
  );

  // 6자리 숫자 검증
  static final RegExp sixDigitNumber = RegExp(r'^\d{6}$');

  static String? validIdentity(String? value, bool? validId, String? message) {
    if (validId != null && !validId) {
      return message;
    }
    return null;
  }

  static String? validPassword(String? value) {
    if (value != null) {
      return null;
    }
    return null;
  }

  static String? validRePassword(String? value, String oldPass) {
    if (value != oldPass) {
      // 입력값이 기존 비밀번호와 일치하지 않으면 오류 메시지를 반환
      return '비밀번호가 일치하지 않습니다.';
    }
    return null;
  }

  // 비어있으면 user_nickname_duplicate
  // 길이가 3~20자 범위를 벗어나면 user_nickname_correct_format
  // 서버 검증에서 실패하면 커스텀 메시지 반환
  static String? validNickname(
    String? value,
    bool? validNickname,
    String? message,
  ) {
    if (value == null || value.trim().isEmpty) {
      return '중복된 닉네임입니다.';
    } else if (value.length < 3 || value.length > 20) {
      return '닉네임은 3자에서 20자 사이여야 합니다.';
    } else if (validNickname != null && !validNickname) {
      return message;
    }
    return null;
  }

  static String? validEmail(String? value) {
    if (value == null) {
      return '이메일 형식에 맞게 입력해 주십시오.';
    } else if (!email.hasMatch(value)) {
      return '이메일 형식에 맞게 입력해 주십시오.';
    }
    return null;
  }

  static String? validPhoneNumber(
    String? value,
    bool? validPhone,
    String? message,
  ) {
    if (!phoneMobile.hasMatch(value ?? '')) {
      return '잘못된 형식입니다.';
    } else if (validPhone != null && !validPhone) {
      return message;
    }
    return null;
  }

  static String? validRegisterationPath(String? value) {
    if (value == null || value.trim().isEmpty) {
      return '가입 경로를 입력해 주십시오.';
    }
    return null;
  }

  static String? validOtp(String? value, bool? validOtp, String? message) {
    if (value == null || value.trim().isEmpty) {
      return 'OTP(임시 비밀번호)를 입력해 주십시오.';
    } else if (validOtp != null && !validOtp) {
      return message;
    }
    return null;
  }

  static String? validName(String? value) {
    value = value?.trim() ?? '';
    if (value.isEmpty || value.length > 50) {
      return '이름은 {from}~{to}자 사이여야 합니다.';
    }
    return null;
  }

  static String? validNotEmpty(String? value) {
    if (value?.trim().isEmpty ?? false) {
      return '이 필드를 입력해 주십시오.';
    }
    return null;
  }

  // 6자리 숫자인지 확인
  static String? validSixDigitNumber(String? value) {
    if (!sixDigitNumber.hasMatch(value ?? '')) {
      return '6자리 숫자를 입력해 주십시오.';
    }
    return null;
  }

  // 날짜가 yyyy-MM-dd 형식인지 확인
  // parseStrict를 사용해 엄격하게 검증
  static bool isDate(String? input) {
    try {
      DateFormat('yyyy-MM-dd').parseStrict(input ?? '');
      return true;
    } catch (e) {
      return false;
    }
  }
}
