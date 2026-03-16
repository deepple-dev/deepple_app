import 'dart:async';

import 'package:deepple_app/app/widget/dialogue/custom_dialogue.dart';
import 'package:deepple_app/core/util/log.dart';
import 'package:deepple_app/core/util/toast.dart';
import 'package:deepple_app/features/photo/domain/manager/photo_manager.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

const _galleryPermissionDialogMessage =
    '갤러리 조회 권한이 필요한 기능입니다.\n허용을 위해 세팅으로 이동하시겠습니까?';
const _openSettingsErrorMessage = '설정 화면을 열지 못했습니다. 앱 설정에서 권한을 확인해주세요.';

Future<XFile?> pickGalleryPhotoWithPermission({
  required BuildContext context,
  required PhotoManager photoManager,
}) async {
  final hasPermission = await photoManager.ensureFullGalleryPermission();
  if (!context.mounted) return null;

  if (!hasPermission) {
    await _showGalleryPermissionDialog(
      context: context,
      photoManager: photoManager,
    );
    return null;
  }

  return photoManager.pickFromGallery();
}

Future<void> _showGalleryPermissionDialog({
  required BuildContext context,
  required PhotoManager photoManager,
}) => CustomDialogue.showTwoChoiceDialogue(
  context: context,
  content: _galleryPermissionDialogMessage,
  onElevatedButtonPressed: () async {
    Navigator.of(context).pop();
    try {
      final didOpenSettings = await photoManager
          .openGalleryPermissionSettings();
      if (!didOpenSettings) {
        Log.e('openGalleryPermissionSettings returned false');
        await showToastMessage(_openSettingsErrorMessage);
      }
    } catch (e, st) {
      Log.e('openGalleryPermissionSettings failed: $e', stackTrace: st);
      await showToastMessage(_openSettingsErrorMessage);
    }
  },
);
