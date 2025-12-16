import 'package:deepple_app/features/auth/data/dto/profile_upload_request.dart';
import 'package:deepple_app/features/auth/data/dto/user_response.dart';
import 'package:deepple_app/features/auth/data/dto/user_sign_in_request.dart';

abstract class AuthUseCase {
  Future<UserData> signIn(UserSignInRequest user);
  Future<bool> signOut({
    bool isTokenExpiredSignOut = false,
  });
  Future<String?> getAccessToken();
  void setAccessToken(String accessToken);
  Future<String?> getRefreshToken();
  Future<void> rescreenProfile();
  Future<void> uploadProfile(ProfileUploadRequest profileData);
  Future<void> sendSmsVerificationCode(String phoneNumber);
  Future<void> activateAccount(String phoneNumber);
}
