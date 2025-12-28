import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:deepple_app/app/constants/constants.dart';
import 'package:deepple_app/core/util/string_util.dart';
import 'package:deepple_app/app/widget/view/default_progress_indicator.dart';
import 'package:deepple_app/app/widget/image/error_image.dart';

class RoundedImage extends ConsumerWidget {
  const RoundedImage({
    super.key,
    this.size = Dimens.imageSize,
    this.imageURL,
    this.border,
    this.errorImage,
  });

  final double size;
  final String? imageURL;
  final BoxBorder? border;
  final String? errorImage;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (imageURL == null || !StringUtil.isURL(imageURL!)) {
      return ErrorImage(
        width: size,
        height: size,
        isRounded: true,
        image: errorImage,
      );
    }

    return CachedNetworkImage(
      width: size,
      height: size,
      imageUrl: imageURL!,
      fit: BoxFit.cover,
      imageBuilder:
          (BuildContext context, ImageProvider<Object> imageProvider) {
            return Container(
              decoration: BoxDecoration(border: border, shape: BoxShape.circle),
              child: CircleAvatar(backgroundImage: imageProvider),
            );
          },
      progressIndicatorBuilder: (_, __, DownloadProgress progress) =>
          DefaultCircularProgressIndicator(progress: progress.progress),
      errorWidget: (_, __, ___) =>
          ErrorImage(width: size, height: size, isRounded: true),
    );
  }
}
