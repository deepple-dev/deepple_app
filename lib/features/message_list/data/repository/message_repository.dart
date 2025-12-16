import 'package:deepple_app/core/network/base_repository.dart';
import 'package:deepple_app/features/message_list/data/dto/message_list_response.dart';
import 'package:deepple_app/features/message_list/domain/domain.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final messageRepositoryProvider = Provider<MessageRepository>((ref) {
  return MessageRepository(ref);
});

class MessageRepository extends BaseRepository {
  MessageRepository(Ref ref) : super(ref, '/match');

  Future<MessageListData> getSentMessages([int? lastId]) async {
    final res = await apiService.getJson<Map<String, dynamic>>(
      '$path/sent',
      queryParameters: {'lastMatchId': ?lastId},
    );
    return _parseMessageList(res, isSent: true);
  }

  Future<MessageListData> getReceivedMessages([int? lastId]) async {
    final res = await apiService.getJson<Map<String, dynamic>>(
      '$path/received',
      queryParameters: {'lastMatchId': ?lastId},
    );
    return _parseMessageList(res, isSent: false);
  }

  MessageListData _parseMessageList(
    Map<String, dynamic> res, {
    required bool isSent,
  }) {
    if (res['data'] is! Map<String, dynamic>) {
      throw Exception('data type is not Map $res');
    }

    final response = MessageListResponse.fromJson(res['data']);
    return MessageListData(
      messages: response.matches.map((e) {
        return MessageSummary(
          matchId: e.matchId,
          opponentId: e.opponentId,
          name: e.nickName,
          profileUrl: e.profileImageUrl ?? '',
          content: (isSent ? e.myMessage : e.opponentMessage) ?? '',
          createdAt: e.createdAt,
        );
      }).toList(),
      hasMore: response.hasMore,
    );
  }
}
