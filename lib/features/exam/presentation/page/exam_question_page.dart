import 'package:deepple_app/app/constants/constants.dart';
import 'package:deepple_app/app/router/route_arguments.dart';
import 'package:deepple_app/app/router/router.dart';
import 'package:deepple_app/app/widget/widget.dart';
import 'package:deepple_app/core/util/toast.dart';
import 'package:deepple_app/features/exam/data/data.dart';
import 'package:deepple_app/features/exam/domain/provider/domain.dart';
import 'package:deepple_app/features/exam/presentation/widget/answer_radio_button.dart';
import 'package:deepple_app/features/exam/presentation/widget/step_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:deepple_app/app/constants/palette.dart';
import 'package:deepple_app/app/constants/fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:deepple_app/core/state/base_page_state.dart';
import 'package:gap/gap.dart';

class ExamQuestionPage extends ConsumerStatefulWidget {
  const ExamQuestionPage({super.key});

  @override
  ExamQuestionPageState createState() => ExamQuestionPageState();
}

class ExamQuestionPageState
    extends BaseConsumerStatefulPageState<ExamQuestionPage> {
  ExamQuestionPageState() : super(isAppBar: false, isHorizontalMargin: false);

  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget buildPage(BuildContext context) {
    final examState = ref.watch(examProvider);
    final notifier = ref.read(examProvider.notifier);

    if (!examState.isLoaded || examState.questionList.questionList.isEmpty) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final currentSubject =
        examState.questionList.questionList[examState.currentSubjectIndex];

    final double horizontalPadding = screenWidth * 0.05;
    final EdgeInsets contentPadding = EdgeInsets.symmetric(
      horizontal: horizontalPadding,
    );

    return Scaffold(
      appBar: DefaultAppBar(
        title: currentSubject.name,
        leadingAction: (context) => _showLeaveExamDialogue(context, notifier),
      ),
      body: Padding(
        padding: contentPadding,
        child: Column(
          children: [
            _QuestionHeader(
              currentPage: _currentPage,
              totalQuestions: currentSubject.questions.length,
              question: currentSubject.questions[_currentPage],
            ),
            Expanded(
              child: _QuestionPageView(
                pageController: _pageController,
                questions: currentSubject.questions,
                selectedAnswerMap: examState.currentAnswerMap,
                onAnswerSelected: (questionId, answerId) {
                  notifier.selectAnswer(questionId, answerId);
                },
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                onNextPage: () {
                  if (examState.currentPage <
                      currentSubject.questions.length - 1) {
                    notifier.nextPage();
                    _pageController.nextPage(
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeInOut,
                    );
                  }
                },
              ),
            ),
            _QuestionBottomButton(
              currentPage: _currentPage,
              totalQuestions: currentSubject.questions.length,
              onPrevPage: () {
                if (examState.currentPage > 0) {
                  notifier.previousPage();
                  _pageController.previousPage(
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeInOut,
                  );
                } else {
                  _showLeaveExamDialogue(context, notifier);
                }
              },
              onNextPage: () async {
                _pageController.jumpToPage(0);
                final result = await notifier.submitCurrentSubject();

                switch (result) {
                  case ExamSubmitResult.examFinished:
                  case ExamSubmitResult.showResult:
                    if (!context.mounted) break;
                    navigate(
                      context,
                      route: AppRoute.examResult,
                      extra: const ExamResultArguments(
                        isFromDirectAccess: false,
                      ),
                    );
                    break;
                  case ExamSubmitResult.nextSubject:
                    break;
                  case ExamSubmitResult.error:
                    showToastMessage('제출 중 오류가 발생했습니다.');
                    break;
                }
              },
              isSelectAll:
                  examState.currentAnswerMap.length !=
                  currentSubject.questions.length,
              isSubjectOptional: examState.isSubjectOptional,
              isLastSubject: notifier.isLastSubject,
              screenHeight: screenHeight,
            ),
          ],
        ),
      ),
    );
  }

  void _showLeaveExamDialogue(BuildContext context, ExamNotifier notifier) {
    CustomDialogue.showTwoChoiceDialogue(
      context: context,
      content: '연애 모의고사를 종료 하시겠어요?\n페이지를 벗어날경우, 저장되지 않아요',
      onElevatedButtonPressed: () {
        _pageController.jumpToPage(0);
        notifier.setSubjectOptional(false);
        notifier.resetCurrentSubjectIndex();

        Navigator.of(context).pop();
        navigate(context, route: AppRoute.mainTab);
      },
    );
  }
}

class _QuestionHeader extends StatelessWidget {
  final int currentPage;
  final int totalQuestions;
  final QuestionItem question;

  const _QuestionHeader({
    required this.currentPage,
    required this.totalQuestions,
    required this.question,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Gap(24),
        StepIndicator(totalStep: totalQuestions, currentStep: currentPage + 1),
        const Gap(24),
        ConstrainedBox(
          constraints: BoxConstraints(minHeight: 60.h),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${currentPage + 1}. ',
                style: Fonts.header03().copyWith(
                  color: Palette.colorBlack,
                  fontWeight: FontWeight.w700,
                  height: 1.3,
                ),
              ),
              Flexible(
                child: Text(
                  question.content,
                  style: Fonts.header03().copyWith(
                    color: Palette.colorBlack,
                    fontWeight: FontWeight.w700,
                    height: 1.3,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _QuestionPageView extends StatelessWidget {
  final PageController pageController;
  final List<QuestionItem> questions;
  final Map<int, int?> selectedAnswerMap;
  final void Function(int questionId, int answerId) onAnswerSelected;
  final VoidCallback onNextPage;
  final ValueChanged<int> onPageChanged;

  const _QuestionPageView({
    required this.pageController,
    required this.questions,
    required this.selectedAnswerMap,
    required this.onAnswerSelected,
    required this.onNextPage,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: pageController,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: questions.length,
      onPageChanged: onPageChanged,
      itemBuilder: (context, index) {
        final question = questions[index];
        final selectedAnswerId = selectedAnswerMap[question.id];
        return Column(
          children: question.answers.map((answer) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: AnswerRadioButton(
                id: answer.id,
                selectedId: selectedAnswerId,
                content: answer.content,
                onTap: (id) {
                  onAnswerSelected(question.id, id);
                  onNextPage();
                },
              ),
            );
          }).toList(),
        );
      },
    );
  }
}

class _QuestionBottomButton extends StatelessWidget {
  final int currentPage;
  final int totalQuestions;
  final VoidCallback onPrevPage;
  final VoidCallback onNextPage;
  final bool isSelectAll;
  final bool isSubjectOptional;
  final bool isLastSubject;
  final double screenHeight;

  const _QuestionBottomButton({
    required this.currentPage,
    required this.totalQuestions,
    required this.onPrevPage,
    required this.onNextPage,
    required this.isSelectAll,
    required this.isSubjectOptional,
    required this.isLastSubject,
    required this.screenHeight,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: Dimens.bottomPadding),
      child: Row(
        spacing: 8.0,
        children: [
          Expanded(
            child: DefaultOutlinedButton(
              primary: Palette.colorGrey100,
              textColor: Palette.colorGrey500,
              onPressed: onPrevPage,
              child: const Text('이전'),
            ),
          ),
          Expanded(
            child: DefaultElevatedButton(
              onPressed: isSelectAll ? null : onNextPage,
              child: Text(
                isSubjectOptional
                    ? isLastSubject
                          ? '저장하기'
                          : '다음'
                    : isLastSubject
                    ? '제출하기'
                    : '저장하기',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
