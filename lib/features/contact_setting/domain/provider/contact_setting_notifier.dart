import 'package:deepple_app/features/profile/data/repository/profile_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:deepple_app/app/enum/enum.dart';

import 'package:deepple_app/core/util/log.dart';
import 'package:deepple_app/features/contact_setting/domain/provider/contact_setting_state.dart';

part 'contact_setting_notifier.g.dart';

@Riverpod(keepAlive: true)
class ContactSettingNotifier extends _$ContactSettingNotifier {
  late final ProfileRepository _repository;

  @override
  ContactSettingState build() {
    _repository = ref.read(profileRepositoryProvider);
    return ContactSettingState.initial();
  }

  Future<void> initialize() async {
    final (phoneNumber, kakaoId) = await (
      _repository.getPhoneNumber(),
      _repository.getKakaoId(),
    ).wait;

    state = ContactSettingState(
      method: _repository.getContactMethod(),
      phone: phoneNumber,
      kakao: kakaoId,
    );
  }

  /// TODO(Han): 추후 phone number 갱신 기능 추가
  /// ref.read(localStorageProvider)
  ///  ..saveEncrypted(SecureStorageItem.phoneNumber, state.phone)
  ///  ..saveEncrypted(SecureStorageItem.kakaoId, state.kakao);
  Future<bool> registerContactSetting({
    ContactMethod? method,
    String? kakaoId,
    String? phoneNumber,
  }) async {
    try {
      final newMethod = method ?? state.method;
      if (newMethod != null && newMethod != state.method) {
        _repository.setContactMethod(newMethod);
      }
      if (kakaoId?.isNotEmpty == true && kakaoId != state.kakao) {
        await _repository.setKakaoId(kakaoId ?? '');
      }

      if (phoneNumber?.isNotEmpty == true && phoneNumber != state.phone) {
        _repository.setPhoneNumber(phoneNumber ?? '');
      }

      state = state.copyWith(
        method: newMethod,
        kakao: kakaoId ?? state.kakao,
        phone: phoneNumber ?? state.phone,
      );

      return true;
    } on Exception catch (e) {
      Log.e('contact register failure', errorObject: e);
      return false;
    }
  }
}
