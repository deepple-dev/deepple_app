import 'package:deepple_app/core/util/log.dart';
import 'package:deepple_app/features/heart_history/data/repository/heart_history_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:deepple_app/features/heart_history/domain/provider/heart_history_state.dart';

part 'heart_history_notifier.g.dart';

@riverpod
class HeartHistoryNotifier extends _$HeartHistoryNotifier {
  @override
  HeartHistoryState build() {
    _initializeHeartTransactions();
    return HeartHistoryState.initial();
  }

  Future<void> _initializeHeartTransactions() async {
    try {
      final repository = ref.read(heartHistoryRepositoryProvider);
      final heartHistoryData = await repository.getHeartTransactionList();

      state = state.copyWith(
        history: heartHistoryData,
        isLoaded: true,
        error: null,
      );
    } catch (e, stack) {
      Log.e('Failed to fetch initial heart transactions: $e\n$stack');
      state = state.copyWith(
        isLoaded: true,
        error: HeartHistoryErrorType.network,
      );
    }
  }

  Future<void> loadMoreHeartTransactions() async {
    final currentData = state.history;

    if (!currentData.hasMore || currentData.transactions.isEmpty) {
      return;
    }

    try {
      final lastId = currentData.transactions.last.id;
      final moreData = await ref
          .read(heartHistoryRepositoryProvider)
          .getHeartTransactionList(lastId);

      state = state.copyWith(
        history: currentData.copyWith(
          transactions: [...currentData.transactions, ...moreData.transactions],
          hasMore: moreData.hasMore,
        ),
      );
    } catch (e, stack) {
      Log.e('Failed to load more heart transactions: $e\n$stack');
      state = state.copyWith(error: HeartHistoryErrorType.network);
    }
  }

  void resetError() {
    state = state.copyWith(error: null);
  }
}
