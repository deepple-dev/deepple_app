import 'dart:async';

import 'package:deepple_app/app/widget/dialogue/custom_dialogue.dart';
import 'package:deepple_app/features/photo/domain/manager/photo_manager.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

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
  content: '갤러리 조회 권한이 필요한 기능입니다.\n허용을 위해 세팅으로 이동하시겠습니까?',
  onElevatedButtonPressed: () {
    Navigator.of(context).pop();
    unawaited(photoManager.openGalleryPermissionSettings());
  },
);
