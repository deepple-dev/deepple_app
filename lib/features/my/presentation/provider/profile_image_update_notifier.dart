import 'package:deepple_app/app/constants/constants.dart';
import 'package:deepple_app/core/util/util.dart';
import 'package:deepple_app/features/my/presentation/provider/profile_image_update_state.dart';
import 'package:deepple_app/features/photo/domain/model/profile_photo.dart';
import 'package:deepple_app/features/my/domain/model/my_profile_image.dart';
import 'package:deepple_app/features/photo/domain/usecase/upload_photos_use_case.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'profile_image_update_notifier.g.dart';

@Riverpod(keepAlive: true)
class ProfileImageUpdateNotifier extends _$ProfileImageUpdateNotifier {
  @override
  ProfileImageUpdateState build(List<ProfilePhoto> profilePhotos) {
    Log.d('가져온 프로필 이미지 리스트는 $profilePhotos');
    return ProfileImageUpdateState(
      profileImages: profilePhotos,
      hasDeletion: false,
      isSaving: false,
    );
  }

  bool get isSaveEnabled =>
      state.hasDeletion ||
      state.profileImages.any((image) => image.isUpdated == true);

  /// 프로필 이미지 업데이트
  Future<void> updateEditableProfileImages({
    required int index,
    required XFile image,
  }) async {
    Log.d('여기 진입함');

    try {
      // 현재 state 복사
      final updatedImages = [...state.profileImages];

      if (index < 0 || index > Dimens.profileImageMaxCount - 1) {
        throw Exception(
          '인덱스는 0보다 작거나 ${Dimens.profileImageMaxCount - 1}보다 클 수가 없습니다.',
        );
      }

      // 리스트 범위보다 큰 인덱스 → append
      if (index >= updatedImages.length) {
        updatedImages.add(ProfilePhoto(imageFile: image, isUpdated: true));

        state = state.copyWith(profileImages: updatedImages);

        return;
      }

      updatedImages[index] = updatedImages[index].copyWith(
        imageFile: image,
        isUpdated: true,
      );

      state = state.copyWith(profileImages: updatedImages);
    } catch (e) {
      Log.e('이미지 추가/변경 중 오류 발생: $e');
    }
  }

  /// 프로필 이미지 삭제
  void deleteEditableProfileImage(int index) {
    if (index < 0 || index >= state.profileImages.length) {
      Log.d('인덱스가 리스트 범위에서 벗어났습니다.');
      return;
    }

    final copiedImages = [...state.profileImages];
    copiedImages.removeAt(index);

    state = state.copyWith(profileImages: copiedImages, hasDeletion: true);

    Log.d('삭제 후 state: $state');
  }

  /// 서버 업로드 + Hive에 저장된 데이터 삭제
  Future<bool> save(List<ProfilePhoto> photos) async {
    try {
      // 서버 업로드
      state = state.copyWith(isSaving: true);
      final isSuccess = await ref
          .read(uploadPhotosUsecaseProvider)
          .execute(photos);

      if (isSuccess) {
        // Hive 데이터 삭제
        final box = await Hive.openBox(MyProfileImage.boxName);
        await box.delete('images');

        state = state.copyWith(hasDeletion: false, isSaving: false);
      }

      return isSuccess;
    } catch (e) {
      Log.e('❌ 프로필 이미지 저장 중 오류 발생: $e');
      return false;
    }
  }
}
