import 'package:deepple_app/app/widget/input/selection.dart';
import 'package:deepple_app/core/state/base_page_state.dart';
import 'package:deepple_app/app/constants/constants.dart';
import 'package:deepple_app/app/widget/button/default_elevated_button.dart';
import 'package:deepple_app/app/widget/input/default_text_form_field.dart';
import 'package:deepple_app/app/widget/text/title_text.dart';
import 'package:deepple_app/app/router/router.dart';
import 'package:deepple_app/core/util/validation.dart';
import 'package:deepple_app/features/auth/domain/provider/sign_up_process_notifier.dart';
import 'package:deepple_app/features/auth/presentation/widget/auth_step_indicator_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class SignUpPage extends ConsumerStatefulWidget {
  const SignUpPage({super.key});

  @override
  SignUpPageState createState() => SignUpPageState();
}

class SignUpPageState extends BaseConsumerStatefulPageState<SignUpPage> {
  SignUpPageState() : super(defaultAppBarTitle: '계정 생성');

  final TextEditingController _nicknameController = TextEditingController();
  final FocusNode focusNode = FocusNode();
  bool isButtonEnabled = false;

  @override
  void initState() {
    super.initState();

    focusNode.addListener(() {
      if (!focusNode.hasFocus) {
        final signUpProcess = ref.read(signUpProcessProvider.notifier);
        signUpProcess.updateNickname(_nicknameController.text);
        _validateNickname(_nicknameController.text);
      }
    });

    _nicknameController.addListener(() {
      final nickname = _nicknameController.text.trim();

      if (nickname.length >= 2) {
        _validateNickname(_nicknameController.text);
      }
    });
  }

  @override
  void dispose() {
    _nicknameController.dispose();
    focusNode.dispose(); // FocusNode 해제
    super.dispose();
  }

  void _validateNickname(String nickname) {
    if (nickname.isEmpty) {
      safeSetState(() {
        isButtonEnabled = false;
      });
      return;
    }
    final isValid = Validation.nickname.hasMatch(nickname);
    safeSetState(() {
      isButtonEnabled = isValid;
    });
  }

  @override
  Widget buildPage(BuildContext context) {
    final signUpState = ref.watch(signUpProcessProvider);
    final signUpProcess = ref.read(signUpProcessProvider.notifier);

    return GestureDetector(
      behavior: HitTestBehavior.opaque, // 빈 공간에서도 이벤트를 감지
      onTap: () {
        FocusScope.of(context).unfocus(); // 외부를 클릭했을 때 focus 해제
      },
      child: Column(
        children: [
          Expanded(
            flex: 9,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AuthStepIndicatorWidget(totalSteps: 4, currentStep: 1),
                Gap(16.h),
                const TitleText(title: '닉네임을 입력해주세요'),
                Gap(5.h),
                Text(
                  '다른 사용자에게 보여질 이름입니다',
                  style: Fonts.body02Regular(Palette.colorGrey400),
                ),
                Gap(40.h),
                buildLabeledRow(
                  context: context,
                  label: '닉네임',
                  child: DefaultTextFormField(
                    initialValue: signUpState.nickname,
                    focusNode: focusNode,
                    autofocus: false,
                    controller: _nicknameController,
                    keyboardType: TextInputType.text,
                    hintText: '10글자 이내로 입력해주세요.',
                    fillColor: Palette.colorGrey100,
                    errorText: signUpState.error, // 상태 기반 에러 메시지
                    onFieldSubmitted: (value) =>
                        signUpProcess.updateNickname(value), // 엔터를 눌렀을 때 유효성 검사
                  ),
                ),
                Gap(24.h),
                buildLabeledRow(
                  context: context,
                  label: '성별',
                  child: SelectionWidget(
                    options: Gender.values.map((e) => e.label).toList(),
                    onChange: (value) {
                      signUpProcess.updateGender(value);
                    },
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: Dimens.bottomPadding),
            child: DefaultElevatedButton(
              onPressed: isButtonEnabled
                  ? () {
                      navigate(context, route: AppRoute.signUpProfileChoice);
                    }
                  : null,
              child: Text(
                '다음',
                style: Fonts.body01Medium(
                  // signUpProcess.isButtonEnabled()
                  isButtonEnabled ? palette.onPrimary : Palette.colorGrey400,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
