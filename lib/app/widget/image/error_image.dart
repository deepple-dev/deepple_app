import 'package:deepple_app/core/extension/extended_context.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:deepple_app/app/constants/constants.dart';
import 'package:deepple_app/app/widget/icon/default_icon.dart';

class ErrorImage extends ConsumerWidget {
  const ErrorImage({
    super.key,
    this.width,
    this.height,
    this.isRounded = false,
    this.borderRadius,
    this.image,
  });

  final double? width, height;
  final bool isRounded;
  final BorderRadiusGeometry? borderRadius;
  final String? image;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      height: height,
      width: width,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: context.palette.shadow,
        shape: isRounded ? BoxShape.circle : BoxShape.rectangle,
        borderRadius: borderRadius,
      ),
      child: DefaultIcon(
        image ?? IconPath.icImage,
        size: height ?? width ?? Dimens.iconSize,
        colorFilter: DefaultIcon.fillColor(context.colorScheme.primary),
      ),
    );
  }
}
