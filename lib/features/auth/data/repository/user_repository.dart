import 'package:deepple_app/core/extension/extension.dart';
import 'package:deepple_app/core/network/base_repository.dart';
import 'package:deepple_app/core/util/log.dart';
import 'package:deepple_app/features/auth/data/dto/profile_upload_request.dart';
import 'package:deepple_app/features/auth/data/dto/user_response.dart';
import 'package:deepple_app/features/auth/data/dto/user_sign_in_request.dart';
import 'package:deepple_app/features/auth/data/usecase/auth_usecase_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepository(ref);
});

class UserRepository extends BaseRepository {
  UserRepository(Ref ref) : super(ref, '/member');

  // 회원가입 및 로그인
  Future<UserData> signIn(UserSignInRequest data) async {
    // 이건 Map<String, dynamic>으로 받아야 함
    final Map<String, dynamic> json = await apiService.postJson(
      '$path/login',
      data: {
        'phoneNumber': data.phoneNumber.removePhoneFormat,
        'code': data.code,
      },
      requiresAccessToken: false,
    );

    await ref.read(authUsecaseProvider).getRefreshToken();

    // 전체 응답 파싱
    final UserResponse userResponse = UserResponse.fromJson(json);

    // data만 리턴
    return userResponse.data;
  }

  // 로그아웃
  Future<void> signOut() =>
      apiService.getJson('$path/logout', requiresRefreshCookie: true);

  // 프로필 업데이트
  Future<void> updateProfile(ProfileUploadRequest requestData) async {
    try {
      await apiService.putJson('$path/profile', data: requestData.toJson());

      Log.d('프로필 업데이트 성공');
    } catch (e, st) {
      Log.e('프로필 업데이트 실패', errorObject: e, stackTrace: st);
      rethrow;
    }
  }

  // 재심사 요청
  Future<void> rescreenProfile() => apiService.postJson(
    '/members/screenings/rescreen',
    data: null,
    requiresRefreshCookie: true,
  );

  // 인증코드 발송
  Future<void> sendVerificationCode({required String phoneNumber}) async {
    await apiService.getJson(
      '$path/code?phoneNumber=${phoneNumber.removePhoneFormat}',
      requiresAccessToken: false,
    );
  }

  // 휴면 계정 활성화
  Future<void> activateAccount(String phoneNumber) async {
    await apiService.postJson(
      '$path/profile/active',
      data: {'phoneNumber': phoneNumber.removePhoneFormat},
      requiresAccessToken: false,
    );
  }
}
