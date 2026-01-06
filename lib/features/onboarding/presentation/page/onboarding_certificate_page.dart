import 'dart:async';

import 'package:deepple_app/app/constants/constants.dart';
import 'package:deepple_app/app/router/route_arguments.dart';
import 'package:deepple_app/app/router/router.dart';
import 'package:deepple_app/app/widget/button/default_elevated_button.dart';
import 'package:deepple_app/app/widget/button/default_outlined_button.dart';
import 'package:deepple_app/app/widget/dialogue/confirm_dialogue.dart';
import 'package:deepple_app/app/widget/input/default_text_form_field.dart';
import 'package:deepple_app/app/widget/text/title_text.dart';
import 'package:deepple_app/core/state/base_page_state.dart';
import 'package:deepple_app/core/util/toast.dart';
import 'package:deepple_app/features/auth/data/data.dart';
import 'package:deepple_app/features/auth/data/dto/user_response.dart';
import 'package:deepple_app/features/contact_setting/domain/provider/contact_setting_notifier.dart';
import 'package:deepple_app/features/onboarding/domain/enum/auth_status.dart';
import 'package:deepple_app/features/onboarding/domain/provider/onboarding_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class OnboardingCertificationPage extends ConsumerStatefulWidget {
  const OnboardingCertificationPage({super.key, required this.phoneNumber});

  final String phoneNumber;

  @override
  ConsumerState<OnboardingCertificationPage> createState() =>
      _OnboardingCertificationPageState();
}

class _OnboardingCertificationPageState
    extends BaseConsumerStatefulPageState<OnboardingCertificationPage> {
  final _codeController = TextEditingController();
  final _focusNode = FocusNode();
  late final OnboardingNotifier _notifier;

  @override
  void initState() {
    super.initState();
    _notifier = ref.read(onboardingProvider.notifier);

    // 인증 코드 전송
    _notifier.sendVerificationCode(widget.phoneNumber);

    // 입력값 검증 리스너
    _codeController.addListener(() {
      _notifier.validateInput(_codeController.text);
    });
  }

  @override
  void dispose() {
    _codeController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget buildPage(BuildContext context) {
    final state = ref.watch(onboardingProvider);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Column(
        children: [
          Expanded(
            flex: 9,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const TitleText(title: '인증번호를 입력해주세요'),
                const Gap(5),
                Text(
                  '문자로 보내드린 인증번호를 입력해주세요',
                  style: Fonts.body02Regular(Palette.colorGrey400),
                ),
                const Gap(40),
                buildLabeledRow(
                  context: context,
                  label: '인증번호',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            flex: 7,
                            child: DefaultTextFormField(
                              focusNode: _focusNode,
                              controller: _codeController,
                              keyboardType: TextInputType.number,
                              hintText: '000000',
                              fillColor: Palette.colorGrey100,
                            ),
                          ),
                          const Gap(10),
                          Expanded(
                            flex: 3,
                            child: DefaultOutlinedButton(
                              primary: Palette.colorGrey100,
                              textColor: palette.onSurface,
                              onPressed: state.leftSeconds == 0
                                  ? () =>
                                        _notifier.resendCode(widget.phoneNumber)
                                  : null,
                              child: Text(
                                state.leftSeconds == 0
                                    ? '재발송'
                                    : '00:${state.leftSeconds.toString().padLeft(2, '0')}',
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (state.validationError != null)
                        Text(
                          state.validationError!,
                          style: Fonts.body03Regular(palette.error),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: screenHeight * 0.05),
            child: DefaultElevatedButton(
              onPressed: state.isButtonEnabled && !state.isLoading
                  ? () => _verifyCode(_notifier)
                  : null,
              child: Text(
                '인증하기',
                style: Fonts.body01Medium(
                  state.isButtonEnabled
                      ? palette.onPrimary
                      : Palette.colorGrey400,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _verifyCode(OnboardingNotifier notifier) async {
    final (UserData? userData, status) = await notifier.verifyCode(
      widget.phoneNumber,
      _codeController.text,
    );

    if (!context.mounted) return;

    switch (status) {
      case AuthStatus.activate:
        _handleActivateStatus(userData);
        break;
      case AuthStatus.dormant:
        _handleDormantStatus();
        break;

      case AuthStatus.forbidden:
        await _handleForbiddenStatus();
        break;

      case AuthStatus.temporarilyForbidden:
        navigate(
          context,
          route: AppRoute.temporalForbidden,
          extra: TemporalForbiddenArguments(time: notifier.suspensioinExpireAt),
        );
        break;

      case AuthStatus.deletedUser:
        await _handleDeletedUserStatus();
        break;
      case null:
        showToastMessage('인증에 실패했습니다.');
        break;
    }
  }

  Future<void> _handleActivateStatus(UserData? userData) async {
    ref
        .read(contactSettingProvider.notifier)
        .registerContactSetting(phoneNumber: widget.phoneNumber);

    if (!context.mounted) return;

    if (userData?.isProfileSettingNeeded ?? false) {
      navigate(context, route: AppRoute.signUp);
    } else if (userData?.activityStatus == 'WAITING_SCREENING') {
      navigate(
        context,
        route: AppRoute.signUpProfileReview,
        method: NavigationMethod.go,
      );
    } else if (userData?.activityStatus == 'REJECTED_SCREENING') {
      navigate(
        context,
        route: AppRoute.signUpProfileReject,
        method: NavigationMethod.go,
      );
    } else {
      navigate(context, route: AppRoute.mainTab, method: NavigationMethod.go);
    }
  }

  Future<void> _handleDormantStatus() async {
    if (!context.mounted) return;

    navigate(
      context,
      route: AppRoute.dormantRelease,
      method: NavigationMethod.go,
      extra: DormantReleaseArguments(phoneNumber: widget.phoneNumber),
    );
  }

  Future<void> _handleForbiddenStatus() async {
    if (!context.mounted) return;
    await _showDialogue(
      context,
      onTapVerify: context.pop,
      title: '서비스 이용 제한',
      content: '서비스 이용약관 및 운영정책 위반으로 사용이 정지되었습니다.',
    );
  }

  Future<void> _handleDeletedUserStatus() async {
    if (!context.mounted) return;
    await _showDialogue(
      context,
      onTapVerify: context.pop,
      title: '서비스 가입 제한',
      content: '탈퇴일로부터 3개월간 동일 계정으로\n재가입이 제한됩니다.',
    );
  }

  Future<bool?> _showDialogue(
    BuildContext context, {
    required VoidCallback onTapVerify,
    required String title,
    required String content,
  }) async {
    return await context.showPrimaryConfirmDialog(
      submit: DialogButton(label: '확인', onTap: onTapVerify),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: Fonts.header02().copyWith(
              color: Palette.colorBlack,
              fontWeight: FontWeight.w700,
            ),
          ),
          const Gap(12),
          Text(
            content,
            style: Fonts.body01Medium().copyWith(
              color: const Color(0xff7E7E7E),
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
      buttonVerticalPadding: 12,
    );
  }
}
