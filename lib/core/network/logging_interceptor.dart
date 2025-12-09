import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../util/log.dart';

class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final buffer = StringBuffer();
    buffer.writeln('[REQ] ${options.method} ${options.uri}');

    if (!kReleaseMode) {
      if (options.headers.isNotEmpty) {
        buffer.writeln('- headers: ${_prettyJson(options.headers)}');
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
      '[RES] ${response.requestOptions.method} ${response.requestOptions.uri}',
    );
    buffer.writeln('- statusCode: ${response.statusCode}');

    if (!kReleaseMode) {
      if (response.data != null) {
        buffer.writeln('- body: ${_prettyJson(response.data)}');
      }
    }
    Log.i(buffer.toString().trim());
    return super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final buffer = StringBuffer();
    buffer.writeln(
      '[ERR] ${err.requestOptions.method} ${err.requestOptions.uri}',
    );
    if (err.response != null) {
      buffer.writeln('- statusCode: ${err.response?.statusCode}');
    }
    buffer.writeln('- error: ${err.error}');

    if (!kReleaseMode) {
      if (err.response?.data != null) {
        buffer.writeln('- body: ${_prettyJson(err.response!.data)}');
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
}
