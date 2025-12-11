import 'package:deepple_app/app/provider/provider.dart';
import 'package:deepple_app/core/util/util.dart';
import 'package:deepple_app/features/auth/domain/usecase/get_current_location_use_case.dart';
import 'package:deepple_app/features/home/data/mapper/global_user_profile_mapper.dart';
import 'package:deepple_app/features/home/data/repository/home_profile_repository.dart';
import 'package:deepple_app/features/home/domain/model/cached_user_profile.dart';
import 'package:deepple_app/features/my/data/mapper/my_profile_mapper.dart';
import 'package:deepple_app/features/my/domain/usecase/fetch_profile_images_use_case.dart';
import 'package:deepple_app/features/my/domain/usecase/update_my_profile_use_case.dart';
import 'package:deepple_app/features/my/my.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'profile_manage_notifier.g.dart';

@riverpod
class ProfileManageNotifier extends _$ProfileManageNotifier {
  @override
  Future<ProfileManageState> build() async {
    final state = await _initializeProfile();
    return state;
  }

  Future<ProfileManageState> _initializeProfile() async {
    CachedUserProfile profile = ref.read(globalProvider).profile;

    if (profile == CachedUserProfile.init()) {
      final profileData = await ref
          .read(homeProfileRepositoryProvider)
          .getProfile();
      profile = profileData.toCachedUserProfile();
    }

    final profileImages = await _fetchProfileImages();

    return ProfileManageState(
      profile: profile.toMyProfile().copyWith(profileImages: profileImages),
    );
  }

  void updateLocation(String location) {
    if (!state.hasValue) return;

    final updatedProfile = state.requireValue.profile.copyWith(
      region: location,
    );

    updateProfile(
      profile: updatedProfile,
      isChanged: state.requireValue.isValidLocation(location),
    );
  }

  Future<String> setCurrentLocation() async {
    try {
      final location = await ref
          .read(getCurrentLocationUseCaseProvider)
          .execute();

      if (!state.hasValue) return '';

      final updatedProfile = state.requireValue.profile.copyWith(
        region: location,
      );

      updateProfile(
        profile: updatedProfile,
        isChanged: state.requireValue.isValidLocation(location),
      );

      return location;
    } catch (e) {
      Log.e('위치 정보를 가져오는 데 실패했습니다: $e');
      return '';
    }
  }

  void updateProfile({required MyProfile profile, required bool isChanged}) {
    if (!state.hasValue) return;

    state = AsyncValue.data(
      state.requireValue.copyWith(
        updatedProfile: profile,
        isChanged: isChanged,
      ),
    );
  }

  Future<bool> saveProfile() async {
    final profileNotifier = ref.read(globalProvider.notifier);

    if (state.value?.updatedProfile == null) return false;

    try {
      // 서버에 프로필 업데이트 요청
      final success = await ref
          .read(updateMyProfileUseCaseProvider)
          .updateProfile(state.value!.updatedProfile!);

      if (!success) {
        return false;
      }

      // 프로필 Hive 재저장 및 글로벌 상태 갱신
      profileNotifier.profile = await profileNotifier
          .fetchProfileToHiveFromServer();

      // 상태 초기화
      state = AsyncData(
        state.value!.copyWith(updatedProfile: null, isChanged: false),
      );
      return true;
    } catch (e, stackTrace) {
      Log.e('프로필 저장 중 오류 발생: $e\n$stackTrace');
      return false;
    }
  }

  Future<List<MyProfileImage>> _fetchProfileImages() async {
    return ref.watch(fetchProfileImagesUseCaseProvider).fetchProfileImages();
  }
}
