import 'package:deepple_app/app/constants/constants.dart';
import 'package:deepple_app/app/provider/provider.dart';
import 'package:deepple_app/app/router/route_arguments.dart';
import 'package:deepple_app/app/router/router.dart';
import 'package:deepple_app/app/widget/widget.dart';
import 'package:deepple_app/features/exam/domain/provider/domain.dart';
import 'package:deepple_app/features/exam/presentation/widget/empty_list.dart';
import 'package:deepple_app/features/home/domain/model/cached_user_profile.dart';
import 'package:deepple_app/features/home/domain/model/introduced_profile.dart';
import 'package:deepple_app/features/home/presentation/widget/category/user_by_category_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:deepple_app/core/state/base_page_state.dart';
import 'package:gap/gap.dart';

class SoulmatePage extends ConsumerStatefulWidget {
  const SoulmatePage({super.key});

  @override
  SoulmatePageState createState() => SoulmatePageState();
}

class SoulmatePageState extends BaseConsumerStatefulPageState<SoulmatePage> {
  SoulmatePageState() : super(isAppBar: false, isHorizontalMargin: false);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget buildPage(BuildContext context) {
    final examState = ref.watch(examProvider);
    final notifier = ref.read(examProvider.notifier);
    final userProfile = ref.watch(globalProvider).profile;

    return Scaffold(
      appBar: DefaultAppBar(title: '매칭 결과'),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
        child: Column(
          children: [
            _ResultHeader(
              soulmateCount: examState.soulmateList.soulmateList.length,
            ),
            Expanded(
              child: _ResultList(
                profiles: examState.soulmateList.soulmateList,
                userProfile: userProfile,
                fetchHeartBalance: () => notifier.fetchUserHeartBalance(),
                onOpenProfile: (memberId) => notifier.openProfile(
                  memberId: memberId,
                  isSoulmate: examState.hasSoulmate,
                ),
                onTapProfile: (memberId) {
                  navigate(
                    context,
                    route: AppRoute.profile,
                    extra: ProfileDetailArguments(userId: memberId),
                  );
                },
              ),
            ),
            _ResultBottomButton(),
          ],
        ),
      ),
    );
  }
}

class _ResultHeader extends StatelessWidget {
  final int soulmateCount;

  const _ResultHeader({required this.soulmateCount});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '나의 소울메이트를 찾았어요',
            style: Fonts.header02().copyWith(
              color: Palette.colorBlack,
              fontWeight: FontWeight.w700,
            ),
          ),
          const Gap(6),
          Text(
            '상대방과 모두 같은 답을 선택하셨어요!',
            style: Fonts.body02Regular().copyWith(color: Palette.colorGrey500),
          ),
          const Gap(12),
        ],
      ),
    );
  }
}

class _ResultList extends StatelessWidget {
  final List<IntroducedProfile> profiles;
  final CachedUserProfile userProfile;
  final int Function() fetchHeartBalance;
  final Future<void> Function(int memberId) onOpenProfile;
  final void Function(int memberId) onTapProfile;

  const _ResultList({
    required this.profiles,
    required this.userProfile,
    required this.fetchHeartBalance,
    required this.onOpenProfile,
    required this.onTapProfile,
  });

  @override
  Widget build(BuildContext context) {
    if (profiles.isEmpty) return const EmptyList();

    return ListView.separated(
      itemCount: profiles.length,
      separatorBuilder: (_, _) => const Gap(8),
      itemBuilder: (context, index) {
        final profile = profiles[index];
        final isBlurred = !profile.isIntroduced;

        return UserByCategoryListItem(
          isBlurred: isBlurred,
          profile: profile,
          onTap: () async {
            if (!profile.isIntroduced) {
              await onOpenProfile(profile.memberId);
            }

            onTapProfile(profile.memberId);
          },
        );
      },
    );
  }
}

class _ResultBottomButton extends StatelessWidget {
  const _ResultBottomButton();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: Dimens.bottomPadding),
      child: DefaultElevatedButton(
        onPressed: () {
          navigate(
            context,
            route: AppRoute.mainTab,
            method: NavigationMethod.go,
          );
        },
        child: const Text('이 결과와 딱 맞는 사람 추천받기'),
      ),
    );
  }
}
