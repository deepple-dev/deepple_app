import 'dart:ui';

import 'package:deepple_app/app/constants/palette.dart';
import 'package:deepple_app/app/constants/enum.dart';
import 'package:deepple_app/app/provider/global_notifier.dart';
import 'package:deepple_app/app/router/route_arguments.dart';
import 'package:deepple_app/app/router/router.dart';
import 'package:deepple_app/app/router/routing.dart';
import 'package:deepple_app/core/notification/firebase_manager.dart';
import 'package:deepple_app/core/notification/notification_model.dart';
import 'package:deepple_app/core/provider/auth_expired_provider.dart';
import 'package:deepple_app/core/storage/local_storage.dart';
import 'package:deepple_app/core/util/log.dart';
import 'package:deepple_app/core/util/toast.dart';
import 'package:deepple_app/features/auth/data/usecase/auth_usecase_impl.dart';
import 'package:deepple_app/features/contact_setting/domain/provider/contact_setting_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class App extends ConsumerStatefulWidget {
  const App({super.key});

  @override
  ConsumerState<App> createState() => _AppState();

  static void preserveSplash({required WidgetsBinding widgetsBinding}) {
    FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  }
}

class _AppState extends ConsumerState<App> {
  @override
  void initState() {
    super.initState();
    _initialize();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<bool>(authExpiredProvider, (prev, next) async {
      if (!next) return;

      await ref.read(authUsecaseProvider).signOut(isTokenExpiredSignOut: true);

      final router = ref.read(routerProvider);
      router.goNamed(AppRoute.onboard.name);

      showToastMessage('장시간 미접속으로 인해 로그아웃 되었습니다.');

      ref.read(authExpiredProvider.notifier).reset();
    });

    return ScreenUtilInit(
      designSize: const Size(360, 800),
      minTextAdapt: true,
      child: ValueListenableBuilder(
        valueListenable: FirebaseManager().activeFcmNotification,
        builder: (context, value, child) {
          if (value != null) {
            _handleFcmNotification(value);
          }
          return child ?? Container();
        },
        child: MaterialApp.router(
          debugShowCheckedModeBanner: false,
          scrollBehavior: const MaterialScrollBehavior().copyWith(
            dragDevices: {
              PointerDeviceKind.mouse,
              PointerDeviceKind.touch,
              PointerDeviceKind.trackpad,
              PointerDeviceKind.stylus,
              PointerDeviceKind.unknown,
            },
          ),
          themeMode: ThemeMode.light,
          theme: createThemeData(Palette.lightScheme),
          darkTheme: createThemeData(Palette.darkScheme),
          routerConfig: ref.watch(routerProvider),
        ),
      ),
    );
  }

  Future<void> _initialize() async {
    await ref.read(localStorageProvider).initialize();
    await ref.read(globalProvider.notifier).initProfile();
    await ref.read(contactSettingProvider.notifier).initialize();

    _navigateToInitialRoute();
    FlutterNativeSplash.remove();
  }

  void _navigateToInitialRoute() {
    final router = ref.read(routerProvider);
    final profile = ref.read(globalProvider).profile;

    if (profile.isDefault) {
      router.goNamed(AppRoute.onboard.name);
      return;
    }

    final activityStatus = ActivityStatus.parse(profile.activityStatus);

    switch (activityStatus) {
      case ActivityStatus.waitingScreening:
        router.goNamed(AppRoute.signUpProfileReview.name);
        break;
      case ActivityStatus.rejectedScreening:
        router.goNamed(AppRoute.signUpProfileReject.name);
        break;
      case ActivityStatus.active:
        router.goNamed(AppRoute.mainTab.name);
        break;
      case null:
        router.goNamed(AppRoute.onboard.name);
        break;
      default:
        router.goNamed(AppRoute.onboard.name);
    }
  }

  void _handleFcmNotification(FcmNotification data) {
    final userId = data.senderId;
    if (!data.notificationType.isConnectedProfile) return;
    if (userId == null) {
      assert(
        false,
        'notification type [${data.notificationType}] need to senderId',
      );
      Log.e(
        'notification type [${data.notificationType}] requires senderId but was null',
      );
      return;
    }
    rootNavigatorKey.currentContext?.goNamed(
      AppRoute.profile.name,
      extra: ProfileDetailArguments(userId: userId),
    );
  }
}
