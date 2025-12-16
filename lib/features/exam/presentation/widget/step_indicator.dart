import 'package:flutter/material.dart';
import 'package:deepple_app/app/constants/palette.dart';
import 'package:deepple_app/app/constants/fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class StepIndicator extends StatelessWidget {
  final int totalStep; // 총 단계 수
  final int currentStep; // 현재 단계 (1부터 시작)

  const StepIndicator({
    super.key,
    required this.totalStep,
    required this.currentStep,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$currentStep',
              style: Fonts.body03Regular(Palette.colorPrimary500),
            ),
            Text(' / ', style: Fonts.body03Regular(Palette.colorGrey400)),
            Text(
              '$totalStep',
              style: Fonts.body03Regular(Palette.colorGrey400),
            ),
          ],
        ),
        const Gap(8),
        PreferredSize(
          preferredSize: Size.fromHeight(4.h), // Progress bar의 높이를 지정
          child: TweenAnimationBuilder<double>(
            tween: Tween<double>(
              begin: (currentStep - 1) / totalStep,
              end: currentStep / totalStep,
            ),
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            builder: (context, value, child) {
              return LinearProgressIndicator(
                value: value,
                minHeight: 4.h,
                backgroundColor: Palette.colorGrey100,
                color: Palette.colorPrimary500,
              );
            },
          ),
        ),
      ],
    );
  }
}
