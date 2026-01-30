import 'package:deepple_app/app/enum/contact_method.dart';
import 'package:deepple_app/app/router/router.dart';
import 'package:deepple_app/app/widget/dialogue/error_dialog.dart';
import 'package:deepple_app/app/widget/error/dialogue_error.dart';
import 'package:deepple_app/features/contact_setting/domain/provider/contact_setting_notifier.dart';
import 'package:deepple_app/features/profile/domain/provider/profile_notifier.dart';
import 'package:deepple_app/features/profile/domain/provider/profile_state.dart';
import 'package:deepple_app/features/profile/presentation/widget/contact_initialize_bottomsheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:deepple_app/features/profile/domain/common/model.dart';
import 'package:deepple_app/features/profile/presentation/widget/widget.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({
    super.key,
    required this.userId,
    required this.fromMatchedProfile,
  });

  final int userId;
  final bool fromMatchedProfile;

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    ref.listen(profileProvider(widget.userId), _listener);
    final state = ref.watch(profileProvider(widget.userId));

    return Scaffold(
      body: state.isLoaded
          ? widget.fromMatchedProfile
                ? UnMatchedProfile(userId: widget.userId, chatEnabled: false)
                : switch (state.matchStatus) {
                    final UnMatched _ ||
                    final Matching _ => UnMatchedProfile(userId: widget.userId),
                    final Matched _ => MatchedProfile(widget.userId),
                    null => Container(),
                  }
          : const SkeletonProfile(),
    );
  }

  void _listener(ProfileState? prev, ProfileState curr) {
    final contactProvider = ref.read(contactSettingProvider);
    final (isContactSettingInitialized, contactMethod) =
        (contactProvider.isContactSettingInitialized, contactProvider.method,);

    if (prev?.matchStatus != curr.matchStatus) {
      _handleStatusChanged(
        curr.matchStatus,
        isContactInitialized: isContactSettingInitialized,
        contactMethod: contactMethod,
      );
    }

    if (prev?.error != curr.error) {
      _handleErrorChanged(curr.error, curr.needToExit);
    }
  }

  void _handleStatusChanged(
    MatchStatus? status, {
    required bool isContactInitialized,
    required ContactMethod? contactMethod,
  }) {
    if (status == null || !mounted) return;
    final profileNotifier = ref.read(profileProvider(widget.userId).notifier);

    switch (status) {
      case final Matching status when status is MatchingReceived:
        AnnouncementBottomSheet.open(
          context,
          title: '메시지를 받았어요',
          subTitle: '상대방의 메시지를 수락하면 서로의 연락처가 공개됩니다.',
          content: status.receivedMessage,
          submitLabel: '수락',
          onSubmit: () async {
            context.pop();

            if (!isContactInitialized) {
              final res = await ContactInitializeBottomsheet.open(context);
              if (res != true || !mounted) return;
            }

            MessageSendBottomSheet.open(
              context,
              userId: widget.userId,
              onSubmit: () => ref
                  .read(profileProvider(widget.userId).notifier)
                  .approveMatch(contactMethod ?? ContactMethod.phone),
            );
          },
          cancelLabel: '거절',
          onCancel: () async {
            context.pop();
            await profileNotifier.rejectMatch();
          },
        );
        break;
      case final Matching status when status is MatchingRequested:
        if (status.isExpired) {
          AnnouncementBottomSheet.openPrimary(
            context,
            title: '매칭이 취소되었어요',
            subTitle: '상대방으로부터 응답이 없어 사용하신 하트를 돌려드렸어요',
            content: status.sentMessage,
            submitLabel: '닫기',
            onSubmit: () async {
              context.pop();
              await profileNotifier.resetMatchStatus();
            },
          );
          return;
        }
        AnnouncementBottomSheet.openPrimary(
          context,
          title: '메시지를 보냈어요',
          subTitle: '상대방이 수락하면 서로의 연락처가 공개됩니다.',
          content: status.sentMessage,
          submitLabel: '닫기',
          onSubmit: context.pop,
        );
        break;
      case final Matching _ || Matched _ || UnMatched _:
        break;
    }
  }

  void _handleErrorChanged(DialogueErrorType? error, bool needToExit) {
    if (error == null) return;

    ErrorDialog.open(
      context,
      error: error,
      onConfirm: () {
        ref.read(profileProvider(widget.userId).notifier).resetError();
        context.pop();

        if (needToExit) context.popUntil(AppRoute.mainTab);
      },
    );
  }
}
