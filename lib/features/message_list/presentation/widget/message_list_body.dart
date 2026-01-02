import 'package:deepple_app/app/router/route_arguments.dart';
import 'package:deepple_app/app/router/router.dart';
import 'package:deepple_app/features/message_list/domain/domain.dart';
import 'package:deepple_app/features/message_list/presentation/page/message_list_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:deepple_app/features/message_list/presentation/widget/empty_message.dart';
import 'package:deepple_app/features/message_list/presentation/widget/message_list_item.dart';

class MessageListBody extends ConsumerStatefulWidget {
  const MessageListBody({super.key});

  @override
  ConsumerState<MessageListBody> createState() => _MessageListBodyState();
}

class _MessageListBodyState extends ConsumerState<MessageListBody> {
  late final ScrollController _controller;

  @override
  void initState() {
    _controller = ScrollController()..addListener(_onScroll);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final notifier = ref.watch(messageListProvider);

    return SafeArea(
      top: false,
      child: TabBarView(
        children: MessageTabType.values.map((type) {
          final data = switch (type) {
            MessageTabType.received => notifier.receivedMessages,
            MessageTabType.sent => notifier.sentMessages,
          };

          if (data.messages.isEmpty) {
            return EmptyMessage(type: type);
          }

          return CustomScrollView(
            controller: _controller,
            slivers: [
              ListView.builder(
                itemBuilder: (context, index) {
                  final message = data.messages[index];
                  return MessageListItem(
                    message: message,
                    onTap: () => navigate(
                      context,
                      route: AppRoute.profile,
                      extra: ProfileDetailArguments(userId: message.opponentId),
                    ),
                  );
                },
                itemCount: data.messages.length,
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  void _onScroll() {
    final pixel = _controller.position.pixels;
    const threshold = 300;
    if (_controller.position.maxScrollExtent >= pixel + threshold) return;

    final notifier = ref.read(messageListProvider.notifier);

    final currentSelectedTab =
        MessageTabType.values[DefaultTabController.of(context).index];

    switch (currentSelectedTab) {
      case MessageTabType.sent:
        notifier.loadMoreSentMessages();
      case MessageTabType.received:
        notifier.loadMoreReceivedMessages();
    }
  }
}
