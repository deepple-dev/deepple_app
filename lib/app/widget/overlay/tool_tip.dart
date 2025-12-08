import 'package:deepple_app/app/widget/icon/default_icon.dart';
import 'package:deepple_app/app/widget/overlay/bubble.dart';
import 'package:flutter/material.dart';

import 'package:deepple_app/app/constants/constants.dart';
import 'package:deepple_app/app/widget/overlay/default_overlay.dart';

class ToolTip extends DefaultOverlay {
  ToolTip({
    this.fillColor = Palette.colorGrey400,
    super.key,
    this.autoClose = true,
    super.controller,
    required this.message,
    this.boldText,
    this.textStyle,
    Widget? child,
  }) : super(
         child:
             child ??
             DefaultIcon(
               IconPath.help,
               colorFilter: ColorFilter.mode(fillColor, BlendMode.srcIn),
               size: 20,
             ),
       );

  final bool autoClose;
  final String message;
  final Color fillColor;
  final String? boldText;
  final TextStyle? textStyle;

  @override
  State<ToolTip> createState() => _ToolTipState();
}

class _ToolTipState extends DefaultOverlayState<ToolTip>
    with DefaultOverlayUseTimer {
  @override
  @override
  double get verticalOffset => 20; // 아래로 표시되도록 설정

  @override
  Widget buildOverlay(BuildContext context, Offset target, Widget? overlay) {
    overlay = bubbleWidget(
      comment: widget.message,
      boldText: widget.boldText,
      trianglePosition: BubblePosition.top, // 삼각형이 위로 향하도록 수정
      textColor: Palette.colorWhite,
      bubbleColor: Palette.colorBlack.withAlpha(180),
      isShadow: false,
      textStyle: widget.textStyle,
    );

    return super.buildOverlay(context, target, overlay);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: overlayController.showOverlay,
      child: super.build(context),
    );
  }
}
