import 'package:deepple_app/app/constants/constants.dart';
import 'package:deepple_app/app/router/route_arguments.dart';
import 'package:deepple_app/app/router/router.dart';
import 'package:deepple_app/app/widget/button/button.dart';
import 'package:deepple_app/core/extension/extended_context.dart';
import 'package:deepple_app/features/profile/domain/common/model.dart';
import 'package:deepple_app/features/profile/domain/provider/profile_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:deepple_app/app/enum/enum.dart';

import 'package:deepple_app/features/profile/presentation/widget/widget.dart';

class MatchedProfile extends ConsumerWidget {
  const MatchedProfile(this.userId, {super.key});

  final int userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileProvider(userId)).profile;
    if (profile == null) return Container();

    final matchStatus = profile.matchStatus;

    return Scaffold(
      appBar: ProfileAppbar.matched(
        onTapInfo: () => navigate(
          context,
          route: AppRoute.report,
          extra: ReportArguments(name: profile.name, userId: userId),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 16.0,
          children: [
            _GuideMessage(otherUserName: profile.name),
            SizedBox(
              height: 420.0,
              child: ProfileMainImage(profileUri: profile.profileUri),
            ),
            _ProfilePageMoveButton(userId: userId),
            if (matchStatus is Matched)
              _MatchedInformation(
                contactMethod: matchStatus.contactMethod,
                contactInfo: matchStatus.contactInfo,
                receivedMessage: matchStatus.receivedMessage,
                sentMessage: matchStatus.sentMessage,
              ),
          ],
        ),
      ),
    );
  }
}

class _GuideMessage extends StatelessWidget {
  const _GuideMessage({required this.otherUserName});

  final String otherUserName;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 8.0,
      children: [
        Text('$otherUserName님과 매칭이 완료되었어요.', style: Fonts.header02()),
        Text(
          '지금 바로 연락하면 좋은 흐름을 이어갈 수 있어요',
          style: Fonts.body02Medium(context.colorScheme.tertiary),
        ),
      ],
    );
  }
}

class _ProfilePageMoveButton extends StatelessWidget {
  const _ProfilePageMoveButton({required this.userId});

  final int userId;

  @override
  Widget build(BuildContext context) {
    return DefaultElevatedButton(
      onPressed: () => navigate(
        context,
        route: AppRoute.profile,
        method: NavigationMethod.pushReplacement,
        extra: ProfileDetailArguments(userId: userId, fromMatchedProfile: true),
      ),
      padding: const EdgeInsets.symmetric(vertical: 11.5),
      child: const Text('프로필 보러가기'),
    );
  }
}

class _MatchedInformation extends StatelessWidget {
  const _MatchedInformation({
    required this.contactMethod,
    required this.contactInfo,
    required this.receivedMessage,
    required this.sentMessage,
  });

  final ContactMethod contactMethod;
  final String contactInfo;
  final String receivedMessage;
  final String sentMessage;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 24.0,
        children: [
          _InformationBox(title: contactMethod.label, content: contactInfo),
          _InformationBox(title: '받은 메시지', content: receivedMessage),
          _InformationBox(title: '보낸 메시지', content: sentMessage),
        ],
      ),
    );
  }
}

class _InformationBox extends StatelessWidget {
  const _InformationBox({required this.title, required this.content});

  final String title;
  final String content;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 8.0,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(title, style: Fonts.body02Medium()),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: Dimens.cardRadius,
          ),
          padding: const EdgeInsets.all(12.0),
          child: Text(content, style: Fonts.body02Medium()),
        ),
      ],
    );
  }
}
