import 'package:deepple_app/app/constants/constants.dart';
import 'package:deepple_app/app/router/router.dart';
import 'package:deepple_app/app/widget/view/default_app_bar.dart';
import 'package:deepple_app/core/state/base_page_state.dart';

import 'package:deepple_app/features/auth/domain/provider/sign_up_process_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:deepple_app/app/widget/button/default_elevated_button.dart';

class SignUpProfileBaseWidget extends ConsumerStatefulWidget {
  final Widget body;
  final String question;

  const SignUpProfileBaseWidget({
    super.key,
    required this.question,
    required this.body,
  });

  @override
  ConsumerState<SignUpProfileBaseWidget> createState() =>
      _SignUpProfileBaseWidgetState();
}

class _SignUpProfileBaseWidgetState
    extends AppBaseConsumerStatefulPageState<SignUpProfileBaseWidget> {
  _SignUpProfileBaseWidgetState();

  @override
  Widget buildPage(BuildContext context) {
    final signUpState = ref.watch(signUpProcessProvider);
    final signUpProcess = ref.read(signUpProcessProvider.notifier);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: DefaultAppBar(
        title: '프로필 정보',
        leadingAction: (context) =>
            navigate(context, route: AppRoute.signUpProfileUpdate),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(4.h), // Progress bar의 높이를 지정
          child: TweenAnimationBuilder<double>(
            tween: Tween<double>(
              begin: (10 - signUpState.unwritten.length - 1) / 10.0,
              end: (10 - signUpState.unwritten.length) / 10.0,
            ),
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            builder: (context, value, child) {
              return LinearProgressIndicator(
                value: value,
                minHeight: 4.h,
                backgroundColor: Palette.colorGrey100,
                color: palette.primary,
              );
            },
          ),
        ),
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => FocusScope.of(context).unfocus(),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
          child: Column(
            children: [
              Gap(32.h),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  widget.question,
                  style: Fonts.header03(
                    palette.onSurface,
                  ).copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              Gap(16.h),
              Expanded(child: SingleChildScrollView(child: widget.body)),
              Padding(
                padding: const EdgeInsets.only(bottom: Dimens.bottomPadding),
                child: DefaultElevatedButton(
                  onPressed:
                      signUpProcess.isButtonEnabled() && !signUpState.isLoading
                      ? () async {
                          await signUpProcess.nextStep(context);
                        }
                      : null,
                  child: signUpState.isLoading
                      ? const CircularProgressIndicator(
                          color: Palette.colorPrimary500,
                        )
                      : Text(
                          signUpState.unwritten.isEmpty ? '완료' : '다음',
                          style: Fonts.body01Medium(
                            signUpProcess.isButtonEnabled()
                                ? palette.onPrimary
                                : Palette.colorGrey400,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
