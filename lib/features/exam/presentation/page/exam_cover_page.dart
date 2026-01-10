import 'package:deepple_app/app/constants/constants.dart';
import 'package:deepple_app/app/router/router.dart';
import 'package:deepple_app/app/widget/button/default_elevated_button.dart';
import 'package:deepple_app/core/state/base_page_state.dart';
import 'package:deepple_app/features/exam/domain/provider/exam_notifier.dart';
import 'package:deepple_app/features/exam/presentation/widget/bullet_text.dart';
import 'package:deepple_app/features/exam/presentation/widget/subject_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class ExamCoverPage extends ConsumerStatefulWidget {
  const ExamCoverPage({super.key});

  @override
  ExamCoverPageState createState() => ExamCoverPageState();
}

class ExamCoverPageState extends BaseConsumerStatefulPageState<ExamCoverPage> {
  ExamCoverPageState() : super(defaultAppBarTitle: '연애 모의고사');

  @override
  Widget buildPage(BuildContext context) {
    final notifier = ref.read(examProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 9,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Gap(8),
                Text(
                  '필수과목 30 / 선택 과목 20 (총 50문항)',
                  style: Fonts.body02Medium(),
                ),
                const Gap(12),
                Container(
                  decoration: BoxDecoration(
                    color: Palette.colorGrey50,
                    border: Border.all(width: 1.w, color: Palette.colorGrey100),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 24.w,
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        BulletText(
                          text:
                              '본 고사는 서로의 가치관과 생각을 이해하기 위한 것으로 진실에 근거하여 성실한 자세로 임하셔야 합니다.',
                        ),
                        BulletText(
                          text:
                              '필수과목 30문제를 풀고 선택한 모든 항목이 나와 동일한 상대방과 무료로 매칭을 진행할 수 있습니다',
                        ),
                        BulletText(text: '연애 모의고사 최초 1회 참여 시 15하트를 지급해 드립니다'),
                      ],
                    ),
                  ),
                ),
                const Gap(24),
                Text('필수과목 30', style: Fonts.body03Regular(Palette.colorBlack)),
                const Gap(8),
                Container(
                  decoration: BoxDecoration(
                    color: Palette.colorWhite,
                    border: Border.all(width: 1.w, color: Palette.colorGrey100),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SubjectItem(name: '가치관', count: '10'),
                        SubjectItem(name: '데이트', count: '10'),
                        SubjectItem(name: '취향', count: '10'),
                      ],
                    ),
                  ),
                ),
                const Gap(24),
                Text('선택과목 20', style: Fonts.body03Regular(Palette.colorBlack)),
                const Gap(8),
                Container(
                  decoration: BoxDecoration(
                    color: Palette.colorWhite,
                    border: Border.all(width: 1.w, color: Palette.colorGrey100),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SubjectItem(name: '연애밸런스', count: '12'),
                        SubjectItem(name: '결혼', count: '8'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: Dimens.bottomPadding),
          child: DefaultElevatedButton(
            onPressed: () async {
              await notifier.fetchRequiredQuestions();
              if (!context.mounted) return;
              navigate(
                context,
                route: AppRoute.examQuestion,
                method: NavigationMethod.go,
              );
            },
            child: Text(
              '연애 모의고사 시작하기',
              style: Fonts.body01Medium().copyWith(color: Palette.colorWhite),
            ),
          ),
        ),
      ],
    );
  }
}
