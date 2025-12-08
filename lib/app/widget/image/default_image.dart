import 'dart:io';
import 'dart:typed_data';

import 'package:deepple_app/core/extension/extended_context.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:deepple_app/core/util/string_util.dart';
import 'package:deepple_app/app/constants/constants.dart';
import 'package:deepple_app/app/widget/view/default_progress_indicator.dart';
import 'package:deepple_app/app/widget/image/error_image.dart';

class DefaultImage extends ConsumerWidget {
  const DefaultImage({
    super.key,
    this.imageURL,
    this.width = Dimens.imageWidth,
    this.height = Dimens.imageHeight,
    this.fit = BoxFit.cover,
    this.borderRadius = Dimens.imageRadius,
    this.color,
  });

  const DefaultImage.square({
    super.key,
    this.imageURL,
    double? size = Dimens.imageSize,
    this.fit = BoxFit.cover,
    this.borderRadius = Dimens.imageRadius,
    this.color,
  }) : width = size,
       height = size;

  final String? imageURL;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadiusGeometry borderRadius;
  final Color? color;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (imageURL == null || !StringUtil.isURL(imageURL!)) {
      return ErrorImage(
        width: width,
        height: height,
        borderRadius: borderRadius,
      );
    }

    return ClipRRect(
      borderRadius: borderRadius,
      child: ColoredBox(
        color: context.palette.shadow,
        child: CachedNetworkImage(
          imageUrl: imageURL!,
          width: width,
          height: height,
          fit: fit,
          progressIndicatorBuilder: (_, __, DownloadProgress progress) =>
              DefaultCircularProgressIndicator(progress: progress.progress),
          errorWidget: (_, __, ___) => ErrorImage(
            width: width,
            height: height,
            borderRadius: borderRadius,
          ),
        ),
      ),
    );
  }

  static Widget file(
    String? imagePath, {
    double? width = Dimens.imageWidth,
    double? height = Dimens.imageHeight,
    BoxFit? fit = BoxFit.cover,
    Color? color,
    BorderRadiusGeometry borderRadius = Dimens.imageRadius,
  }) {
    if (imagePath == null || imagePath.isEmpty) {
      return ErrorImage(
        width: width,
        height: height,
        borderRadius: borderRadius,
      );
    }

    return ClipRRect(
      borderRadius: borderRadius,
      child: Image.file(
        File(imagePath),
        fit: fit,
        width: width,
        height: height,
      ),
    );
  }

  static Widget asset(
    String? imageName, {
    double? width = Dimens.imageWidth,
    double? height = Dimens.imageHeight,
    BoxFit? fit = BoxFit.cover,
    BorderRadiusGeometry borderRadius = Dimens.imageRadius,
    Color? color,
  }) {
    const BorderRadius.all(Radius.circular(12));
    if (imageName == null || imageName.isEmpty) {
      return ErrorImage(
        width: width,
        height: height,
        borderRadius: borderRadius,
      );
    }

    return ClipRRect(
      borderRadius: borderRadius,
      child: Image.asset(
        imageName,
        fit: fit,
        width: width,
        height: height,
        color: color,
      ),
    );
  }

  static Widget memory(
    Uint8List? bytes, {
    double? width = Dimens.imageWidth,
    double? height = Dimens.imageHeight,
    BoxFit? fit = BoxFit.cover,
    BorderRadiusGeometry borderRadius = Dimens.imageRadius,
    Color? color,
  }) {
    const BorderRadius.all(Radius.circular(12));
    if (bytes == null || bytes.isEmpty) {
      return ErrorImage(
        width: width,
        height: height,
        borderRadius: borderRadius,
      );
    }

    return ClipRRect(
      borderRadius: borderRadius,
      child: Image.memory(
        bytes,
        fit: fit,
        width: width,
        height: height,
        color: color,
      ),
    );
  }
}
