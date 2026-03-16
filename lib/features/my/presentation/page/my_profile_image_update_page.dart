import 'package:deepple_app/app/constants/constants.dart';
import 'package:deepple_app/app/router/router.dart';
import 'package:deepple_app/app/widget/button/default_elevated_button.dart';
import 'package:deepple_app/app/widget/dialogue/error_dialog.dart';
import 'package:deepple_app/app/widget/error/dialogue_error.dart';
import 'package:deepple_app/app/widget/image/profile_image_widget.dart';
import 'package:deepple_app/app/widget/overlay/tool_tip.dart';
import 'package:deepple_app/app/widget/text/bullet_text.dart';
import 'package:deepple_app/app/widget/view/default_app_bar.dart';
import 'package:deepple_app/core/extension/extended_context.dart';
import 'package:deepple_app/features/auth/presentation/widget/auth_photo_guide_widget.dart';
import 'package:deepple_app/features/photo/domain/model/profile_photo.dart';
import 'package:deepple_app/features/my/presentation/provider/profile_image_update_notifier.dart';
import 'package:deepple_app/features/photo/domain/manager/photo_manager.dart';
import 'package:deepple_app/features/photo/presentation/helper/gallery_photo_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

class MyProfileImageUpdatePage extends ConsumerStatefulWidget {
  final List<ProfilePhoto> profileImages;
  final PhotoManager photoManager;
  MyProfileImageUpdatePage({
    super.key,
    required this.profileImages,
    PhotoManager? photoManager,
  }) : photoManager = photoManager ?? PhotoManager();

  @override
  ConsumerState<MyProfileImageUpdatePage> createState() =>
      _MyProfileImageUpdatePageState();
}

class _MyProfileImageUpdatePageState
    extends ConsumerState<MyProfileImageUpdatePage> {
  @override
  Widget build(BuildContext context) {
    final imageUpdateState = ref.watch(
      profileImageUpdateProvider(widget.profileImages),
    );
    final imageUpdateNotifier = ref.read(
      profileImageUpdateProvider(widget.profileImages).notifier,
    );

    final photos = List<XFile?>.generate(
      Dimens.profileImageMaxCount,
      (index) => index < imageUpdateState.profileImages.length
          ? imageUpdateState.profileImages[index].imageFile
          : null,
    );

    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: Scaffold(
        appBar: const DefaultAppBar(title: '프로필 사진'),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 흰색 배경으로 처리되는 상단 영역
                  Container(
                    color: Palette.colorWhite, // 흰색 배경
                    child: Padding(
                      padding: EdgeInsets.all(
                        context.screenWidth * 0.05,
                      ), // 패딩 동적 설정
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
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
                                ).copyWith(height: 1.5),
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
                                  final pickedPhoto =
                                      await pickGalleryPhotoWithPermission(
                                        context: context,
                                        photoManager: widget.photoManager,
                                      );

                                  // 선택된 이미지가 있으면 UI 업데이트
                                  if (pickedPhoto != null) {
                                    final effectiveIndex =
                                        index <
                                            imageUpdateState
                                                .profileImages
                                                .length
                                        ? index
                                        : imageUpdateState.profileImages.length;

                                    // ProfilePhoto 업데이트
                                    await imageUpdateNotifier
                                        .updateEditableProfileImages(
                                          index: effectiveIndex,
                                          image: pickedPhoto,
                                        );
                                  }
                                },
                                // 사진 삭제
                                onRemoveImage: () {
                                  if (index >=
                                      imageUpdateState.profileImages.length) {
                                    return;
                                  }

                                  imageUpdateNotifier
                                      .deleteEditableProfileImage(index);
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
                  ),
                  // 회색 배경으로 처리되는 하단 영역
                  Container(
                    color: const Color(0xffF8F8F8),
                    child: Padding(
                      padding: EdgeInsets.all(context.screenWidth * 0.05),
                      child: const Column(
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
                ],
              ),
            ),
            Positioned(
              bottom: 26,
              left: 20,
              right: 20,
              child: DefaultElevatedButton(
                primary: imageUpdateNotifier.isSaveEnabled
                    ? Palette.colorPrimary500
                    : Palette.colorGrey200,
                onPressed: imageUpdateNotifier.isSaveEnabled
                    ? () async {
                        final isSuccess = await imageUpdateNotifier.save(
                          imageUpdateState.profileImages,
                        );

                        if (!context.mounted) return;

                        if (!isSuccess) {
                          ErrorDialog.open(
                            context,
                            error: DialogueErrorType.failUpdateProfileImages,
                            onConfirm: context.pop,
                          );
                          return;
                        }

                        pop(context);
                      }
                    : null,
                child: Text(
                  '저장',
                  style: Fonts.body01Medium(
                    imageUpdateNotifier.isSaveEnabled
                        ? context.palette.onPrimary
                        : Palette.colorGrey300,
                  ),
                ),
              ),
            ),
            if (imageUpdateState.isSaving)
              const Center(child: CircularProgressIndicator()),
          ],
        ),
      ),
    );
  }
}
