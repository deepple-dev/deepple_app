import 'package:deepple_app/app/constants/constants.dart';
import 'package:deepple_app/app/router/route_arguments.dart';
import 'package:deepple_app/app/router/router.dart';
import 'package:deepple_app/app/widget/widget.dart';
import 'package:deepple_app/core/extension/extended_context.dart';
import 'package:deepple_app/features/home/domain/model/introduced_profile.dart';
import 'package:deepple_app/features/home/presentation/provider/home_notifier.dart';
import 'package:deepple_app/features/home/presentation/widget/blur_cover_widget.dart';
import 'package:deepple_app/features/home/presentation/widget/tag_capsule.dart';
import 'package:deepple_app/features/profile/presentation/widget/widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:shimmer/shimmer.dart';

// 페이지뷰 + 페이지 번호 상태 바
class HomeProfileCardArea extends ConsumerStatefulWidget {
  const HomeProfileCardArea({super.key});

  @override
  ConsumerState<HomeProfileCardArea> createState() =>
      _HomeProfileCardAreaState();
}

class _HomeProfileCardAreaState extends ConsumerState<HomeProfileCardArea> {
  int _currentPage = 0; // 현재 페이지 0으로 설정

  late PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController(viewportFraction: 0.9);
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final homeStateAsync = ref.watch(
      homeProvider.select(
        (value) => value.whenData((data) => data.recommendedProfiles),
      ),
    ); // 소개받은 프로필 정보들
    final homeNotifier = ref.read(homeProvider.notifier);

    return homeStateAsync.when(
      data: (profiles) {
        if (profiles == null) {
          // 로딩 시 보여주는 빈 박스
          return Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.white,
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(16)),
                color: Palette.colorGrey50,
              ),
              height: context.screenHeight * 0.41,
            ),
          );
        }

        if (profiles.isEmpty) {
          return const _EmptyProfileCard(); // 빈 리스트인 경우
        }

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 높이가 동적으로 변하는 컨테이너
            AspectRatio(
              aspectRatio: 1.1,
              child: PageView.builder(
                controller: pageController,
                itemCount: profiles.length,
                padEnds: true,
                onPageChanged: (index) => setState(() => _currentPage = index),
                itemBuilder: (context, index) {
                  final profile = profiles[index];
                  return GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => navigate(
                      context,
                      route: AppRoute.profile,
                      extra: ProfileDetailArguments(userId: profile.memberId),
                    ),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: _ProfileCardWidget(
                            profile: profile,
                            maxWidth: constraints.maxWidth,
                            onTapFavorite: () async {
                              if (profile.favoriteType != null) return;

                              final favoriteType =
                                  await FavoriteTypeSelectDialog.open(
                                    context,
                                    userId: profile.memberId,
                                    favoriteType: profile.favoriteType,
                                  );
                              if (favoriteType == null) return;

                              homeNotifier.setFavoriteType(
                                memberId: profile.memberId,
                                type: favoriteType,
                              );
                            },
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
            const Gap(16),
            _PageCardIndicator(
              totalPages: profiles.length,
              currentPage: _currentPage,
            ),
          ],
        );
      },
      error: (error, stackTrace) {
        return Center(
          child: Text(
            error.toString(),
            style: Fonts.body01Regular().copyWith(
              fontWeight: FontWeight.w500,
              color: Palette.colorGrey600,
            ),
          ),
        );
      },
      loading: () {
        return const CircularProgressIndicator();
      },
    );
  }
}

class _EmptyProfileCard extends StatelessWidget {
  const _EmptyProfileCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.screenWidth,
      height: context.screenHeight * 0.41,
      padding: const EdgeInsets.symmetric(horizontal: 32),
      decoration: BoxDecoration(
        // 카드 색상 및 둥근모서리 설정
        color: Palette.colorGrey50,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const DefaultIcon(IconPath.sadEmotion, size: 48),
          const Gap(8),
          Text(
            '조건에 맞는 이성을 찾지 못했어요\n우측 상단의 필터에서 이상형을 설정할 수 있어요',
            style: Fonts.body03Regular().copyWith(
              fontWeight: FontWeight.w500,
              color: Palette.colorBlack,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// 소개받은 프로필 페이지 - 프로필 정보 카드
class _ProfileCardWidget extends StatelessWidget {
  const _ProfileCardWidget({
    required this.profile,
    required this.maxWidth,
    required this.onTapFavorite,
  });

  final IntroducedProfile profile;
  final double maxWidth;
  final VoidCallback onTapFavorite;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      width: maxWidth - 48,
      decoration: BoxDecoration(
        // 카드 색상 및 둥근모서리 설정
        color: Palette.colorGrey50,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          CachedNetworkImage(
            imageUrl: profile.profileImageUrl,
            fit: BoxFit.cover,
          ),
          const _GradientOverlay(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 6.0,
              children: [
                Text(
                  '${profile.nickname}, ${profile.age}',
                  style: Fonts.semibold(
                    fontSize: 20.sp,
                    color: const Color(0xFF1F1E23),
                  ),
                ),
                Text(
                  '${profile.mbti}・${profile.region}',
                  style: Fonts.body02Regular().copyWith(
                    color: Palette.colorGrey600,
                  ),
                ),
                TagCapsules(hobbies: profile.tags),
              ],
            ),
          ),

          // const BlurCoverWidget(isRect: true),
        ],
      ),
    );
  }
}

class _PageCardIndicator extends StatelessWidget {
  final int totalPages;
  final int currentPage;
  const _PageCardIndicator({
    required this.totalPages,
    required this.currentPage,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      // 페이지 번호 상태 바
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(totalPages, (index) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: 6,
          height: 6,
          decoration: BoxDecoration(
            color: currentPage == index
                ? Palette.colorPrimary500
                : Palette.colorGrey100,
            borderRadius: BorderRadius.circular(8),
          ),
        );
      }),
    );
  }
}

/// 그라디언트 오버레이
class _GradientOverlay extends StatelessWidget {
  const _GradientOverlay();

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      height: 200,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Palette.colorWhite.withValues(alpha: 0),
              Palette.colorWhite.withValues(alpha: 1),
            ],
            stops: const [0.25, 1.0],
          ),
        ),
      ),
    );
  }
}
