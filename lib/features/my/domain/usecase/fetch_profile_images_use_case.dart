import 'package:deepple_app/core/util/util.dart';
import 'package:deepple_app/features/my/domain/usecase/save_profile_images_to_hive_use_case.dart';
import 'package:deepple_app/features/my/my.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce/hive.dart';

final fetchProfileImagesUseCaseProvider = Provider<FetchProfileImagesUseCase>(
  (ref) => FetchProfileImagesUseCase(ref),
);

class FetchProfileImagesUseCase {
  final Ref _ref;

  FetchProfileImagesUseCase(this._ref);

  Future<List<MyProfileImage>> fetchProfileImages() async {
    try {
      //Hive에서 이미지 리스트 가져오기
      final box = await Hive.openBox(MyProfileImage.boxName);
      final imagesData = box.get('images');

      final savedProfileImages = (imagesData is List)
          ? imagesData.cast<MyProfileImage>()
          : null;

      if (savedProfileImages != null) {
        return savedProfileImages;
      }

      // Hive에 저장된 이미지가 없는 경우 서버에서 가져와 반환하기
      final profileImages = await _ref
          .read(saveProfileImagesToHiveUseCaseProvider)
          .execute();

      return profileImages;
    } catch (e) {
      Log.e('❌ 프로필 이미지 가져오기 중 오류 발생: $e');
      return [];
    }
  }
}
