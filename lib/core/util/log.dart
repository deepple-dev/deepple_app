import 'dart:async';
import 'dart:convert';
import 'dart:developer' as dev;
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:deepple_app/core/config/config.dart';

class Log {
  // TODO(Han): Release 에서 Debug용 logger 하나 더 생성하기
  static final Logger _logger = Logger(
    filter: _LogFilter(),
    printer: PrettyPrinter(
      methodCount: kReleaseMode ? 0 : 2,
      errorMethodCount: 8,
      lineLength: 100,
      dateTimeFormat: DateTimeFormat.dateAndTime,
      colors: false,
      printEmojis: false,
    ),
    level: kReleaseMode ? Level.info : Level.debug,
  );

  /// 디버그 로그 출력 (Debug)
  static void d(Object? message, {String? name, DateTime? time}) {
    final logMessage = _formatMessage(message, name);
    _logger.d(logMessage);
  }

  static void i(Object? message, {String? name, DateTime? time}) {
    final logMessage = _formatMessage(message, name);
    _logger.i(logMessage);
  }

  /// 경고 로그 출력 (Warning)
  static void w(Object? message, {String? name, DateTime? time}) {
    final logMessage = _formatMessage(message, name);
    _logger.w(logMessage);
  }

  /// 에러 로그 출력 (Error)
  static void e(
    Object? errorMessage, {
    String? name,
    Object? errorObject,
    StackTrace? stackTrace,
    DateTime? time,
  }) {
    final logMessage = _formatMessage(errorMessage, name);
    _logger.e(logMessage, error: errorObject, stackTrace: stackTrace);
  }

  /// JSON 포맷팅 메서드 (Pretty JSON)
  static String prettyJson(Object json) {
    if (!Config.isPrettyJson) {
      return json.toString();
    }
    try {
      const encoder = JsonEncoder.withIndent('\t');
      if (json is Map<String, dynamic> || json is List<dynamic>) {
        return encoder.convert(json);
      }
      return json.toString();
    } catch (e) {
      return 'Invalid JSON: $e';
    }
  }

  /// 기존 log() 메서드 (기존 코드 호환성 유지)
  static void log(
    String message, {
    String? name,
    Object? error,
    StackTrace? stackTrace,
    DateTime? time,
    int? sequenceNumber,
    Zone? zone,
  }) {
    final logMessage = _formatMessage(message, name);
    _logger.log(Level.debug, logMessage, error: error, stackTrace: stackTrace);
    _logToDevConsole(
      logMessage,
      name,
      time,
      error,
      stackTrace,
      sequenceNumber,
      zone,
    );
  }

  /// `dev.log()`를 활용하여 기존 기능을 유지하는 보조 함수
  static void _logToDevConsole(
    String message,
    String? name, [
    DateTime? time,
    Object? error,
    StackTrace? stackTrace,
    int? sequenceNumber,
    Zone? zone,
  ]) {
    final logTime = time ?? DateTime.now();
    dev.log(
      message,
      name: name ?? '',
      time: logTime,
      level: Level.debug.value,
      error: error,
      stackTrace: stackTrace,
      sequenceNumber: sequenceNumber,
      zone: zone,
    );
  }

  static String _formatMessage(Object? message, String? name) {
    return name != null ? '[$name] $message' : '$message';
  }
}

class _LogFilter extends LogFilter {
  @override
  bool shouldLog(LogEvent event) {
    if (level == null) return false;

    return event.level >= level!;
  }
}
