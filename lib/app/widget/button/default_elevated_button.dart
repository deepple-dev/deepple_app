import 'package:deepple_app/core/extension/extended_context.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:deepple_app/app/constants/constants.dart';
import 'package:deepple_app/app/widget/view/default_progress_indicator.dart';

class DefaultElevatedButton extends ConsumerWidget {
  const DefaultElevatedButton({
    super.key,
    required this.child,
    required this.onPressed,
    this.onLongPress,
    this.onHover,
    this.onFocusChange,
    this.padding = Dimens.buttonPadding,
    this.primary,
    this.onPrimary,
    this.expandedWidth = true,
    this.isLoading = false,
    this.alignment,
    this.height = Dimens.buttonHeight,
    this.width = 150,
    this.borderRadius = Dimens.buttonRadius,
    this.border,
    this.textStyle,
  });

  final TextStyle? textStyle;
  final Widget? child;
  final Color? primary;
  final Color? onPrimary;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onPressed;
  final VoidCallback? onLongPress;
  final ValueChanged<bool>? onHover;
  final ValueChanged<bool>? onFocusChange;
  final bool expandedWidth;
  final AlignmentGeometry? alignment;
  final double height;
  final double width;
  final bool isLoading;
  final BorderRadiusGeometry borderRadius;
  final BorderSide? border; // 윤곽선 커스텀 속성

  bool get isDisable => onPressed == null;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Color foregroundColor = onPrimary ?? context.palette.onPrimary;
    final Color backgroundColor = primary ?? context.palette.primary;
    final Color disabledForegroundColor = onPrimary ?? Palette.colorGrey300;
    final Color disabledBackgroundColor = primary ?? Palette.colorGrey200;

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        foregroundColor: foregroundColor,
        backgroundColor: backgroundColor,
        disabledForegroundColor: disabledForegroundColor,
        disabledBackgroundColor: disabledBackgroundColor,
        elevation: 0,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        padding: padding,
        shape: RoundedRectangleBorder(
          borderRadius: borderRadius,
          side: border ?? BorderSide.none, // 커스텀 윤곽선 사용
        ),
        textStyle: textStyle ?? Fonts.body01Medium(),
        minimumSize: Size(expandedWidth ? double.infinity : width, height),
        alignment: alignment,
      ),
      onPressed: isLoading ? () {} : onPressed,
      onLongPress: isLoading ? () {} : onLongPress,
      onHover: onHover,
      onFocusChange: onFocusChange,
      child: AnimatedSize(
        duration: Params.animationDurationFast,
        curve: Curves.fastOutSlowIn,
        child: isLoading
            ? SizedBox(
                height: height - padding.vertical,
                child: FittedBox(
                  child: DefaultCircularProgressIndicator(
                    color: foregroundColor,
                  ),
                ),
              )
            : child,
      ),
    );
  }
}
