import 'dart:io';

import 'package:deepple_app/core/config/config.dart';
import 'package:dio/dio.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:deepple_app/core/util/log.dart';

part 'network_exception.freezed.dart';

/// 네트워크 요청 중 발생하는 예외를 관리하기 위한 커스텀 Exception 클래스
// @freezed: Freezed 어노테이션을 사용해 불변 객체와 다양한 상태를 자동으로 생성
@freezed
abstract class NetworkException with _$NetworkException implements Exception {
  const NetworkException._() : super();

  // unauthorizedException: 인증되지 않은 사용자
  const factory NetworkException.unauthorizedException() =
      UnauthorizedException;

  // unauthorizedException: 유효하지 않은 사용자
  const factory NetworkException.invalidUserException() = InvalidUserException;

  // otherException: 기타 예외 상태를 처리하기 위해 예외의 타입을 인자로 받는다.
  const factory NetworkException.otherException(Type type) = OtherException;

  // formatException: 데이터 형식 오류 발생 시 사용
  const factory NetworkException.formatException() = FormatException;

  // connectionException: 네트워크 연결 오류가 발생했을 때 사용
  const factory NetworkException.connectionException() = ConnectionException;

  // maintenanceException: 서버 점검과 같은 예외를 처리
  const factory NetworkException.maintenanceException() = MaintenanceException;

  // apiException: API 응답에 대한 예외 상태를 처리하며, HTTP 상태 코드와 에러 메시지를 인자로 받는다.
  const factory NetworkException.apiException({
    int? status,
    String? code,
    String? message,
    Map<String, dynamic>? data,
  }) = _ApiException;

  // 다양한 예외 상황에 맞는 NetworkException 객체를 반환하는 메서드
  static NetworkException getException(Object error) {
    /// 예외 타입에 따른 분기 처리
    /// 이미 NetworkException 타입이면 그대로 반환
    if (error is NetworkException) {
      return error;
    } else if (error is SocketException) {
      /// 네트워크 연결 오류
      return const NetworkException.connectionException();
    } else if (error is FormatException || error is TypeError) {
      /// 데이터 형식 오류
      return const NetworkException.formatException();
    } else if (error is DioException) {
      /// Dio 라이브러리의 네트워크 예외
      switch (error.type) {
        case DioExceptionType.connectionError:
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          return const NetworkException.connectionException();

        /// 상태 코드 및 메시지 처리
        case DioExceptionType.badResponse:
          String? code;
          String? message;
          Map<String, dynamic>? data;
          final status = error.response?.statusCode;

          try {
            final json = error.response?.data as Map;
            message ??= json['Message'] as String?;
            message ??= json['message'] as String?;
            code ??= json['code'] as String?;
            data ??= json['data'] as Map<String, dynamic>?;
          } catch (_) {}

          message ??= error.message;

          return switch (status) {
            401 => const NetworkException.unauthorizedException(),
            403 => const NetworkException.invalidUserException(),
            _ => NetworkException.apiException(
              status: status,
              code: code,
              message: message,
              data: data,
            ),
          };

        case DioExceptionType.badCertificate:
        case DioExceptionType.cancel:
        case DioExceptionType.unknown:

          /// 기타 예외 처리
          if (error.error is SocketException) {
            return const NetworkException.connectionException();
          } else if (error.error is FormatException ||
              error.error is TypeError) {
            return const NetworkException.formatException();
          }
      }
    }

    return NetworkException.otherException(error.runtimeType);
  }

  // HTTP 상태 코드 가져오는 getter
  int? get status => whenOrNull(apiException: (status, _, _, _) => status);

  String? get code => whenOrNull(apiException: (_, code, _, _) => code);

  Map<String, dynamic>? get data =>
      whenOrNull(apiException: (_, _, _, data) => data);

  // 에러 메시지 가져오는 getter
  String? get message => maybeWhen<String?>(
    apiException: (status, code, message, data) => message,
    formatException: () => 'Function이 변경되었습니다. 새로운 버전으로 업그레이드 해주세요!',
    connectionException: () => '네트워크 연결이 불안정합니다. 다시 시도해 주세요!',
    orElse: () => '죄송합니다. 에러 발생으로 인해 나중에 다시 시도해 주세요.',
  );
}
