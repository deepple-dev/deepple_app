import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:deepple_app/features/heart_history/domain/model/heart_history_data.dart';

part 'heart_history_state.freezed.dart';

enum HeartHistoryErrorType { network }

@freezed
abstract class HeartHistoryState with _$HeartHistoryState {
  const factory HeartHistoryState({
    @Default(HeartHistoryData()) HeartHistoryData history,
    @Default(false) bool isLoaded,
    HeartHistoryErrorType? error,
  }) = _HeartHistoryState;

  const HeartHistoryState._();

  factory HeartHistoryState.initial() => const HeartHistoryState();
}
