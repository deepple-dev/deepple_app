import 'package:deepple_app/app/provider/provider.dart';
import 'package:deepple_app/core/util/toast.dart';
import 'package:deepple_app/core/util/util.dart';
import 'package:deepple_app/features/auth/data/usecase/auth_usecase_impl.dart';
import 'package:deepple_app/features/my/data/repository/my_profile_repository.dart';
import 'package:deepple_app/features/notification/data/repository/notification_repository.dart';
import 'package:deepple_app/features/notification/domain/model/server_notification_type.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:deepple_app/features/my/presentation/provider/my_settings.dart';

part 'my_setting_notifier.g.dart';

@Riverpod()
class MySettingNotifier extends _$MySettingNotifier {
  @override
  Future<MySettings> build() async {
    final appVersion = await _fetchAppVersion();
    final enabledServerTypes = await ref
        .read(notificationRepositoryProvider)
        .loadEnableNotificationTypes();
    final enabledNotifications = _convertToUserNotificationTypes(
      enabledServerTypes,
    );
    final notificationEnabled = await ref
        .read(notificationRepositoryProvider)
        .notificationEnabled;

    return MySettings(
      version: appVersion,
      enabledNotifications: enabledNotifications,
      notificationEnabled: notificationEnabled,
    );
  }

  Future<String> _fetchAppVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;
  }

  /// ServerNotificationType을 UserNotificationType으로 변환
  Set<UserNotificationType> _convertToUserNotificationTypes(
    List<ServerNotificationType> enabledServerTypes,
  ) {
    final enabledUserTypes = <UserNotificationType>{};

    for (final serverType in enabledServerTypes) {
      final userType = serverType.toUserType();
      if (userType != null) {
        enabledUserTypes.add(userType);
      }
    }

    return enabledUserTypes;
  }

  /// UserNotificationType을 ServerNotificationType으로 변환
  List<ServerNotificationType> _convertToServerNotificationTypes(
    Set<UserNotificationType> userTypes,
  ) {
    final enabledServerTypes = <ServerNotificationType>[];

    // 활성화된 사용자 타입을 서버 타입으로 변환
    for (final userType in userTypes) {
      final serverTypes = userType.toServerTypes();
      enabledServerTypes.addAll(serverTypes);
    }

    return enabledServerTypes;
  }

  Future<void> toggleNotification(UserNotificationType type) async {
    if (!state.hasValue) return;

    final value = state.requireValue;
    final nextEnabledNotifications = {...value.enabledNotifications}
      ..toggle(type);

    // UserNotificationType을 ServerNotificationType으로 변환
    final enabledServerTypes = _convertToServerNotificationTypes(
      nextEnabledNotifications,
    );

    // 서버에 저장
    try {
      await ref
          .read(notificationRepositoryProvider)
          .saveEnableNotificationTypes(enabledServerTypes);

      // 상태 업데이트
      state = AsyncValue.data(
        value.copyWith(enabledNotifications: nextEnabledNotifications),
      );
    } catch (e) {
      showToastMessage('알림 설정에 실패하였습니다.');
    }
  }

  Future<void> tryToggleNotificationEnableStatus() async {
    if (!state.hasValue) return;

    final nextNotificationEnabled = !state.requireValue.notificationEnabled;
    final success = await ref
        .read(notificationRepositoryProvider)
        .requestNotificationAllowStatusUpdate(nextNotificationEnabled);

    if (!success) {
      Log.e('알림 허용 상태 변경 실패');
      showToastMessage('앱 설정에서 푸시 알림을 허용해주세요.', gravity: ToastGravity.BOTTOM);
      await Future.delayed(const Duration(milliseconds: 1000), openAppSettings);
      return;
    }

    state = AsyncValue.data(
      state.requireValue.copyWith(
        notificationEnabled: nextNotificationEnabled,
        enabledNotifications: nextNotificationEnabled
            ? UserNotificationType.values.toSet()
            : <UserNotificationType>{},
      ),
    );
  }

  Future<bool> withdrawAccount() async {
    return await ref.read(myProfileRepositoryProvider).withdrawAccount();
  }

  Future<bool> deactiveAccount() async {
    return await ref.read(myProfileRepositoryProvider).deactiveAccount();
  }

  Future<bool> activeAccount() async {
    try {
      final phoneNumber = ref.read(globalProvider).profile.phoneNumber;

      final accessToken = await ref
          .read(myProfileRepositoryProvider)
          .activeAccount(phoneNumber);

      if (accessToken == null) {
        Log.e('계정 활성화 실패: accessToken is null');
        return false;
      }

      ref.read(authUsecaseProvider).setAccessToken(accessToken);
      await ref.read(globalProvider.notifier).initProfile();
      return true;
    } catch (e) {
      Log.e('계정 활성화 실패: $e');
      return false;
    }
  }

  Future<bool> signOut() async {
    try {
      final signOutCompleted = await ref.read(authUsecaseProvider).signOut();

      if (!signOutCompleted) {
        return false;
      }

      return true;
    } catch (e) {
      Log.e('로그아웃 실패: $e');
      return false;
    }
  }
}
