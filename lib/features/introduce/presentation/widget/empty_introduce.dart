import 'package:deepple_app/app/constants/fonts.dart';
import 'package:deepple_app/app/constants/icon_path.dart';
import 'package:deepple_app/app/widget/icon/default_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class EmptyIntroduce extends ConsumerWidget {
  const EmptyIntroduce({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const DefaultIcon(IconPath.frowningFace, size: 48),
          const Gap(8.0),
          Text(
            '아직 작성된 소개글이 없어요',
            textAlign: TextAlign.center,
            style: Fonts.regular(fontSize: 14.sp, lineHeight: 1.4.h),
          ),
        ],
      ),
    );
  }
}
