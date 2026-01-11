import 'package:deepple_app/core/util/log.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart'; // .env 파일 로딩

/// Config: 개발, 테스트, 운영 환경에 따라 다른 값을 적용하기 위한 클래스
abstract class Config {
  /// 내부 변수 (초기화 후 변경 불가능)
  static bool? _enableGeneralLog;
  static bool? _isPrettyJson;
  static String? _baseUrl;
  static Duration? _timeout;
  static int? _maxRetries;
  static bool? _logOnNotifierError;
  static bool? _logOnNotifierNotifierEvent;
  static bool? _enableNavigatorObserverLog;
  static bool? _enableErrorPage;
  static bool? _enableLogNetworkException;
  static bool? _enableLogRequestInfo;
  static String? _deepLinkUrl;
  static bool? _enableNotificationLog;
  static String? _kakaoContactUrl;

  /// Getter를 사용하여 안전하게 접근
  static bool get enableGeneralLog => _enableGeneralLog ?? kDebugMode;
  static bool get isPrettyJson => _isPrettyJson ?? kDebugMode;
  static String get baseUrl => _baseUrl ?? '';
  static Duration get timeout => _timeout ?? const Duration(seconds: 10);
  static int get maxRetries => _maxRetries ?? 1;
  static bool get logOnNotifierError => _logOnNotifierError ?? kDebugMode;
  static bool get logOnNotifierNotifierEvent =>
      _logOnNotifierNotifierEvent ?? kDebugMode;
  static bool get enableNavigatorObserverLog =>
      _enableNavigatorObserverLog ?? kDebugMode;
  static bool get enableErrorPage => _enableErrorPage ?? kReleaseMode;
  static bool get enableLogNetworkException =>
      _enableLogNetworkException ?? kDebugMode;
  static bool get enableLogRequestInfo => _enableLogRequestInfo ?? kDebugMode;
  static String get deepLinkUrl => _deepLinkUrl ?? '';
  static bool get enableNotificationLog => _enableNotificationLog ?? kDebugMode;
  static String get kakaoContactUrl => _kakaoContactUrl ?? '';

  static Future<void> initialize() async {
    try {
      const envFile = String.fromEnvironment('ENV_FILE', defaultValue: '.env');
      await dotenv.load(fileName: 'assets/$envFile');
    } catch (e) {
      Log.e('environment file load failed: $e');
    }

    _enableGeneralLog =
        dotenv.get(
          'ENABLE_GENERAL_LOG',
          fallback: kDebugMode ? 'true' : 'false',
        ) ==
        'true';
    _isPrettyJson =
        dotenv.get('IS_PRETTY_JSON', fallback: kDebugMode ? 'true' : 'false') ==
        'true';

    _baseUrl = dotenv.get('BASE_URL', fallback: '');
    _timeout = Duration(
      seconds: int.tryParse(dotenv.get('TIMEOUT', fallback: '10')) ?? 10,
    );
    _maxRetries = int.tryParse(dotenv.get('MAX_RETRIES', fallback: '1')) ?? 1;

    _logOnNotifierError =
        dotenv.get(
          'LOG_ON_NOTIFIER_ERROR',
          fallback: kDebugMode ? 'true' : 'false',
        ) ==
        'true';
    _logOnNotifierNotifierEvent =
        dotenv.get(
          'LOG_ON_NOTIFIER_NOTIFIER_EVENT',
          fallback: kDebugMode ? 'true' : 'false',
        ) ==
        'true';

    _enableNavigatorObserverLog =
        dotenv.get(
          'ENABLE_NAVIGATOR_OBSERVER_LOG',
          fallback: kDebugMode ? 'true' : 'false',
        ) ==
        'true';
    _enableErrorPage =
        dotenv.get(
          'ENABLE_ERROR_PAGE',
          fallback: kReleaseMode ? 'true' : 'false',
        ) ==
        'true';

    _enableLogNetworkException =
        dotenv.get(
          'ENABLE_LOG_NETWORK_EXCEPTION',
          fallback: kDebugMode ? 'true' : 'false',
        ) ==
        'true';
    _enableLogRequestInfo =
        dotenv.get(
          'ENABLE_LOG_REQUEST_INFO',
          fallback: kDebugMode ? 'true' : 'false',
        ) ==
        'true';

    _deepLinkUrl = dotenv.get('DEEP_LINK_URL', fallback: '');
    _enableNotificationLog =
        dotenv.get(
          'ENABLE_NOTIFICATION_LOG',
          fallback: kDebugMode ? 'true' : 'false',
        ) ==
        'true';

    _kakaoContactUrl = dotenv.get('KAKAO_CONTACT_URL', fallback: '');
  }
}
