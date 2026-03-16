import 'package:deepple_app/features/photo/domain/manager/photo_manager.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  group('PhotoManager.ensureFullGalleryPermission', () {
    test('iOS limited access is treated as not enough', () async {
      var requestCallCount = 0;

      final manager = PhotoManager(
        platform: PhotoManagerPlatform.ios,
        permissionStatusReader: (_) async => PermissionStatus.limited,
        permissionRequester: (_) async {
          requestCallCount++;
          return PermissionStatus.granted;
        },
      );

      final result = await manager.ensureFullGalleryPermission();

      expect(result, false);
      expect(requestCallCount, 0);
    });

    test(
      'iOS denied access requests once and returns granted when allowed',
      () async {
        Permission? requestedPermission;

        final manager = PhotoManager(
          platform: PhotoManagerPlatform.ios,
          permissionStatusReader: (permission) async {
            requestedPermission = permission;
            return PermissionStatus.denied;
          },
          permissionRequester: (permission) async {
            requestedPermission = permission;
            return PermissionStatus.granted;
          },
        );

        final result = await manager.ensureFullGalleryPermission();

        expect(result, true);
        expect(requestedPermission, Permission.photos);
      },
    );

    test(
      'iOS denied access that resolves to limited still returns false',
      () async {
        final manager = PhotoManager(
          platform: PhotoManagerPlatform.ios,
          permissionStatusReader: (_) async => PermissionStatus.denied,
          permissionRequester: (_) async => PermissionStatus.limited,
        );

        final result = await manager.ensureFullGalleryPermission();

        expect(result, false);
      },
    );

    test(
      'Android 14+ uses native full-gallery check instead of permission_handler',
      () async {
        var statusReadCount = 0;
        var requestCallCount = 0;

        final manager = PhotoManager(
          platform: PhotoManagerPlatform.android,
          androidSdkIntResolver: () async => 34,
          permissionStatusReader: (_) async {
            statusReadCount++;
            return PermissionStatus.granted;
          },
          permissionRequester: (_) async {
            requestCallCount++;
            return PermissionStatus.granted;
          },
          android14FullGalleryPermissionRequester: () async => false,
        );

        final result = await manager.ensureFullGalleryPermission();

        expect(result, false);
        expect(statusReadCount, 0);
        expect(requestCallCount, 0);
      },
    );

    test('Android 13 uses photo permission from permission_handler', () async {
      Permission? requestedPermission;

      final manager = PhotoManager(
        platform: PhotoManagerPlatform.android,
        androidSdkIntResolver: () async => 33,
        permissionStatusReader: (permission) async {
          requestedPermission = permission;
          return PermissionStatus.denied;
        },
        permissionRequester: (permission) async {
          requestedPermission = permission;
          return PermissionStatus.granted;
        },
      );

      final result = await manager.ensureFullGalleryPermission();

      expect(result, true);
      expect(requestedPermission, Permission.photos);
    });

    test('Android 12 and below still use storage permission', () async {
      Permission? requestedPermission;

      final manager = PhotoManager(
        platform: PhotoManagerPlatform.android,
        androidSdkIntResolver: () async => 32,
        permissionStatusReader: (permission) async {
          requestedPermission = permission;
          return PermissionStatus.denied;
        },
        permissionRequester: (permission) async {
          requestedPermission = permission;
          return PermissionStatus.granted;
        },
      );

      final result = await manager.ensureFullGalleryPermission();

      expect(result, true);
      expect(requestedPermission, Permission.storage);
    });
  });
}
