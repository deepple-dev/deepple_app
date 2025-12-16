import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:deepple_app/features/heart_history/domain/model/heart_transaction_summary.dart';

part 'heart_history_data.freezed.dart';

@freezed
abstract class HeartHistoryData with _$HeartHistoryData {
  const factory HeartHistoryData({
    @Default(<HeartTransactionSummary>[])
    List<HeartTransactionSummary> transactions,
    @Default(false) bool hasMore,
  }) = _HeartHistoryData;
}
