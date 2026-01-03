import 'package:deepple_app/app/constants/constants.dart';
import 'package:deepple_app/app/router/router.dart';
import 'package:deepple_app/app/widget/button/default_elevated_button.dart';
import 'package:deepple_app/app/widget/image/profile_image_widget.dart';
import 'package:deepple_app/app/widget/overlay/tool_tip.dart';
import 'package:deepple_app/app/widget/text/bullet_text.dart';
import 'package:deepple_app/core/extension/extended_context.dart';
import 'package:deepple_app/core/state/base_page_state.dart';
import 'package:deepple_app/features/auth/presentation/widget/auth_step_indicator_widget.dart';
import 'package:deepple_app/features/auth/presentation/widget/photo_guide_bottomsheet.dart';
import 'package:deepple_app/features/photo/domain/provider/photo_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

class SignUpProfilePicturePage extends ConsumerStatefulWidget {
  const SignUpProfilePicturePage({super.key});

  @override
  SignUpProfilePicturePageState createState() =>
      SignUpProfilePicturePageState();
}

class SignUpProfilePicturePageState
    extends BaseConsumerStatefulPageState<SignUpProfilePicturePage> {
  SignUpProfilePicturePageState() : super(defaultAppBarTitle: '프로필 사진');

  @override
  Widget buildPage(BuildContext context) {
    final List<XFile?> photos = ref.watch(photoProvider);
    final bool isPrimaryPhotoSelected = photos.firstOrNull != null;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 흰색 배경으로 처리되는 상단 영역
                  Container(
                    color: Palette.colorWhite, // 흰색 배경
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const AuthStepIndicatorWidget(
                          totalSteps: 4,
                          currentStep: 3,
                        ),
                        Gap(12.h),
                        Row(
                          children: [
                            Text(
                              '프로필 사진을 등록해주세요',
                              style: Fonts.header03().copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Gap(6),
                            ToolTip(
                              message: '대표 사진은 하단과 같이\n정면사진을 등록해주세요',
                              boldText: '정면사진',
                              textStyle: Fonts.body03Regular(
                                Palette.colorWhite,
                              ),
                            ),
                          ],
                        ),
                        const Gap(24),
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                crossAxisSpacing: 8,
                                mainAxisSpacing: 8,
                              ),
                          itemCount: photos.length,
                          itemBuilder: (context, index) {
                            return ProfileImageWidget(
                              imageFile: photos[index],
                              onPickImage: () async {
                                PhotoGuideBottomSheet.open(
                                  context,
                                  onSubmit: () async {
                                    context.pop();

                                    final pickedPhoto = await ref
                                        .read(photoProvider.notifier)
                                        .pickPhoto(ImageSource.gallery);

                                    if (pickedPhoto != null) {
                                      ref
                                          .read(photoProvider.notifier)
                                          .updateState(index, pickedPhoto);
                                    }
                                  },
                                );
                              },
                              // 사진 삭제
                              onRemoveImage: () {
                                ref
                                    .read(photoProvider.notifier)
                                    .updateState(index, null);
                              },
                              isRepresentative: index == 0,
                            );
                          },
                        ),
                        BulletText(
                          texts: [
                            '본인의 장점을 어필할 수 있는 가장 멋진 사진으로 올려주세요',
                            '아래의 가이드를 참고하시면 매칭 확률이 올라가요',
                          ],
                          textStyle: Fonts.body03Regular(
                            const Color.fromRGBO(155, 160, 171, 1),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: screenHeight * 0.05),
              child: DefaultElevatedButton(
                onPressed: isPrimaryPhotoSelected
                    ? () async {
                        navigate(context, route: AppRoute.signUpTerms);
                      }
                    : null,
                child: Text(
                  '다음',
                  style: Fonts.body01Medium(
                    isPrimaryPhotoSelected
                        ? context.palette.onPrimary
                        : Palette.colorGrey400,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
