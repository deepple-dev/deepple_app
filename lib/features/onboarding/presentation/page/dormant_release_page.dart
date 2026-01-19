import 'package:deepple_app/app/constants/constants.dart';
import 'package:deepple_app/app/router/router.dart';
import 'package:deepple_app/app/widget/dialogue/error_dialog.dart';
import 'package:deepple_app/app/widget/error/dialogue_error.dart';
import 'package:deepple_app/app/widget/widget.dart';
import 'package:deepple_app/features/onboarding/domain/provider/onboarding_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

// 휴면회원 해제 페이지
class DormantReleasePage extends ConsumerWidget {
  final String phoneNumber;

  const DormantReleasePage({super.key, required this.phoneNumber});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 12.0,
          ).copyWith(bottom: Dimens.bottomPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Gap(24),
              Text(
                '휴면을 해제하고\n새로운 인연을 추천받아보세요!',
                style: Fonts.header02().copyWith(
                  color: Palette.colorBlack,
                  fontWeight: FontWeight.w700,
                  height: 1.2,
                ),
              ),
              const Spacer(),
              Column(
                children: [
                  const DefaultIcon(IconPath.gloomyFace, size: 48.0),
                  Text(
                    '회원님은 휴면 중으로 상대방에게\n프로필이 공개되고 있지 않아요',
                    style: Fonts.body02Medium().copyWith(
                      color: Palette.colorBlack,
                      fontWeight: FontWeight.w400,
                      height: 1.2,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              const Spacer(),
              DefaultElevatedButton(
                child: Text(
                  '휴면 해제하기',
                  style: Fonts.body01Medium().copyWith(
                    color: Palette.colorWhite,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onPressed: () async {
                  final isSuccess = await ref
                      .read(onboardingProvider.notifier)
                      .activateAccount(phoneNumber);
                  if (!context.mounted) return;
                  if (!isSuccess) {
                    ErrorDialog.open(
                      context,
                      error: DialogueErrorType.failDormantRelease,
                      onConfirm: context.pop,
                    );

                    return;
                  }

                  navigate(
                    context,
                    route: AppRoute.onboard,
                    method: NavigationMethod.go,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
