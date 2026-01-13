import 'package:deepple_app/app/state/global_state.dart';
import 'package:deepple_app/core/storage/local_storage.dart';
import 'package:deepple_app/core/util/util.dart';
import 'package:deepple_app/features/auth/data/data.dart';
import 'package:deepple_app/features/auth/data/usecase/auth_usecase_impl.dart';
import 'package:deepple_app/features/home/data/dto/introduced_profile_dto.dart';
import 'package:deepple_app/features/home/domain/model/cached_user_profile.dart';
import 'package:deepple_app/features/home/domain/use_case/fetch_user_heart_balance_use_case.dart';
import 'package:deepple_app/features/home/domain/use_case/get_profile_from_hive_use_case.dart';
import 'package:deepple_app/features/home/domain/use_case/save_profile_to_hive_use_case.dart';
import 'package:deepple_app/features/my/domain/usecase/save_profile_images_to_hive_use_case.dart';
import 'package:deepple_app/features/my/my.dart';
import 'package:hive_ce_flutter/adapters.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'global_notifier.g.dart';

@Riverpod(keepAlive: true)
class GlobalNotifier extends _$GlobalNotifier {
  @override
  AppGlobalState build() {
    initProfile();
    fetchHeartBalance();
    return AppGlobalState(
      profile: CachedUserProfile.init(),
      heartBalance: HeartBalance.init(),
    );
  }

  set profile(CachedUserProfile profile) {
    state = state.copyWith(profile: profile);
  }

  // 초기화 (Hive + 서버 + FCM)
  Future<void> initProfile() async {
    try {
      final accessToken = await ref.read(authUsecaseProvider).getAccessToken();
      if (accessToken?.isEmpty ?? true) {
        return;
      }

      final profile = await fetchProfileToHiveFromServer();
      state = state.copyWith(profile: profile);
    } catch (e) {
      Log.e('initialize profile request failed: $e');
    }
  }

  Future<HeartBalance?> fetchHeartBalance() async {
    try {
      final accessToken = await ref.read(authUsecaseProvider).getAccessToken();
      if (accessToken?.isEmpty ?? true) {
        return null;
      }

      final heartBalance = await ref
          .read(fetchUserHeartBalanceUseCaseProvider)
          .execute();

      Log.d('fetched heart point: $heartBalance');

      state = state.copyWith(heartBalance: heartBalance);
      return heartBalance;
    } catch (e) {
      Log.e('fetch heart point failed: $e');
      return null;
    }
  }

  // 서버에서 프로필 가져오고 Hive에 저장
  Future<CachedUserProfile> fetchProfileToHiveFromServer() async {
    await ref.read(saveProfileToHiveUseCaseProvider).execute();
    await ref
        .read(saveProfileImagesToHiveUseCaseProvider)
        .execute(); // 프로필 이미지 가져와 저장

    return await _getProfileFromHive();
  }

  Future<CachedUserProfile> _getProfileFromHive() async {
    return await ref.read(getProfileFromHiveUseCaseProvider).execute();
  }

  Future<void> clearLocalData() async {
    Log.d('start clearLocalData');
    // CachedUserProfile 박스 열기 또는 참조
    final profileBox = await Hive.openBox<CachedUserProfile>(
      CachedUserProfile.boxName,
    );

    // IntroducedProfileDto 박스 열기 또는 참조
    final introducedProfilesBox = await Hive.openBox<Map>(
      IntroducedProfileDto.boxName,
    );

    // MyProfileImage 박스 열기 또는 참조
    final myProfileImagesBox = await Hive.openBox(MyProfileImage.boxName);

    state = state.copyWith(profile: CachedUserProfile.init());

    try {
      await profileBox.clear();
      await profileBox.close();
      await introducedProfilesBox.clear();
      await introducedProfilesBox.close();
      await myProfileImagesBox.clear();
      await myProfileImagesBox.close();
    } catch (e) {
      Log.d('clear Hive data failed: $e');
    }

    try {
      // FlutterSecureStorage에 저장된 데이터 모두 삭제
      await ref.read(localStorageProvider).clearEncrypted();
    } catch (e) {
      Log.d('clear FlutterSecureStorage data failed: $e');
    }

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear(); // 앱 내 모든 SharedPreference 데이터 삭제
    } catch (e) {
      Log.d('clear SharedPreference data failed: $e');
    }
    Log.d('end clearLocalData');
  }
}
