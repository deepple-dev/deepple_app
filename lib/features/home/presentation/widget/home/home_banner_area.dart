import 'package:deepple_app/app/constants/constants.dart';
import 'package:deepple_app/app/provider/provider.dart';
import 'package:deepple_app/app/router/route_arguments.dart';
import 'package:flutter/material.dart';
import 'package:deepple_app/app/router/router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeBannerArea extends ConsumerWidget {
  final double horizontalPadding;

  const HomeBannerArea({super.key, required this.horizontalPadding});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDatingExamSubmitted = ref
        .watch(globalProvider)
        .profile
        .isDatingExamSubmitted;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: GestureDetector(
        onTap: () {
          isDatingExamSubmitted
              ? navigate(
                  context,
                  route: AppRoute.examResult,
                  extra: const ExamResultArguments(isFromDirectAccess: true),
                )
              : navigate(context, route: AppRoute.exam);
        },
        child: Image.asset(ImagePath.homeTest, fit: BoxFit.cover),
      ),
    );
  }
}
