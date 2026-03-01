import 'dart:io';

import 'package:deepple_app/core/util/log.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';

/// Explicit permission helper.
///
/// - Does NOT observe app lifecycle.
/// - Only requests permissions when the caller explicitly invokes a method.
class PermissionHandler {
  PermissionHandler({DeviceInfoPlugin? deviceInfo})
    : _deviceInfo = deviceInfo ?? DeviceInfoPlugin();

  final DeviceInfoPlugin _deviceInfo;

  /// Requests gallery permission and returns whether it is fully granted.
  ///
  /// Android: API 33+ uses [Permission.photos], <=32 uses [Permission.storage].
  /// iOS: uses [Permission.photos].
  ///
  /// Note: iOS `limited` is treated as NOT fully granted.
  Future<bool> requestFullGalleryPermission() async {
    try {
      final permission = await _galleryPermission();
      final status = await _requestPermission(permission);
      return status.isGranted;
    } catch (e) {
      Log.e('request gallery permission failed: $e');
      return false;
    }
  }

  Future<bool> requestCameraPermission() async {
    try {
      final status = await _requestPermission(Permission.camera);
      return status.isGranted;
    } catch (e) {
      Log.e('request camera permission failed: $e');
      return false;
    }
  }

  Future<PermissionStatus> _requestPermission(Permission permission) async {
    PermissionStatus status = await permission.status;

    if (status.isGranted) return status;

    if (status.isPermanentlyDenied || status.isRestricted) {
      await openAppSettings();
      return status;
    }

    // Denied / limited: request once.
    status = await permission.request();

    if (status.isPermanentlyDenied || status.isRestricted) {
      await openAppSettings();
    }

    return status;
  }

  Future<Permission> _galleryPermission() async {
    if (Platform.isIOS) return Permission.photos;

    if (Platform.isAndroid) {
      final info = await _deviceInfo.androidInfo;
      final sdkInt = info.version.sdkInt;
      if (sdkInt <= 32) return Permission.storage;
      return Permission.photos;
    }

    return Permission.photos;
  }
}
