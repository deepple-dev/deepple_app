import 'package:deepple_app/app/constants/constants.dart';
import 'package:deepple_app/app/router/router.dart';
import 'package:deepple_app/app/widget/widget.dart';
import 'package:deepple_app/core/util/toast.dart';
import 'package:deepple_app/features/exam/domain/model/personality_type.dart';
import 'package:deepple_app/features/exam/domain/provider/domain.dart';
import 'package:deepple_app/features/exam/presentation/widget/personality_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:deepple_app/core/state/base_page_state.dart';
import 'package:gap/gap.dart';

class ExamResultPage extends ConsumerStatefulWidget {
  const ExamResultPage({super.key});

  @override
  ExamResultPageState createState() => ExamResultPageState();
}

class ExamResultPageState
    extends BaseConsumerStatefulPageState<ExamResultPage> {
  ExamResultPageState() : super(isAppBar: false, isHorizontalMargin: false);

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final examState = ref.read(examProvider);

      if (!examState.isDone) {
        showToastMessage('연애가치관 테스트 참여 완료! 하트 15개를 받았어요');
      }
    });
  }

  @override
  Widget buildPage(BuildContext context) {
    final examState = ref.watch(examProvider);
    final notifier = ref.read(examProvider.notifier);

    return Scaffold(
      appBar: DefaultAppBar(
        title: '테스트 결과',
        leadingAction: (_) => _showLeaveExamDialogue(context, notifier),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
        child: Column(
          children: [
            const Gap(16),
            _ResultHeader(),
            const Gap(38),
            PersonalityCard(type: examState.personalityType),
            const Spacer(),
            _ResultBottomButton(hasSoulmate: examState.hasSoulmate),
          ],
        ),
      ),
    );
  }

  void _showLeaveExamDialogue(BuildContext context, ExamNotifier notifier) {
    CustomDialogue.showTwoChoiceDialogue(
      context: context,
      content: '테스트를 종료 하시겠어요?\n페이지를 벗어날경우, 저장되지 않아요',
      onElevatedButtonPressed: () {
        notifier.resetCurrentSubjectIndex();
        navigate(context, route: AppRoute.mainTab);
      },
    );
  }
}

class _ResultHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '당신의',
            style: Fonts.header02().copyWith(
              color: Palette.colorPrimary500,
              fontWeight: FontWeight.w900,
            ),
          ),
          const Gap(8),
          Text(
            '연애 가치관은?',
            style: Fonts.header02().copyWith(
              color: Palette.colorBlack,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class _ResultBottomButton extends StatelessWidget {
  final bool hasSoulmate;

  const _ResultBottomButton({required this.hasSoulmate});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: Dimens.bottomPadding),
      child: DefaultElevatedButton(
        onPressed: () {
          if (hasSoulmate) {
            navigate(context, route: AppRoute.soulmate);
            return;
          }
          navigate(
            context,
            route: AppRoute.mainTab,
            method: NavigationMethod.go,
          );
        },
        child: hasSoulmate
            ? const Text('소울메이트 발견! 확인하러 가기')
            : const Text('이 결과와 딱 맞는 사람 추천받기'),
      ),
    );
  }
}
