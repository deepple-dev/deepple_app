import 'dart:io';

import 'package:deepple_app/core/util/util.dart';
import 'package:deepple_app/features/photo/domain/model/profile_photo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:deepple_app/features/photo/data/repository/photo_repository.dart';

class UploadPhotosUseCase {
  final Ref ref;
  UploadPhotosUseCase(this.ref);

  Future<bool> execute(List<ProfilePhoto> photos) async {
    try {
      final repo = ref.read(photoRepositoryProvider);

      /// 서버에 보낼 최종 URL 리스트 (길이 동일, 순서 유지)
      final List<String> finalUrls = List.filled(photos.length, '');

      /// S3 업로드 작업들을 담는 리스트
      final List<Future<bool>> uploadTasks = [];

      for (int i = 0; i < photos.length; i++) {
        final photo = photos[i];

        // 업데이트 안된 기존 이미지 → 그대로 유지
        if (photo.imageUrl != null && photo.isUpdated == false) {
          finalUrls[i] = photo.imageUrl!;
          continue;
        }

        // 업데이트된 이미지 (기존 URL 있어도 새 파일 있으면 무조건 업로드)
        if (photo.imageFile != null && photo.isUpdated == true) {
          final file = File(photo.imageFile!.path);

          // presigned URL 발급
          final presignedDto = await repo.getPresignedUrl();
          final presignedUrl = presignedDto.presignedUrl;
          final objectUrl = presignedDto.objectUrl;

          // 업로드 등록
          uploadTasks.add(
            repo
                .uploadImageToS3(presignedUrl: presignedUrl, imageFile: file)
                .then((success) {
                  if (success) {
                    finalUrls[i] = objectUrl; // 새 이미지 URL 저장
                  }
                  return success;
                }),
          );

          continue;
        }
      }

      /// S3 업로드 수행
      if (uploadTasks.isNotEmpty) {
        final results = await Future.wait(uploadTasks);
        if (results.contains(false)) return false;
      }

      Log.d('최종 서버로 보낼 URL 목록: $finalUrls');

      /// 서버에 업로드 요청
      await repo.uploadProfilePhotos(objectUrls: finalUrls);

      return true;
    } catch (e) {
      Log.e('프로필 이미지 업로드 중 실패: $e');
      return false;
    }
  }
}

final uploadPhotosUsecaseProvider = Provider((ref) => UploadPhotosUseCase(ref));
