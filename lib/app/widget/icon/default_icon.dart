import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:deepple_app/app/constants/constants.dart';
import 'package:deepple_app/core/util/string_util.dart';
import 'package:deepple_app/app/widget/view/default_progress_indicator.dart';

class DefaultIcon extends ConsumerWidget {
  const DefaultIcon(
    this.icon, {
    this.padding = EdgeInsets.zero,
    this.size = Dimens.iconSize,
    this.colorFilter,
    this.alignment = Alignment.center,
    this.fit = BoxFit.cover,
    super.key,
  }) : onPressed = null;

  const DefaultIcon.button(
    this.icon, {
    required this.onPressed,
    this.padding = EdgeInsets.zero,
    this.size = Dimens.iconSize,
    this.colorFilter,
    this.alignment = Alignment.center,
    this.fit = BoxFit.cover,
    super.key,
  });

  final String? icon;
  final double size;
  final BoxFit fit;
  final ColorFilter? colorFilter;
  final AlignmentGeometry alignment;
  final VoidCallback? onPressed;
  final EdgeInsetsGeometry padding;

  static ColorFilter fillColor(Color color) =>
      ColorFilter.mode(color, BlendMode.srcIn);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (icon?.isEmpty ?? true) {
      return SizedBox.square(
        dimension: size,
        child: const DefaultCircularProgressIndicator(),
      );
    }

    Widget? result;

    if (StringUtil.isURL(icon!)) {
      result = SvgPicture.network(
        icon!,
        width: size,
        height: size,
        alignment: alignment,
        fit: fit,
        colorFilter: colorFilter,
      );
    }

    result ??= SvgPicture.asset(
      icon!,
      width: size,
      height: size,
      alignment: alignment,
      fit: fit,
      colorFilter: colorFilter,
    );

    if (onPressed != null) {
      result = IconButton(
        alignment: alignment,
        padding: padding,
        onPressed: onPressed,
        icon: result,
      );
    } else {
      result = Padding(padding: padding, child: result);
    }

    result = SizedBox(
      width: size + padding.horizontal,
      height: size + padding.vertical,
      child: result,
    );

    return result;
  }
}
