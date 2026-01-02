import 'package:deepple_app/app/constants/constants.dart';
import 'package:deepple_app/app/provider/global_notifier.dart';
import 'package:deepple_app/app/router/route_arguments.dart';
import 'package:deepple_app/app/router/router.dart';
import 'package:deepple_app/core/state/base_page_state.dart';
import 'package:deepple_app/core/util/toast.dart';
import 'package:deepple_app/features/home/presentation/provider/provider.dart';
import 'package:deepple_app/features/home/presentation/widget/home/home_banner_area.dart';
import 'package:deepple_app/features/home/presentation/widget/home/home_category_buttons_area.dart';
import 'package:deepple_app/features/home/presentation/widget/home/home_navbar_area.dart';
import 'package:deepple_app/features/home/presentation/widget/home/home_profile_card_area.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  void initState() {
    super.initState();
    ref.read(globalProvider.notifier).initProfile();
    ref.read(globalProvider.notifier).fetchHeartBalance();
  }

  @override
  Widget build(BuildContext context) {
    final homeStateAsync = ref.watch(homeProvider);
    final homeNotifier = ref.read(homeProvider.notifier);

    return Scaffold(
      body: SafeArea(
        child: homeStateAsync.when(
          data: (data) => Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    const HomeNavbarArea(), // 홈 상단 네비게이션바
                    const Gap(16),
                    const HomeProfileCardArea(), // 소개받은 프로필 부분
                    const Gap(16),
                    HomeCategoryButtonsArea(
                      // 카테고리 버튼 영역
                      onTapButton: (category) async {
                        final hasProfiles = await homeNotifier
                            .checkIntroducedProfiles(
                              IntroducedCategory.parse(category),
                            );
                        if (!hasProfiles) {
                          showToastMessage(
                            '조건에 맞는 이성을 찾지 못했어요',
                            gravity: ToastGravity.TOP,
                          );
                          return;
                        }
                        if (context.mounted) {
                          navigate(
                            context,
                            route: AppRoute.userByCategory,
                            extra: UserByCategoryArguments(
                              category: IntroducedCategory.parse(category),
                            ),
                          );
                        }
                      },
                    ),
                    const Gap(24),
                    const HomeBannerArea(),
                  ],
                ),
              ),
              if (data.isCheckingIntroducedProfiles) ...[
                const ModalBarrier(
                  dismissible: false,
                  color: Colors.transparent,
                ),
                const Center(child: CircularProgressIndicator()),
              ],
            ],
          ),
          error: (error, stackTrace) => const SizedBox.shrink(),
          loading: () => const Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }
}
