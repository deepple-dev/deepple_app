import 'package:deepple_app/app/constants/constants.dart';
import 'package:deepple_app/core/util/log.dart';
import 'package:deepple_app/core/util/permission_handler.dart';
import 'package:deepple_app/features/photo/domain/model/profile_photo.dart';
import 'package:deepple_app/features/photo/domain/usecase/upload_photos_use_case.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'photo_provider.g.dart';

enum PhotoUpdateAction { upload, delete }

@riverpod
class Photo extends _$Photo with ChangeNotifier, WidgetsBindingObserver {
  final ImagePicker _imagePicker =
      ImagePicker(); // 이미지 소스를 선택(카메라, 갤러리 등)하고 이미지를 가져오는 역할
  final PermissionHandler _permissionHandler = PermissionHandler();
  bool _isReturningFromSettings =
      false; // 사용자가 앱 설정 화면에서 돌아왔는지 여부를 추적하는 플래그. 권한이 변경되었는지 확인하는 데 사용.

  @override
  List<XFile?> build() {
    WidgetsBinding.instance.addObserver(this); // 라이프사이클 관찰 시작
    return List.filled(Dimens.profileImageMaxCount, null); // 초기화 상태: 6개의 null 값
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this); // 라이프사이클 관찰 중지
    _permissionHandler.dispose(); // PermissionHandler도 정리
    super.dispose();
  }

  @override
  // 앱의 라이프사이클 상태가 변경될 때 호출
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && _isReturningFromSettings) {
      // 앱이 활성 상태로 돌아왔을 때 (예를 들어 설정 화면에서 돌아왔을 때)
      _isReturningFromSettings = false;
      // 설정에서 돌아온 후 권한 상태 확인
      _permissionHandler.checkPhotoPermissionStatus().then((isGranted) {
        if (!isGranted) {
          Log.i('설정에서 돌아온 후에도 권한이 허용되지 않았습니다.');
        }
      });
    } else if (state == AppLifecycleState.inactive) {
      // 앱이 비활성 상태로 전환되었 때 (예를 들어 설정 같은 다른 앱에 갔을 때)
      _isReturningFromSettings = true;
    }
  }

  // 사진 업로드
  Future<bool> uploadPhotos(List<ProfilePhoto> photos) async {
    final clampedPhotos = photos.take(Dimens.profileImageMaxCount).toList();

    state = [
      ...clampedPhotos.map((e) => e.imageFile),
      ...List.filled(Dimens.profileImageMaxCount - clampedPhotos.length, null),
    ];

    return await ref.read(uploadPhotosUsecaseProvider).execute(photos);
  }

  // 사진 선택
  Future<XFile?> pickPhoto(ImageSource source) async {
    try {
      final permissionStatus = await _permissionHandler
          .checkPhotoPermissionStatus();
      if (!permissionStatus) {
        Log.i('권한이 허용되지 않았습니다.');
        return null;
      }
      return await _imagePicker.pickImage(source: source);
    } catch (e) {
      Log.e('사진 선택 중 오류 발생: $e');
      return null;
    }
  }

  // UI만 업데이트 (빈 공간이 있으면 앞으로 당기기)
  void updateState(int index, XFile? photo) {
    final updatedPhotos = [...state];
    updatedPhotos[index] = photo;

    state = compactPhotos(updatedPhotos);
  }

  // 빈 공간을 뒤 로 밀어내기
  List<XFile?> compactPhotos(List<XFile?> photos) {
    final nonNullPhotos = photos.where((photo) => photo != null).toList();
    final nullCount = photos.length - nonNullPhotos.length;

    return [...nonNullPhotos, ...List.filled(nullCount, null)];
  }
}
