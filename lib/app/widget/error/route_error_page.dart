import 'package:deepple_app/app/router/router.dart';
import 'package:deepple_app/app/widget/button/default_text_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// This page shows when [Navigation] router non-existent page
class RouteErrorPage extends ConsumerWidget {
  const RouteErrorPage(this.state, {super.key});

  final GoRouterState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Page not found')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              state.error?.toString() ?? state.uri.toString(),
              textAlign: TextAlign.center,
            ),
            DefaultTextButton(
              expandedWidth: false,
              onPressed: () => goToHome(context), // goToHome 함수 호출
              child: const Text('메인으로'),
            ),
          ],
        ),
      ),
    );
  }

  /// 홈 화면으로 이동
  void goToHome(BuildContext context) {
    navigate(context, route: AppRoute.mainTab, method: NavigationMethod.go);
  }
}
