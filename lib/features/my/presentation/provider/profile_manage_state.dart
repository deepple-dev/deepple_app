import 'package:deepple_app/app/constants/region_data.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:deepple_app/features/my/domain/model/my_profile.dart';

part 'profile_manage_state.freezed.dart';

@freezed
abstract class ProfileManageState with _$ProfileManageState {
  const factory ProfileManageState({
    required MyProfile profile,
    MyProfile? updatedProfile,
    @Default(false) bool isChanged,
  }) = _ProfileManageState;

  const ProfileManageState._();

  bool isValidLocation(String newLocation) {
    return newLocation != profile.region &&
        addressData.getDistrictValue(newLocation) != null;
  }
}
