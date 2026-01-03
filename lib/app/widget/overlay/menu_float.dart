import 'package:deepple_app/core/extension/extended_context.dart';
import 'package:flutter/material.dart';

import 'package:deepple_app/app/widget/overlay/default_overlay.dart';

class MenuFloat extends DefaultOverlay {
  const MenuFloat({
    super.key,
    super.controller,
    this.width = 300,
    this.margin,
    this.padding,
    this.clipBehavior = Clip.hardEdge,
    this.decoration,
    this.focusNode,
    required this.menuView,
    required super.child,
  });

  final double width;
  final EdgeInsetsGeometry? margin, padding;
  final Clip clipBehavior;
  final Decoration? decoration;
  final FocusNode? focusNode;
  final Widget menuView;

  @override
  State<MenuFloat> createState() => _MenuFloatState();
}

class _MenuFloatState extends DefaultOverlayState<MenuFloat>
    with DefaultOverlayUseFocusNode {
  @override
  FocusNode get effectiveFocusNode =>
      widget.focusNode ?? super.effectiveFocusNode;

  @override
  bool get preferBelow => true;

  @override
  Widget buildOverlay(BuildContext context, Offset target, Widget? overlay) {
    overlay = Container(
      width: widget.width,
      padding: widget.padding,
      margin: widget.margin,
      clipBehavior: widget.clipBehavior,
      decoration:
          widget.decoration ??
          BoxDecoration(
            color: context.palette.surface,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                offset: const Offset(0, 3),
                blurRadius: 20,
                color: context.palette.onSurface.withOpacity(0.102),
              ),
            ],
          ),
      child: widget.menuView,
    );

    return super.buildOverlay(context, target, overlay);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(onTap: toggleMenu, child: super.build(context));
  }

  void toggleMenu() {
    if (overlayController.status.isHidden) {
      overlayController.showOverlay();
    } else {
      overlayController.hidenOverlay();
    }
  }
}
