import 'package:deepple_app/app/router/route_arguments.dart';
import 'package:deepple_app/core/state/base_page_state.dart';
import 'package:deepple_app/app/constants/constants.dart';
import 'package:deepple_app/core/util/phone_number_formatter.dart';
import 'package:deepple_app/core/util/util.dart';
import 'package:deepple_app/app/widget/button/default_elevated_button.dart';
import 'package:deepple_app/app/widget/input/default_text_form_field.dart';
import 'package:deepple_app/app/widget/text/title_text.dart';
import 'package:deepple_app/app/router/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

class OnboardingPhoneInputPage extends ConsumerStatefulWidget {
  const OnboardingPhoneInputPage({super.key});

  @override
  OnboardingPhoneInputPageState createState() =>
      OnboardingPhoneInputPageState();
}

class OnboardingPhoneInputPageState
    extends BaseConsumerStatefulPageState<OnboardingPhoneInputPage> {
  final TextEditingController _phoneController = TextEditingController();
  final FocusNode focusNode = FocusNode();
  bool isButtonEnabled = false;

  String? validationError; // 유효성 검사 결과를 저장

  @override
  void initState() {
    super.initState();
    // 포커스 변경 리스너 추가
    focusNode.addListener(() {
      if (!focusNode.hasFocus) {
        _validateInput(_phoneController.text); // 포커스 아웃 시 유효성 검사
      }
    });

    _phoneController.addListener(() {
      final phoneNumber = _phoneController.text.replaceAll(RegExp(r'\D'), '');
      if (phoneNumber.length >= 11) {
        _validateInput(_phoneController.text); // 11자리 이상일 때만 유효성 검사
      } else {
        safeSetState(() {
          validationError = null;
          isButtonEnabled = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _phoneController.dispose();
    focusNode.dispose(); // FocusNode도 해제
    super.dispose();
  }

  void _validateInput(String input) {
    final raw = input.replaceAll(RegExp(r'\D'), '');
    if (raw.isEmpty) {
      safeSetState(() {
        validationError = null;
        isButtonEnabled = false;
      });
      return;
    }

    final isValid = Validation.phoneMobile.hasMatch(raw);
    safeSetState(() {
      validationError = isValid ? null : '올바른 휴대폰 번호 형식이 아닙니다.';
      isButtonEnabled = isValid;
    });
  }

  Future<void> _handleLogin(WidgetRef ref) async {
    final phoneNumber = _phoneController.text;

    if (phoneNumber.isEmpty || validationError != null || !mounted) {
      return;
    }

    try {
      navigate(
        context,
        route: AppRoute.onboardCertification,
        extra: OnboardCertificationArguments(phoneNumber: phoneNumber),
      );
    } catch (e) {
      Log.d('로그인 실패: $e');
    }
  }

  @override
  Widget buildPage(BuildContext context) {
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
                const TitleText(title: '휴대폰 번호를 입력해주세요'),
                const Gap(5),
                Text(
                  '서비스 이용을 위해 본인확인이 필요해요',
                  style: Fonts.body02Regular(Palette.colorGrey400),
                ),
                const Gap(40),
                buildLabeledRow(
                  context: context,
                  label: '휴대폰 번호',
                  child: DefaultTextFormField(
                    focusNode: focusNode,
                    autofocus: false,
                    controller: _phoneController,
                    keyboardType: TextInputType.number,
                    hintText: '010-0000-0000',
                    fillColor: Palette.colorGrey100,
                    errorText: validationError,
                    inputFormatters: [PhoneNumberFormatter()],
                    onFieldSubmitted: (value) {
                      _validateInput(value); // 유효성 검사 실행
                    },
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: Dimens.bottomPadding),
            child: Consumer(
              builder: (context, ref, child) {
                return DefaultElevatedButton(
                  onPressed: isButtonEnabled ? () => _handleLogin(ref) : null,
                  child: Text(
                    '인증번호 요청하기',
                    style: Fonts.body01Medium(
                      isButtonEnabled
                          ? palette.onPrimary
                          : Palette.colorGrey400,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
