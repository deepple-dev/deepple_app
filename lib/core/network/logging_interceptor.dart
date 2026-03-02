import 'dart:convert';

import 'package:deepple_app/core/util/log.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class LoggingInterceptor extends Interceptor {
  static const Set<String> _redactedRequestHeaderKeys = {
    'authorization',
    'cookie',
  };

  static const Set<String> _redactedBodyKeys = {
    'accessToken',
    'refreshToken',
    'idToken',
    'token',
  };

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final buffer = StringBuffer();
    buffer.writeln('[REQ] ${options.method} ${options.path}');
    buffer.writeln('- uri: ${options.uri}');

    if (!kReleaseMode) {
      if (options.headers.isNotEmpty) {
        final headers = kDebugMode
            ? options.headers
            : _redactRequestHeaders(options.headers);
        buffer.writeln('- headers: ${_prettyJson(headers)}');
      }
      if (options.queryParameters.isNotEmpty) {
        buffer.writeln(
          '- queryParams: ${_prettyJson(options.queryParameters)}',
        );
      }
      if (options.data != null) {
        buffer.writeln('- body: ${_prettyJson(options.data)}');
      }
    }

    Log.i(buffer.toString().trim());
    super.onRequest(options, handler);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    final buffer = StringBuffer();
    buffer.writeln(
      '[RES] ${response.requestOptions.method} ${response.requestOptions.path}',
    );
    buffer.writeln('- statusCode: ${response.statusCode}');

    if (!kReleaseMode) {
      if (response.data != null) {
        final body = kDebugMode ? response.data : _redactBody(response.data);
        buffer.writeln('- body: ${_prettyJson(body)}');
      }
    }
    Log.i(buffer.toString().trim());
    return super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final buffer = StringBuffer();
    buffer.writeln(
      '[ERR] ${err.requestOptions.method} ${err.requestOptions.path}',
    );
    if (err.response != null) {
      buffer.writeln('- statusCode: ${err.response?.statusCode}');
    }
    buffer.writeln('- error: ${err.error}');

    if (!kReleaseMode) {
      if (err.response?.data != null) {
        final body = kDebugMode
            ? err.response!.data
            : _redactBody(err.response!.data);
        buffer.writeln('- body: ${_prettyJson(body)}');
      }
    }

    Log.e(buffer.toString().trim());
    return super.onError(err, handler);
  }

  String _prettyJson(dynamic data) {
    try {
      final jsonString = jsonEncode(data);
      const encoder = JsonEncoder.withIndent('  ');
      return encoder.convert(jsonDecode(jsonString));
    } catch (e) {
      return data.toString();
    }
  }

  dynamic _redactBody(dynamic body) {
    if (body is Map) {
      return _redactMap(body);
    }
    if (body is List) {
      return body.map(_redactBody).toList();
    }
    return body;
  }

  Map<String, dynamic> _redactMap(Map body) {
    final result = <String, dynamic>{};

    for (final entry in body.entries) {
      final key = entry.key?.toString() ?? '';
      final value = entry.value;

      if (_redactedBodyKeys.contains(key)) {
        result[key] = '***';
        continue;
      }

      result[key] = _redactBody(value);
    }

    return result;
  }

  Map<String, dynamic> _redactRequestHeaders(Map<String, dynamic> headers) {
    final redacted = <String, dynamic>{};

    for (final entry in headers.entries) {
      final key = entry.key;
      final lowerKey = key.toLowerCase();
      final value = entry.value;

      if (_redactedRequestHeaderKeys.contains(lowerKey)) {
        if (lowerKey == 'authorization') {
          redacted[key] = 'Bearer ***';
        } else if (lowerKey == 'cookie') {
          redacted[key] = _redactCookieValue(value);
        } else {
          redacted[key] = '***';
        }
        continue;
      }

      redacted[key] = value;
    }

    return redacted;
  }

  String _redactCookieValue(dynamic cookieHeader) {
    final raw = cookieHeader?.toString() ?? '';
    if (raw.isEmpty) return '';

    final parts = raw.split(';');
    final names = <String>[];
    for (final part in parts) {
      final trimmed = part.trim();
      if (trimmed.isEmpty) continue;
      final eq = trimmed.indexOf('=');
      if (eq <= 0) continue;
      names.add(trimmed.substring(0, eq));
    }

    if (names.isEmpty) return '***';
    return '${names.join('; ')}=***';
  }
}
