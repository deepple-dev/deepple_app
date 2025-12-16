import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:deepple_app/core/extension/extended_context.dart';

/// `AppThemeMixin`은 기존 `ExtendedContext`을 활용해 간소화된 테마 및 다국어 설정 기능을 제공합니다.
mixin AppThemeStatefulMixin<T extends StatefulWidget> on State<T> {
  ColorScheme get colorScheme => context.colorScheme;
  ThemeData get appTheme => context.theme;
  TextTheme get textStyle => context.textStyle;
  bool get isDarkTheme => context.isDarkTheme;
  ColorScheme get palette => context.palette;
  // Palette get colors => context.colors;
  double get screenWidth => context.screenWidth;
  double get screenHeight => context.screenHeight;

  /// 상태 안전성을 보장하는 `setState`
  void safeSetState(VoidCallback fn) {
    if (mounted) {
      setState(fn);
    }
  }
}

mixin AppThemeConsumerStatefulMixin<T extends ConsumerStatefulWidget>
    on ConsumerState<T> {
  ColorScheme get colorScheme => context.colorScheme;
  ThemeData get appTheme => context.theme;
  TextTheme get textStyle => context.textStyle;
  bool get isDarkTheme => context.isDarkTheme;
  ColorScheme get palette => context.palette;
  // Palette get colors => context.colors;
  double get screenWidth => context.screenWidth;
  double get screenHeight => context.screenHeight;

  /// 상태 안전성을 보장하는 `setState`
  void safeSetState(VoidCallback fn) {
    if (mounted) {
      setState(fn);
    }
  }
}
