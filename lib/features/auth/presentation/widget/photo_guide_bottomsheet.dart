import 'package:deepple_app/app/constants/constants.dart';
import 'package:deepple_app/app/widget/button/default_elevated_button.dart';
import 'package:deepple_app/features/auth/presentation/widget/auth_photo_guide_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class PhotoGuideBottomSheet extends ConsumerWidget {
  const PhotoGuideBottomSheet({super.key, required this.onSubmit});

  final Future Function() onSubmit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 32.w, horizontal: 16.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 400.h,
              child: const SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AuthPhotoGuideWidget(
                      title: '이성에게 좋은 인상을 주는 사진',
                      imagePathsWithText: [
                        {
                          'image': 'assets/images/good_pic1.png',
                          'text': '자연스럽게 웃는 사진',
                        },
                        {
                          'image': 'assets/images/good_pic2.png',
                          'text': '이목구비가 선명한 사진',
                        },
                        {
                          'image': 'assets/images/good_pic3.png',
                          'text': '활동적인 사진',
                        },
                        {
                          'image': 'assets/images/good_pic4.png',
                          'text': '분위기 있는 전신사진',
                        },
                      ],
                    ),
                    Gap(24),
                    AuthPhotoGuideWidget(
                      title: '이성에게 부정적인 인상을 주는 사진',
                      imagePathsWithText: [
                        {
                          'image': 'assets/images/bad_pic1.png',
                          'text': '보정이 과도한 사진',
                        },
                        {
                          'image': 'assets/images/bad_pic3.png',
                          'text': 'AI 프로필',
                        },
                        {
                          'image': 'assets/images/bad_pic2.png',
                          'text': '2인 이상의 단체 사진',
                        },
                        {
                          'image': 'assets/images/bad_pic4.png',
                          'text': '얼굴이 가려진 사진',
                        },
                        {
                          'image': 'assets/images/bad_pic5.png',
                          'text': '마스크를 착용한 사진',
                        },
                        {
                          'image': 'assets/images/bad_pic6.png',
                          'text': '무표정 사진',
                        },
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const Gap(24),
            DefaultElevatedButton(
              primary: Palette.colorPrimary500,
              onPressed: onSubmit,
              child: Text(
                '앨범에서 사진 선택하기',
                style: Fonts.body01Regular(Palette.colorWhite),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Future<void> open(
    BuildContext context, {
    required Future Function() onSubmit,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      backgroundColor: Palette.colorWhite,
      barrierColor: Palette.colorGrey900.withOpacity(0.2),
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: PhotoGuideBottomSheet(onSubmit: onSubmit),
      ),
    );
  }
}
