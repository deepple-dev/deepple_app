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
      // 설정에서 돌아온 경우 권한 상태 재확인
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

      if (status.isGranted) {
        Log.d('권한 허용됨');
        return true;
      } else if (status.isDenied) {
        Log.d('권한 거부됨. 요청 시도 중...');
        final newStatus = await permission.request();
        return newStatus.isGranted;
      } else if (status.isPermanentlyDenied) {
        Log.d('권한 영구 거부됨. 설정 앱으로 이동.');
        openAppSettings();
        return false;
      }
      return false;
    } catch (e) {
      Log.e('권한 상태 확인 중 오류 발생: $e');
      return false;
    }
  }
}
