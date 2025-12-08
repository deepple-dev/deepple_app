import 'package:deepple_app/core/extension/extended_context.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:deepple_app/app/constants/constants.dart';
import 'package:deepple_app/app/widget/view/default_progress_indicator.dart';

class DefaultTextButton extends ConsumerWidget {
  const DefaultTextButton({
    super.key,
    required this.child,
    required this.onPressed,
    this.onLongPress,
    this.onHover,
    this.onFocusChange,
    this.padding = Dimens.buttonPadding,
    this.primary,
    this.expandedWidth = false,
    this.isLoading = false,
    this.alignment,
    this.height = Dimens.buttonHeight,
    this.width = 0.0,
    this.borderRadius = Dimens.buttonRadius,
  });

  final Widget child;

  final Color? primary;

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

  bool get isDisable => onPressed == null;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Color foregroundColor = primary ?? context.colorScheme.primary;
    final Color? disabledForegroundColor = primary?.withOpacity(0.2);

    return TextButton(
      style: TextButton.styleFrom(
        foregroundColor: foregroundColor,
        disabledForegroundColor: disabledForegroundColor,
        elevation: 0,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        padding: padding,
        shape: RoundedRectangleBorder(borderRadius: borderRadius),
        textStyle: Fonts.body01Medium(),
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
