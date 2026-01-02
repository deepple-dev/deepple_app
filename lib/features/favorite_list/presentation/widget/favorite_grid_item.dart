import 'dart:ui';

import 'package:deepple_app/app/constants/constants.dart';
import 'package:deepple_app/app/widget/icon/default_icon.dart';
import 'package:deepple_app/app/widget/image/default_image.dart';
import 'package:deepple_app/core/extension/extended_context.dart';
import 'package:deepple_app/features/favorite_list/domain/provider/domain.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class FavoriteGridItem extends StatelessWidget {
  const FavoriteGridItem({
    super.key,
    required this.profile,
    required this.isBlurred,
    required this.onProfileTab,
    required this.onBlurTap,
  });

  final FavoriteUserSummary profile;
  final bool isBlurred;
  final VoidCallback onProfileTab;
  final VoidCallback onBlurTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ClipRRect(
          borderRadius: _imageRadius,
          child: GestureDetector(
            onTap: isBlurred ? onBlurTap : onProfileTab,
            child: isBlurred
                ? ImageFiltered(
                    imageFilter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                    child: _ProfileImageContainer(profile: profile),
                  )
                : _ProfileImageContainer(profile: profile),
          ),
        ),
        const Gap(8.0),
        if (profile.name.isNotEmpty)
          Text(
            profile.name,
            style: Fonts.body02Medium(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        const Gap(4.0),
        Text(
          [
            if (profile.city.isNotEmpty) profile.city,
            if (profile.age > 0) profile.age,
          ].join(', '),
          style: Fonts.body03Regular(context.colorScheme.secondary),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

class _ProfileImageContainer extends StatelessWidget {
  const _ProfileImageContainer({required this.profile});

  final FavoriteUserSummary profile;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: _profileImageSize,
      child: DefaultImage(
        imageURL: profile.profileUrl,
        width: _profileImageSize,
        borderRadius: _imageRadius,
        fit: BoxFit.cover,
      ),
    );
  }

  static const _profileImageSize = 104.0;
}

const _imageRadius = BorderRadius.all(Radius.circular(8));
