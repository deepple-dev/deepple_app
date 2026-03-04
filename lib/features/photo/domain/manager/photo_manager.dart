import 'dart:io';

import 'package:deepple_app/core/util/log.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class PhotoManager {
  PhotoManager({ImagePicker? imagePicker, DeviceInfoPlugin? deviceInfo})
    : _imagePicker = imagePicker ?? ImagePicker(),
      _deviceInfo = deviceInfo ?? DeviceInfoPlugin();

  final ImagePicker _imagePicker;
  final DeviceInfoPlugin _deviceInfo;

  Future<XFile?> pickFromGallery() => _pickFromGallery();

  Future<XFile?> _pickFromGallery() async {
    try {
      final hasPermission = await ensureFullGalleryPermission();
      if (!hasPermission) return null;

      return await _imagePicker.pickImage(source: ImageSource.gallery);
    } catch (e) {
      Log.e('pick image failed: $e');
      return null;
    }
  }

  Future<bool> ensureFullGalleryPermission() async {
    final permission = await _galleryPermission();

    PermissionStatus status = await permission.status;
    if (_isFullGalleryGranted(status)) return true;

    for (int attempt = 0; attempt < 2; attempt++) {
      if (status.isPermanentlyDenied || status.isRestricted) {
        await openAppSettings();
        return false;
      }

      status = await permission.request();
      if (_isFullGalleryGranted(status)) return true;
    }

    if (status.isDenied ||
        status.isLimited ||
        status.isPermanentlyDenied ||
        status.isRestricted) {
      await openAppSettings();
    }

    return false;
  }

  bool _isFullGalleryGranted(PermissionStatus status) {
    // Requirement: request full library access. iOS limited is treated as not enough.
    return status.isGranted;
  }

  Future<Permission> _galleryPermission() async {
    if (Platform.isIOS) return Permission.photos;

    if (Platform.isAndroid) {
      final info = await _deviceInfo.androidInfo;
      final sdkInt = info.version.sdkInt;
      // permission_handler guidance: <=32 storage, >=33 photos.
      if (sdkInt <= 32) return Permission.storage;
      return Permission.photos;
    }

    return Permission.photos;
  }
}
