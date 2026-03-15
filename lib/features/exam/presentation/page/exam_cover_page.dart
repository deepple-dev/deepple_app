import 'package:deepple_app/app/constants/constants.dart';
import 'package:deepple_app/app/router/router.dart';
import 'package:deepple_app/app/widget/button/default_elevated_button.dart';
import 'package:deepple_app/app/widget/icon/default_icon.dart';
import 'package:deepple_app/app/widget/image/default_image.dart';
import 'package:deepple_app/app/widget/overlay/bubble.dart';
import 'package:deepple_app/core/state/base_page_state.dart';
import 'package:deepple_app/core/util/toast.dart';
import 'package:deepple_app/features/exam/domain/provider/exam_notifier.dart';
import 'package:deepple_app/features/exam/presentation/widget/bullet_text.dart';
import 'package:deepple_app/features/exam/presentation/widget/subject_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'dart:math' as math;

class ExamCoverPage extends ConsumerStatefulWidget {
  const ExamCoverPage({super.key});

  @override
  ExamCoverPageState createState() => ExamCoverPageState();
}

class ExamCoverPageState extends BaseConsumerStatefulPageState<ExamCoverPage> {
  ExamCoverPageState() : super(isAppBar: false, isHorizontalMargin: false);

  @override
  Widget buildPage(BuildContext context) {
    final notifier = ref.read(examProvider.notifier);

    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [0.7, 1.0],
          colors: [Color(0xFF14131A), Color(0xFF2B2746)],
        ),
      ),
      child: Column(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: 30.w),
                    child: Transform.rotate(
                      angle: -27 * (math.pi / 180),
                      child: const DefaultIcon(IconPath.star, size: 28),
                    ),
                  ),
                ),
                const Gap(16),
                Text(
                  '나와 잘 맞는 사람은 누구일까?',
                  style: Fonts.header02().copyWith(
                    fontWeight: FontWeight.w500,
                    color: Palette.colorGrey400,
                  ),
                ),
                const Gap(16),
                Text(
                  '나의 성향 찾으러 가기',
                  style: Fonts.title().copyWith(color: Palette.colorWhite),
                ),
                const Gap(24),
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: EdgeInsets.only(right: 30.w),
                    child: Transform.rotate(
                      angle: -64 * (math.pi / 180),
                      child: const DefaultIcon(IconPath.star, size: 40),
                    ),
                  ),
                ),
                const Gap(12),
                DefaultImage.asset(
                  'assets/images/exam_pic.png',
                  width: double.infinity,
                  height: 312.h,
                  fit: BoxFit.cover,
                  borderRadius: BorderRadius.zero,
                ),
                const Spacer(),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: screenWidth * 0.05,
              right: screenWidth * 0.05,
              bottom: Dimens.bottomPadding,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                bubbleWidget(
                  comment: '참여 시 하트 15개를 드릴게요',
                  boldText: '하트 15개',
                  width: screenWidth * 0.5,
                  textStyle: Fonts.body03Regular(),
                  shadowColor: const Color(0xFF14131A),
                ),
                DefaultElevatedButton(
                  primary: palette.primary,
                  onPressed: () async {
                    await notifier.fetchRequiredQuestions();
                    if (!context.mounted) return;
                    final examState = ref.read(examProvider);
                    final hasNoQuestions =
                        examState.questionList.questionList.isEmpty;
                    if (hasNoQuestions) {
                      showToastMessage('문제를 불러오지 못했어요. 잠시 후 다시 시도해 주세요.');
                      return;
                    }
                    navigate(context, route: AppRoute.examQuestion);
                  },
                  child: Text(
                    '테스트하고 이상형 추천 받으세요',
                    style: Fonts.body01Regular(palette.onPrimary),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
