import 'package:deepple_app/core/state/base_page_state.dart';
import 'package:deepple_app/app/constants/constants.dart';
import 'package:deepple_app/app/widget/button/default_elevated_button.dart';
import 'package:deepple_app/app/widget/input/default_text_form_field.dart';
import 'package:deepple_app/app/router/router.dart';
import 'package:deepple_app/features/auth/domain/provider/sign_up_process_notifier.dart';
import 'package:deepple_app/features/auth/presentation/widget/auth_step_indicator_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class SignUpProfileUpdatePage extends ConsumerStatefulWidget {
  const SignUpProfileUpdatePage({super.key});

  @override
  SignUpProfileUpdatePageState createState() => SignUpProfileUpdatePageState();
}

class SignUpProfileUpdatePageState
    extends BaseConsumerStatefulPageState<SignUpProfileUpdatePage> {
  SignUpProfileUpdatePageState()
    : super(
        defaultAppBarTitle: '프로필 정보',
        defaultAppBarLeadingAction: (context) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!context.mounted) return;
            navigate(context, route: AppRoute.signUp);
          });
        },
      );

  Widget buildDefaultTextFormFieldRow({
    required String label,
    required String hintText,
    required AppRoute route,
    required int step,
    required String? initialValue,
    Color? fillColor,
  }) {
    final signUpProcess = ref.read(signUpProcessProvider.notifier);
    return Column(
      children: [
        buildLabeledRow(
          context: context,
          label: label,
          child: DefaultTextFormField(
            initialValue: initialValue,
            onTap: () {
              signUpProcess.updateCurrentStep(step);
              navigate(context, route: route, method: NavigationMethod.go);
            },
            enabled: true,
            readOnly: true,
            autofocus: false,
            keyboardType: TextInputType.text,
            hintText: hintText,
            fillColor: fillColor ?? Palette.colorGrey100,
          ),
        ),
        Gap(24.h),
      ],
    );
  }

  @override
  Widget buildPage(BuildContext context) {
    final signUpState = ref.watch(signUpProcessProvider);

    // 버튼 활성화 조건: 닉네임 입력과 성별 선택 모두 완료
    final bool isButtonEnabled = signUpState.isSecondStepCompleted;

    return Column(
      children: [
        Expanded(
          flex: 9,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AuthStepIndicatorWidget(totalSteps: 4, currentStep: 2),
                Gap(16.h),
                Text(
                  '프로필 정보를 등록해주세요',
                  style: Fonts.header03().copyWith(fontWeight: FontWeight.bold),
                ),
                Gap(24.h),
                buildDefaultTextFormFieldRow(
                  label: '나이',
                  hintText: '나이를 선택해주세요.',
                  initialValue: signUpState.age != null
                      ? '${signUpState.age}살'
                      : null,
                  route: AppRoute.signUpProfileChoice,
                  step: 1,
                ),
                buildDefaultTextFormFieldRow(
                  label: '키',
                  hintText: '키를 선택해주세요.',
                  initialValue: signUpState.selectedHeight != null
                      ? '${signUpState.selectedHeight}cm'
                      : null,
                  route: AppRoute.signUpProfileChoice,
                  step: 2,
                ),
                buildDefaultTextFormFieldRow(
                  label: '직업',
                  hintText: '직업을 선택해주세요.',
                  initialValue: signUpState.selectedJob?.label,
                  route: AppRoute.signUpProfileChoice,
                  step: 3,
                ),
                buildDefaultTextFormFieldRow(
                  label: '지역',
                  hintText: '지역을 선택해주세요.',
                  initialValue: signUpState.selectedLocation,
                  route: AppRoute.signUpProfileChoice,
                  step: 4,
                ),
                buildDefaultTextFormFieldRow(
                  label: '최종학력',
                  hintText: '최종학력을 선택해주세요.',
                  initialValue: signUpState.selectedEducation?.label,
                  route: AppRoute.signUpProfileChoice,
                  step: 5,
                ),
                buildDefaultTextFormFieldRow(
                  label: 'MBTI',
                  hintText: 'MBTI를 선택해주세요.',
                  initialValue: signUpState.mbti,
                  route: AppRoute.signUpProfileChoice,
                  step: 6,
                ),
                buildDefaultTextFormFieldRow(
                  label: '흡연',
                  hintText: '흡연여부를 선택해주세요.',
                  initialValue: signUpState.selectedSmoking?.label,
                  route: AppRoute.signUpProfileChoice,
                  step: 7,
                ),
                buildDefaultTextFormFieldRow(
                  label: '음주',
                  hintText: '음주여부를 선택해주세요.',
                  initialValue: signUpState.selectedDrinking?.label,
                  route: AppRoute.signUpProfileChoice,
                  step: 8,
                ),
                buildDefaultTextFormFieldRow(
                  label: '종교',
                  hintText: '종교를 선택해주세요.',
                  initialValue: signUpState.selectedReligion?.label,
                  route: AppRoute.signUpProfileChoice,
                  step: 9,
                ),
                buildDefaultTextFormFieldRow(
                  label: '취미',
                  hintText: '취미를 선택해주세요.',
                  initialValue: signUpState.selectedHobbies
                      .map((e) => e.label)
                      .join(', '),
                  route: AppRoute.signUpProfileChoice,
                  step: 10,
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(bottom: screenHeight * 0.05),
          child: DefaultElevatedButton(
            onPressed: isButtonEnabled
                ? () {
                    navigate(context, route: AppRoute.signUpProfilePicture);
                  }
                : null,
            child: Text(
              isButtonEnabled ? '완료' : '다음',
              style: Fonts.body01Medium(
                isButtonEnabled ? palette.onPrimary : Palette.colorGrey400,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
