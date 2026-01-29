import 'package:deepple_app/app/constants/constants.dart';
import 'package:deepple_app/features/home/home.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class UserByCategoryListItem extends ConsumerWidget {
  final bool isBlurred;
  final VoidCallback onTap;
  final IntroducedProfile profile;

  const UserByCategoryListItem({
    super.key,
    required this.isBlurred,
    required this.onTap,
    required this.profile,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 101,
        margin: const EdgeInsets.only(top: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Palette.gray10,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                SizedBox.square(
                  dimension: 54,
                  child: ClipOval(
                    child: CachedNetworkImage(
                      imageUrl: profile.profileImageUrl,
                      errorWidget: (context, url, error) =>
                          Container(color: Colors.black),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                if (isBlurred) const BlurCoverWidget(isRect: false),
              ],
            ),
            const Gap(16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${profile.nickname}, ${profile.age}',
                    style: Fonts.bold(
                      fontSize: 16,
                      color: Palette.colorBlack,
                      lineHeight: 1.0,
                    ),
                  ),
                  const Gap(2),
                  Text(
                    '${profile.mbti}・${profile.region}',
                    style: Fonts.body02Medium().copyWith(
                      color: Palette.colorGrey600,
                      height: 1.0,
                    ),
                  ),
                  const Spacer(),
                  HashtagWrap(tags: profile.hobbies),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
