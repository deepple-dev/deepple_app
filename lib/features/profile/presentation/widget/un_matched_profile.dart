import 'package:deepple_app/app/router/route_arguments.dart';
import 'package:deepple_app/app/router/router.dart';
import 'package:flutter/material.dart';
import 'package:deepple_app/features/profile/domain/provider/profile_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:deepple_app/features/profile/presentation/widget/widget.dart';

class UnMatchedProfile extends StatelessWidget {
  const UnMatchedProfile({
    super.key,
    required this.userId,
    this.chatEnabled = true,
  });

  final int userId;
  final bool chatEnabled;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _ProfileHeadInformation(userId: userId, chatEnabled: chatEnabled),
          ProfileSubInformation(userId),
          const Gap(13.0),
          ProfileSelfIntroduction(userId),
        ],
      ),
    );
  }
}

class _ProfileHeadInformation extends ConsumerWidget {
  const _ProfileHeadInformation({
    required this.userId,
    required this.chatEnabled,
  });

  final int userId;
  final bool chatEnabled;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userInfo = ref.watch(profileProvider(userId)).profile;
    if (userInfo == null) return Container();

    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 480.0),
      child: Stack(
        children: [
          Positioned.fill(
            child: ProfileMainImage(profileUri: userInfo.profileUri),
          ),
          ProfileAppbar(
            onBackButtonPressed: context.pop,
            onTapInfo: () => navigate(
              context,
              route: AppRoute.report,
              extra: ReportArguments(name: userInfo.name, userId: userId),
            ),
          ),
          Positioned(
            left: 0,
            bottom: 0,
            right: 0,
            child: ProfileMainInformation(
              userId: userId,
              name: userInfo.name,
              age: userInfo.age,
              mbti: userInfo.mbti,
              address: userInfo.address,
              hobbies: userInfo.hobbies,
              chatEnabled: chatEnabled,
              favoriteType: userInfo.favoriteType,
              onFavoriteTypeChanged: (type) => ref
                  .read(profileProvider(userId).notifier)
                  .setFavoriteType(type),
            ),
          ),
        ],
      ),
    );
  }
}
