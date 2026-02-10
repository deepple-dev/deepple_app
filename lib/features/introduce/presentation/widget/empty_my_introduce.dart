import 'package:deepple_app/app/constants/fonts.dart';
import 'package:deepple_app/app/constants/icon_path.dart';
import 'package:deepple_app/app/router/router.dart';
import 'package:deepple_app/app/widget/button/default_outlined_button.dart';
import 'package:deepple_app/app/widget/icon/default_icon.dart';
import 'package:deepple_app/features/introduce/domain/provider/introduce_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class EmptyMyIntroduce extends ConsumerWidget {
  const EmptyMyIntroduce({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const DefaultIcon(IconPath.frowningFace, size: 48),
          const Gap(8.0),
          Text(
            '아직 작성하신 소개글이 없어요\n셀프소개로 당신의 진심을 건네보세요',
            textAlign: TextAlign.center,
            style: Fonts.regular(fontSize: 14.sp, lineHeight: 1.4.h),
          ),
          const Gap(52.0),
          DefaultOutlinedButton(
            child: const Text('셀프소개글 등록하기'),
            onPressed: () async {
              await navigate(context, route: AppRoute.introduceRegister);
              ref.read(introduceProvider.notifier).fetchIntroduceList();
            },
          ),
        ],
      ),
    );
  }
}
