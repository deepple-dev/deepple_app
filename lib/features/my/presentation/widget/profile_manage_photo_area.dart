import 'package:deepple_app/app/constants/constants.dart';
import 'package:deepple_app/app/router/route_arguments.dart';
import 'package:deepple_app/app/router/router.dart';
import 'package:deepple_app/app/widget/widget.dart';
import 'package:deepple_app/features/photo/domain/model/profile_photo.dart';
import 'package:deepple_app/features/my/my.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';

class ProfileManagePhotoArea extends ConsumerWidget {
  const ProfileManagePhotoArea({super.key, required this.profileImages});

  final List<MyProfileImage> profileImages;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Gap(24),
          Text(
            '프로필 사진',
            style: Fonts.header03().copyWith(
              color: Palette.colorBlack,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Gap(16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: Dimens.profileImageMaxCount,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () async {
                  await navigate(
                    context,
                    route: AppRoute.myProfileImageUpdate,
                    extra: MyProfileImageUpdateArguments(
                      profileImages: _toEditableProfileImages(profileImages),
                    ),
                  );

                  ref.invalidate(profileManageProvider);
                },
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: const Color(0xffEDEEF0),
                        ),
                        child: index < profileImages.length
                            ? DefaultImage(
                                imageURL: profileImages[index].imageUrl,
                                fit: BoxFit.cover,
                              )
                            : null,
                      ),
                    ),
                    if (index == 0)
                      Positioned(
                        top: 8,
                        left: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Palette.colorPrimary600,
                            borderRadius: BorderRadius.circular(2),
                          ),
                          child: Text(
                            '대표',
                            style: Fonts.body03Regular().copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

List<ProfilePhoto> _toEditableProfileImages(
  List<MyProfileImage> profileImages,
) {
  return profileImages.map((image) {
    return ProfilePhoto(
      imageUrl: image.imageUrl,
      imageFile: XFile(image.imageUrl),
      isUpdated: false,
    );
  }).toList();
}
