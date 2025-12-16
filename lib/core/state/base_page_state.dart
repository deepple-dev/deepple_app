import 'package:deepple_app/app/widget/view/default_app_bar.dart';
import 'package:deepple_app/app/widget/view/default_progress_indicator.dart';
import 'package:deepple_app/core/extension/extended_context.dart';
import 'package:deepple_app/core/mixin/theme_mixin.dart';
import 'package:deepple_app/core/provider/common_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Riverpod 기반 페이지 공통 동작 정의
/// buildPage 메서드는 페이지 레벨의 위젯에서만 사용하고, 일반 컴포넌트에서는 기본 build 메서드를 사용해야 합니다.
abstract class AppBaseConsumerStatefulPageState<
  T extends ConsumerStatefulWidget
>
    extends ConsumerState<T>
    with AppThemeConsumerStatefulMixin {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(commonProvider);

    return Stack(
      alignment: Alignment.center,
      children: [
        buildPage(context),
        if (state.isLoading) const DefaultCircularProgressIndicator(),
      ],
    );
  }

  /// 하위 클래스에서 구현해야 하는 페이지의 주요 UI 구성 메서드
  Widget buildPage(BuildContext context);
}

/// 자식 위젯에서 Scaffold를 사용하지 않아도 되는 버전
/// 일관성을 위해 화면 너비에 디폴트 패딩을 추가하는 버전
abstract class BaseConsumerStatefulPageState<T extends ConsumerStatefulWidget>
    extends ConsumerState<T>
    with AppThemeConsumerStatefulMixin {
  // 화면 너비 여백
  final bool isHorizontalMargin;
  final double? horizontalMargin;

  // 앱바
  final PreferredSizeWidget? appBar;
  final bool isAppBar;
  final String? defaultAppBarTitle;
  final Key? defaultAppBarKey;
  final List<Widget>? defaultAppBarActions;
  final PreferredSizeWidget? defaultAppBarBottom;
  final bool isDefaultAppBarDivider;
  final Widget? defaultAppBarLeadingIcon;
  final void Function(BuildContext context)? defaultAppBarLeadingAction;

  // 기타
  final bool isResizeToAvoidBottomInset;

  BaseConsumerStatefulPageState({
    // 화면 너비 여백
    this.isHorizontalMargin = true,
    this.horizontalMargin,

    // 앱바
    this.appBar,
    this.isAppBar = true,
    this.defaultAppBarTitle,
    this.defaultAppBarActions,
    this.defaultAppBarBottom,
    this.defaultAppBarKey,
    this.isDefaultAppBarDivider = false,
    this.defaultAppBarLeadingIcon,
    this.defaultAppBarLeadingAction,
    // 기타
    this.isResizeToAvoidBottomInset = true,
  });

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(commonProvider);

    return Stack(
      alignment: Alignment.center,
      children: [
        Scaffold(
          extendBodyBehindAppBar: false, // AppBar와 Body를 명확히 분리
          resizeToAvoidBottomInset:
              isResizeToAvoidBottomInset, // 키보드로 인한 레이아웃 변경 허용
          appBar: isAppBar
              ? (appBar ??
                    DefaultAppBar(
                      key: defaultAppBarKey,
                      title: defaultAppBarTitle,
                      actions: defaultAppBarActions,
                      bottom: defaultAppBarBottom,
                      isDivider: isDefaultAppBarDivider,
                      leading: defaultAppBarLeadingIcon,
                      leadingAction: defaultAppBarLeadingAction,
                    ))
              : null,
          body: Padding(
            padding: isHorizontalMargin
                ? EdgeInsets.symmetric(
                    horizontal: horizontalMargin ?? context.screenWidth * 0.05,
                  )
                : EdgeInsets.zero,
            child: buildPage(context),
          ),
        ),
        if (state.isLoading) const DefaultCircularProgressIndicator(),
      ],
    );
  }

  /// 하위 클래스에서 구현해야 하는 페이지의 주요 UI 구성 메서드
  Widget buildPage(BuildContext context);
}

/// buildPage 메서드는 페이지 레벨의 위젯에서만 사용하고, 일반 컴포넌트에서는 기본 build 메서드를 사용해야 합니다.
abstract class AppBaseStatefulPageBase<T extends StatefulWidget>
    extends State<T>
    with AppThemeStatefulMixin {
  @override
  Widget build(BuildContext context) {
    return buildPage(context);
  }

  Widget buildPage(BuildContext context);
}
