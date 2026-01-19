import 'package:deepple_app/app/constants/constants.dart';
import 'package:deepple_app/app/widget/view/default_progress_indicator.dart';
import 'package:deepple_app/core/extension/extended_context.dart';
import 'package:flutter/material.dart';

class DefaultOutlinedButton extends StatelessWidget {
  const DefaultOutlinedButton({
    super.key,
    required this.child,
    required this.onPressed,
    this.onLongPress,
    this.onHover,
    this.onFocusChange,
    this.padding = Dimens.buttonPadding,
    this.primary,
    this.backgroundColor,
    this.expandedWidth = false,
    this.isLoading = false,
    this.alignment,
    this.height = Dimens.buttonHeight,
    this.width = 0.0,
    this.borderRadius = Dimens.buttonRadius,
    this.borderWidth = 1.0,
    this.textStyle,
    this.textColor,
  });

  final Widget child;
  final Color? primary;
  final Color? textColor;
  final Color? backgroundColor;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onPressed;
  final VoidCallback? onLongPress;
  final ValueChanged<bool>? onHover;
  final ValueChanged<bool>? onFocusChange;
  final bool expandedWidth;
  final AlignmentGeometry? alignment;
  final bool isLoading;
  final double height;
  final double width;
  final BorderRadiusGeometry borderRadius;
  final double borderWidth;
  final TextStyle? textStyle;
  bool get isDisabled => onPressed == null;

  @override
  Widget build(BuildContext context) {
    final foregroundColor = primary ?? context.palette.primary;
    final resolvedTextColor = textColor ?? foregroundColor;
    final disabledForegroundColor = resolvedTextColor.withValues(alpha: .4);

    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: resolvedTextColor,
        disabledForegroundColor: disabledForegroundColor,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        padding: padding,
        side: BorderSide(
          color: isDisabled ? disabledForegroundColor : foregroundColor,
          width: borderWidth,
        ),
        shape: RoundedRectangleBorder(borderRadius: borderRadius),
        textStyle: textStyle ?? Fonts.body01Medium(),
        minimumSize: Size(expandedWidth ? double.infinity : width, height),
        alignment: alignment,
      ),
      onPressed: isLoading ? null : onPressed,
      onLongPress: isLoading ? null : onLongPress,
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
