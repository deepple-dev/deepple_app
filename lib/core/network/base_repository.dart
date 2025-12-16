import 'package:deepple_app/core/util/log.dart';

import 'package:deepple_app/core/network/api_service.dart';
import 'package:deepple_app/core/network/api_service_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class BaseRepository {
  final Ref ref;
  final String path; // 각 리소스에 맞는 경로

  const BaseRepository(this.ref, this.path);

  ApiService get apiService => ref.read(apiServiceProvider);

  // 실행 시간 출력 (선택적 구현 가능)
  void printFormattedDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String hours = twoDigits(duration.inHours);
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));

    Log.i('Elapsed Time: $hours h $minutes m $seconds s');
  }

  // API로 데이터 fetch 후 모델로 변환 (선택적 구현 가능)
  Future<T> fetchData<T>({
    required String endpoint,
    required Converter<T>? converter,
    Map<String, String>? customHeaders,
    String? contentType,
    void Function()? onStart,
    void Function()? onEnd,
    bool requiresAccessToken = true,
    bool requiresRefreshToken = false,
    bool requiresRefreshCookie = false,
    Json? queryParameters,
  }) async {
    Stopwatch stopwatch = Stopwatch()..start();
    onStart?.call();
    try {
      final response = await apiService.getJson<T>(
        endpoint,
        headers: customHeaders,
        contentType: contentType,
        requiresAccessToken: requiresAccessToken,
        requiresRefreshToken: requiresRefreshToken,
        requiresRefreshCookie: requiresRefreshCookie,
        queryParameters: queryParameters,
        converter: converter,
      );
      return response;
    } finally {
      onEnd?.call();
      stopwatch.stop();
      printFormattedDuration(stopwatch.elapsed);
    }
  }
}
