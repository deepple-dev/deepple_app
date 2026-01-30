import 'package:deepple_app/core/util/log.dart';
import 'package:deepple_app/features/message_list/data/repository/message_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:deepple_app/features/message_list/domain/message_list_state.dart';

part 'message_list_notifier.g.dart';

@riverpod
class MessageListNotifier extends _$MessageListNotifier {
  @override
  MessageListState build() {
    initialize();
    return MessageListState.initial();
  }

  // TODO(Han): 추후 event bus 또는 해당 함수를 통해 실시간 리스트 갱신이 되도록 수정
  Future<void> initialize() async {
    try {
      final repository = ref.read(messageRepositoryProvider);
      final (myMessages, messageMe) = await (
        repository.getSentMessages(),
        repository.getReceivedMessages(),
      ).wait;

      state = state.copyWith(
        sentMessages: myMessages,
        receivedMessages: messageMe,
        isLoaded: true,
        error: null,
      );
    } catch (e) {
      Log.e(e);
      state = state.copyWith(
        isLoaded: true,
        error: MessageListErrorType.network,
      );
    }
  }

  Future<void> loadMoreSentMessages() async {
    if (!state.sentMessages.hasMore) {
      return;
    }

    try {
      final lastId = state.sentMessages.messages.last.matchId;
      final messageListData = await ref
          .read(messageRepositoryProvider)
          .getSentMessages(lastId);

      state = state.copyWith(
        sentMessages: state.sentMessages.copyWith(
          messages: [
            ...state.sentMessages.messages,
            ...messageListData.messages,
          ],
          hasMore: messageListData.hasMore,
        ),
      );
    } catch (e) {
      Log.e(e);
      state = state.copyWith(error: MessageListErrorType.network);
    }
  }

  Future<void> loadMoreReceivedMessages() async {
    if (!state.receivedMessages.hasMore) {
      return;
    }

    try {
      final lastId = state.receivedMessages.messages.last.matchId;
      final messageListData = await ref
          .read(messageRepositoryProvider)
          .getReceivedMessages(lastId);

      state = state.copyWith(
        receivedMessages: state.receivedMessages.copyWith(
          messages: [
            ...state.receivedMessages.messages,
            ...messageListData.messages,
          ],
          hasMore: messageListData.hasMore,
        ),
      );
    } catch (e) {
      Log.e(e);
      state = state.copyWith(error: MessageListErrorType.network);
    }
  }

  void resetError() {
    state = state.copyWith(error: null);
  }
}
