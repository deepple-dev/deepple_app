import 'dart:io';

import 'package:deepple_app/core/util/log.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/services.dart';

enum PhotoManagerPlatform { ios, android, other }

class PhotoManager {
  PhotoManager({
    ImagePicker? imagePicker,
    DeviceInfoPlugin? deviceInfo,
    PhotoManagerPlatform? platform,
    Future<int> Function()? androidSdkIntResolver,
    Future<PermissionStatus> Function(Permission permission)?
    permissionStatusReader,
    Future<PermissionStatus> Function(Permission permission)?
    permissionRequester,
    Future<bool> Function()? android14FullGalleryPermissionRequester,
  }) : _imagePicker = imagePicker ?? ImagePicker(),
       _deviceInfo = deviceInfo ?? DeviceInfoPlugin(),
       _platform = platform ?? _defaultPlatform,
       _androidSdkIntResolver = androidSdkIntResolver,
       _permissionStatusReader = permissionStatusReader,
       _permissionRequester = permissionRequester,
       _android14FullGalleryPermissionRequester =
           android14FullGalleryPermissionRequester;

  static const MethodChannel _photoPermissionChannel = MethodChannel(
    'com.goodmeet.deepple/photo_permission',
  );

  static PhotoManagerPlatform get _defaultPlatform {
    if (Platform.isIOS) return PhotoManagerPlatform.ios;
    if (Platform.isAndroid) return PhotoManagerPlatform.android;
    return PhotoManagerPlatform.other;
  }

  final ImagePicker _imagePicker;
  final DeviceInfoPlugin _deviceInfo;
  final PhotoManagerPlatform _platform;
  final Future<int> Function()? _androidSdkIntResolver;
  final Future<PermissionStatus> Function(Permission permission)?
  _permissionStatusReader;
  final Future<PermissionStatus> Function(Permission permission)?
  _permissionRequester;
  final Future<bool> Function()? _android14FullGalleryPermissionRequester;

  Future<XFile?> pickFromGallery() => _pickFromGallery();

  Future<bool> openGalleryPermissionSettings() => openAppSettings();

  Future<XFile?> _pickFromGallery() async {
    try {
      return await _imagePicker.pickImage(source: ImageSource.gallery);
    } catch (e) {
      Log.e('pick image failed: $e');
      return null;
    }
  }

  Future<bool> ensureFullGalleryPermission() async {
    final usesAndroid14Bridge = await _shouldUseAndroid14GalleryBridge();
    if (usesAndroid14Bridge) {
      final nativeResult = await _requestAndroid14FullGalleryPermission();
      if (nativeResult != null) return nativeResult;
    }

    return _ensureGalleryPermissionWithPermissionHandler();
  }

  Future<bool> _ensureGalleryPermissionWithPermissionHandler() async {
    final permission = await _galleryPermission();

    PermissionStatus status = await _readPermissionStatus(permission);
    if (_isFullGalleryGranted(status)) return true;
    if (_shouldShowSettingsDialog(status)) return false;

    status = await _requestPermission(permission);
    return _isFullGalleryGranted(status);
  }

  bool _isFullGalleryGranted(PermissionStatus status) {
    return status.isGranted;
  }

  bool _shouldShowSettingsDialog(PermissionStatus status) {
    return status.isLimited ||
        status.isPermanentlyDenied ||
        status.isRestricted;
  }

  Future<bool> _shouldUseAndroid14GalleryBridge() async {
    if (_platform != PhotoManagerPlatform.android) return false;
    return await _androidSdkInt() >= 34;
  }

  Future<bool?> _requestAndroid14FullGalleryPermission() async {
    try {
      if (_android14FullGalleryPermissionRequester != null) {
        return await _android14FullGalleryPermissionRequester();
      }

      return await _photoPermissionChannel.invokeMethod<bool>(
        'requestFullGalleryAccess',
      );
    } catch (e) {
      Log.e('request Android 14 photo permission failed: $e');
      return null;
    }
  }

  Future<int> _androidSdkInt() async {
    if (_androidSdkIntResolver != null) {
      return await _androidSdkIntResolver();
    }

    final info = await _deviceInfo.androidInfo;
    return info.version.sdkInt;
  }

  Future<PermissionStatus> _readPermissionStatus(Permission permission) async {
    if (_permissionStatusReader != null) {
      return await _permissionStatusReader(permission);
    }

    return permission.status;
  }

  Future<PermissionStatus> _requestPermission(Permission permission) async {
    if (_permissionRequester != null) {
      return await _permissionRequester(permission);
    }

    return permission.request();
  }

  Future<Permission> _galleryPermission() async {
    if (_platform == PhotoManagerPlatform.ios) return Permission.photos;

    if (_platform == PhotoManagerPlatform.android) {
      final sdkInt = await _androidSdkInt();
      // permission_handler guidance: <=32 storage, >=33 photos.
      if (sdkInt <= 32) return Permission.storage;
      return Permission.photos;
    }

    return Permission.photos;
  }
}
