import 'package:deepple_app/app/constants/enum.dart';
import 'package:deepple_app/app/constants/region_data.dart';
import 'package:deepple_app/core/util/date_time_util.dart';
import 'package:deepple_app/features/auth/data/dto/profile_upload_request.dart';
import 'package:deepple_app/features/profile/domain/common/enum.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'sign_up_process_state.freezed.dart';
part 'sign_up_process_state.g.dart';

// TODO(gb): 리팩토링 필요
@freezed
abstract class SignUpProcessState with _$SignUpProcessState {
  const factory SignUpProcessState({
    @Default(1) int currentStep,
    @Default(null) String? nickname,
    @Default(Gender.male) Gender selectedGender, // 변경: Enum 타입 적용
    @Default(false) bool isLoading,
    @Default(null) String? error,
    @Default(null) int? selectedYear,
    @Default(null) int? selectedHeight,
    @Default(null) Job? selectedJob,
    @Default(null) String? selectedLocation,
    @Default(null) Education? selectedEducation, // 변경: Enum 타입 적용
    @Default(null) String? selectedFirstMbtiLetter,
    @Default(null) String? selectedSecondMbtiLetter,
    @Default(null) String? selectedThirdMbtiLetter,
    @Default(null) String? selectedFourthMbtiLetter,
    @Default(null) SmokingStatus? selectedSmoking, // 변경: Enum 타입 적용
    @Default(null) DrinkingStatus? selectedDrinking, // 변경: Enum 타입 적용
    @Default(null) Religion? selectedReligion, // 변경: Enum 타입 적용
    @Default(<Hobby>[]) List<Hobby> selectedHobbies,
  }) = _SignUpProcessState;

  const SignUpProcessState._();

  int? get age => selectedYear != null
      ? DateTimeUtil.calculateAge(yearOfBirth: selectedYear!)
      : null;

  String? get mbti =>
      selectedFirstMbtiLetter != null &&
          selectedSecondMbtiLetter != null &&
          selectedThirdMbtiLetter != null &&
          selectedFourthMbtiLetter != null
      ? '$selectedFirstMbtiLetter$selectedSecondMbtiLetter$selectedThirdMbtiLetter$selectedFourthMbtiLetter'
      : null;

  List<String> get unwritten {
    final Map<String, dynamic> fields = {
      'selectedYear': selectedYear,
      'selectedHeight': selectedHeight,
      'selectedJob': selectedJob,
      'selectedLocation': selectedLocation,
      'selectedEducation': selectedEducation,
      'mbti': mbti,
      'selectedSmoking': selectedSmoking,
      'selectedDrinking': selectedDrinking,
      'selectedReligion': selectedReligion,
      'selectedHobbies': selectedHobbies.isEmpty ? null : selectedHobbies,
    };

    return fields.entries
        .where((entry) => entry.value == null)
        .map((entry) => entry.key)
        .toList();
  }

  bool get isSecondStepCompleted =>
      selectedYear != null &&
      selectedHeight != null &&
      selectedJob != null &&
      selectedLocation != null &&
      selectedEducation != null &&
      selectedFirstMbtiLetter != null &&
      selectedSecondMbtiLetter != null &&
      selectedThirdMbtiLetter != null &&
      selectedFourthMbtiLetter != null &&
      selectedSmoking != null &&
      selectedDrinking != null;

  // 현재 단계에서 버튼 활성화 여부를 계산
  bool isButtonEnabled() {
    switch (currentStep) {
      case 1: // 나이 선택
        return selectedYear != null;
      case 2: // 키 선택
        return selectedHeight != null;
      case 3: // 직업 선택
        return selectedJob != null;
      case 4: // 지역 선택
        return selectedLocation != null &&
            addressData.getDistrictValue(selectedLocation ?? '') != null;
      case 5: // 학력 선택
        return selectedEducation != null;
      case 6: // Mbti 선택
        return selectedFirstMbtiLetter != null &&
            selectedSecondMbtiLetter != null &&
            selectedThirdMbtiLetter != null &&
            selectedFourthMbtiLetter != null;
      case 7: // 흡연 여부 선택
        return selectedSmoking != null;
      case 8: // 음주 여부 선택
        return selectedDrinking != null;
      case 9: // 종교 선택
        return selectedReligion != null;
      case 10: // 취미 선택
        return selectedHobbies.isNotEmpty;
      default:
        return false;
    }
  }

  // ProfileUploadRequest로 변환할 때 인덱스로 변환
  ProfileUploadRequest toProfileUploadRequest() {
    return ProfileUploadRequest(
      nickname: nickname ?? '',
      gender: selectedGender.toJson(), // Enum → 백엔드 변환
      yearOfBirth: selectedYear ?? 0,
      height: selectedHeight ?? 0,
      job: selectedJob?.toJson() ?? '',
      district: addressData.getDistrictValue(selectedLocation ?? '') ?? '', //
      highestEducation: selectedEducation?.toJson() ?? '', // Enum → 백엔드 변환
      mbti: mbti ?? '',
      smokingStatus: selectedSmoking?.toJson() ?? '', // Enum → 백엔드 변환
      drinkingStatus: selectedDrinking?.toJson() ?? '', // Enum → 백엔드 변환
      religion: selectedReligion?.toJson() ?? '', // Enum → 백엔드 변환
      hobbies: selectedHobbies.map((e) => e.toJson()).toList(),
    );
  }

  // JSON 변환 메서드 추가
  factory SignUpProcessState.fromJson(Map<String, dynamic> json) =>
      _$SignUpProcessStateFromJson(json);
}
