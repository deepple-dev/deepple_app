import 'dart:async';

import 'package:flutter/material.dart';

import 'package:deepple_app/core/state/base_widget_state.dart';
import 'package:deepple_app/app/constants/params.dart';

class DefaultOverlay extends StatefulWidget {
  const DefaultOverlay({
    super.key,
    this.controller,
    this.overlay,
    required this.child,
  });

  final DefaultOverlayController? controller;
  final Widget? overlay;
  final Widget child;

  @override
  State<DefaultOverlay> createState() => DefaultOverlayState();
}

class DefaultOverlayState<T extends DefaultOverlay>
    extends AppBaseWidgetState<T>
    with SingleTickerProviderStateMixin {
  OverlayEntry? _entry;
  DefaultOverlayController? _overlayController;
  late AnimationController animationController;

  DefaultOverlayController get overlayController =>
      widget.controller ?? (_overlayController ??= DefaultOverlayController());
  double get verticalOffset => 30.0;
  bool get preferBelow => false;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      duration: Params.animationDuration,
      reverseDuration: Params.animationDurationFast,
      vsync: this,
    );
    overlayController.addListener(handleStatusChanged);
  }

  @override
  void didUpdateWidget(covariant T oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller?.removeListener(handleStatusChanged);
      _overlayController?.removeListener(handleStatusChanged);
      overlayController.addListener(handleStatusChanged);
    }
  }

  @override
  void dispose() {
    overlayController.removeListener(handleStatusChanged);
    _entry?.remove();
    _entry?.dispose();
    _overlayController?.dispose();
    animationController.dispose();
    super.dispose();
  }

  void handleStatusChanged() {
    safeSetState(() {});

    switch (overlayController.value) {
      case DefaultOverlayStatus.showing:
        return _createEntry();
      case DefaultOverlayStatus.hidden:
        return _removeEntry();
    }
  }

  Widget buildOverlay(BuildContext context, Offset target, Widget? overlay) {
    return DefaultOverlayWidget(
      animation: CurvedAnimation(
        parent: animationController,
        curve: Params.animationCurve,
      ),
      target: target,
      verticalOffset: verticalOffset,
      preferBelow: preferBelow,
      child: overlay,
    );
  }

  void _createEntry() {
    if (!mounted || _entry != null) {
      return;
    }

    final OverlayState overlayState = Overlay.of(
      context,
      debugRequiredFor: widget,
    );

    final RenderBox box = context.findRenderObject()! as RenderBox;
    final Offset target = box.localToGlobal(
      box.size.center(Offset.zero),
      ancestor: overlayState.context.findRenderObject(),
    );

    _entry = OverlayEntry(
      builder: (BuildContext context) =>
          buildOverlay(context, target, widget.overlay),
    );
    overlayState.insert(_entry!);

    animationController.forward();
  }

  void _removeEntry() => animationController.reverse().whenComplete(() {
    _entry?.remove();
    _entry?.dispose();
    _entry = null;
  });

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

/* ------------ 컴포넌트 ------------ */

enum DefaultOverlayStatus {
  showing,
  hidden;

  bool get isShowing => this == DefaultOverlayStatus.showing;
  bool get isHidden => this == DefaultOverlayStatus.hidden;
}

class DefaultOverlayController extends ValueNotifier<DefaultOverlayStatus> {
  DefaultOverlayController({DefaultOverlayStatus? status})
    : super(status ?? DefaultOverlayStatus.hidden);

  DefaultOverlayStatus get status => value;

  void showOverlay() => value = DefaultOverlayStatus.showing;

  void hidenOverlay() => value = DefaultOverlayStatus.hidden;
}

class DefaultOverlayWidget extends StatelessWidget {
  const DefaultOverlayWidget({
    super.key,
    required this.animation,
    required this.target,
    required this.verticalOffset,
    required this.preferBelow,
    this.child,
  });

  final Animation<double> animation;
  final Offset target;
  final double verticalOffset;
  final bool preferBelow;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final Widget result = FadeTransition(opacity: animation, child: child);

    return Positioned.fill(
      bottom: MediaQuery.maybeViewInsetsOf(context)?.bottom ?? 0.0,
      child: CustomSingleChildLayout(
        delegate: DefaultOverlayPositionDelegate(
          target: target,
          verticalOffset: verticalOffset,
          preferBelow: preferBelow,
        ),
        child: Material(type: MaterialType.transparency, child: result),
      ),
    );
  }
}

/// Material Tooltip [_TooltipPositionDelegate] 복사
class DefaultOverlayPositionDelegate extends SingleChildLayoutDelegate {
  DefaultOverlayPositionDelegate({
    required this.target,
    required this.verticalOffset,
    required this.preferBelow,
  });

  /// 전역 좌표계에서 툴팁이 위치한 대상의 오프셋
  final Offset target;

  /// 대상과 표시된 툴팁 사이의 수직 거리
  final double verticalOffset;

  /// 기본적으로 툴팁이 위젯 아래에 표시되는지 여부
  ///
  /// 선호하는 방향에 툴팁을 표시할 공간이 충분하지 않은 경우,
  /// 툴팁은 반대 방향에 표시됩니다.
  final bool preferBelow;

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) =>
      constraints.loosen();

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    final double yOffset = target.dy + verticalOffset; // 아래쪽으로 이동
    return Offset(
      target.dx - (childSize.width / 2), // X축 가운데 정렬
      yOffset,
    );
  }

  @override
  bool shouldRelayout(DefaultOverlayPositionDelegate oldDelegate) {
    return target != oldDelegate.target ||
        verticalOffset != oldDelegate.verticalOffset ||
        preferBelow != oldDelegate.preferBelow;
  }
}

/* ------------ 확장 믹스인 ------------ */

mixin DefaultOverlayUseFocusNode<T extends DefaultOverlay>
    on DefaultOverlayState<T> {
  FocusNode? _focusNode;
  FocusNode get effectiveFocusNode => _focusNode ??= FocusNode();

  @override
  Widget build(BuildContext context) {
    return Focus(
      focusNode: effectiveFocusNode,
      onFocusChange: (value) {
        if (value) {
          ScrollNotificationObserver.maybeOf(
            context,
          )?.addListener(handleScrollChanged);
        } else {
          overlayController.hidenOverlay();
          ScrollNotificationObserver.maybeOf(
            context,
          )?.removeListener(handleScrollChanged);
        }
      },
      child: super.build(context),
    );
  }

  @override
  void handleStatusChanged() {
    if (overlayController.status.isShowing) {
      effectiveFocusNode.requestFocus();
    }
    super.handleStatusChanged();
  }

  void handleScrollChanged(ScrollNotification notification) {
    if (notification is ScrollStartNotification) {
      overlayController.hidenOverlay();
    }
  }
}

mixin DefaultOverlayUseTimer<T extends DefaultOverlay>
    on DefaultOverlayState<T> {
  Timer? _dismissTimer;

  Duration get timerDuration => const Duration(seconds: 3);

  @override
  void handleStatusChanged() {
    if (overlayController.status.isShowing) {
      _dismissTimer?.cancel();

      _dismissTimer = Timer(timerDuration, overlayController.hidenOverlay);
    }

    super.handleStatusChanged();
  }

  @override
  void dispose() {
    super.dispose();
    _dismissTimer?.cancel();
    _dismissTimer = null;
  }
}
