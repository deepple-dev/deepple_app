import 'package:deepple_app/app/constants/constants.dart';
import 'package:deepple_app/app/provider/provider.dart';
import 'package:deepple_app/app/router/route_arguments.dart';
import 'package:deepple_app/app/router/router.dart';
import 'package:deepple_app/app/widget/widget.dart';
import 'package:deepple_app/features/home/home.dart';
import 'package:deepple_app/features/home/presentation/widget/category/heart_shortage_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

class UserByCategoryPage extends ConsumerStatefulWidget {
  final IntroducedCategory category;
  const UserByCategoryPage({super.key, required this.category});

  @override
  ConsumerState<UserByCategoryPage> createState() => _UserByCategoryPageState();
}

class _UserByCategoryPageState extends ConsumerState<UserByCategoryPage> {
  @override
  Widget build(BuildContext context) {
    final introducedProfilesAsync = ref.watch(
      introducedProfilesProvider(widget.category),
    );
    final introducedProfilesNotifier = ref.read(
      introducedProfilesProvider(widget.category).notifier,
    );
    final userProfile = ref.watch(globalProvider).profile;

    return Scaffold(
      appBar: DefaultAppBar(title: widget.category.label),
      body: introducedProfilesAsync.when(
        data: (profiles) {
          return ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            itemCount: profiles.length,
            separatorBuilder: (_, __) => const Gap(8),
            itemBuilder: (context, index) {
              final profile = profiles[index];
              final isBlurred = !profile.isIntroduced;

              return UserByCategoryListItem(
                isBlurred: isBlurred,
                onTap: () => _handleProfileTap(
                  context: context,
                  profile: profile,
                  index: index,
                  isBlurred: isBlurred,
                  introducedProfilesNotifier: introducedProfilesNotifier,
                  isMale: userProfile.isMale,
                ),
                profile: profile,
              );
            },
          );
        },
        error: (error, _) => Center(child: Text('Error: $error')),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }

  Future<void> _handleProfileTap({
    required BuildContext context,
    required IntroducedProfile profile,
    required int index,
    required bool isBlurred,
    required IntroducedProfilesNotifier introducedProfilesNotifier,
    required bool isMale,
  }) async {
    if (isBlurred) {
      final heartBalance = ref
          .watch(globalProvider)
          .heartBalance
          .totalHeartBalance;

      if (!context.mounted) return;

      final openProfileHeartCount = isMale
          ? Dimens.maleIntroducedProfileOpenHeartCount
          : Dimens.femaleIntroducedProfileOpenHeartCount;

      if (heartBalance < openProfileHeartCount) {
        showDialog(
          context: context,
          builder: (context) {
            return HeartShortageDialog(heartBalance: heartBalance);
          },
        );
        return;
      }

      final pressed = await showDialog<bool>(
        context: context,
        builder: (context) => UnlockWithHeartDialog(
          description: '소개 받으시겠습니까?',
          heartBalance: heartBalance,
          isMale: isMale,
        ),
      );

      if (pressed != true) return;

      final profileOpenCompleted = await introducedProfilesNotifier.openProfile(
        index: index,
        memberId: profile.memberId,
      );

      if (!context.mounted) return;

      if (!profileOpenCompleted) return;

      _navigateToProfile(context, profile);
      return;
    }

    // isBlurred == false일 때만 아래 실행
    _navigateToProfile(context, profile);
  }

  Future<dynamic> _navigateToProfile(
    BuildContext context,
    IntroducedProfile profile,
  ) {
    return navigate(
      context,
      route: AppRoute.profile,
      extra: ProfileDetailArguments(userId: profile.memberId),
    );
  }
}
