import 'dart:io';
import 'package:deepple_app/core/util/log.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionHandler with WidgetsBindingObserver {
  bool isReturningFromSettings = false;

  void init() {
    WidgetsBinding.instance.addObserver(this);
  }

  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && isReturningFromSettings) {
      isReturningFromSettings = false;
      // Re-check permission status when returning from settings
      checkPhotoPermissionStatus();
    } else if (state == AppLifecycleState.inactive) {
      isReturningFromSettings = true;
    }
  }

  Future<bool> checkPhotoPermissionStatus() async {
    try {
      final permission = Platform.isIOS
          ? Permission.photos
          : Permission.storage;
      final status = await permission.status;

      return await switch (status) {
        PermissionStatus.granted => () async {
          Log.d('request photo permission granted');
          return true;
        }(),
        PermissionStatus.denied => () async {
          Log.d('request photo permission denied. Requesting permission...');
          final newStatus = await permission.request();
          return newStatus.isGranted;
        }(),
        PermissionStatus.permanentlyDenied => () async {
          Log.d('request photo permission permanently denied. Opening app settings.');
          openAppSettings();
          return false;
        }(),
        _ => () async {
          return false;
        }(),
      };
    } catch (e) {
      Log.e('request photo permission failed: $e');
      return false;
    }
  }
}
