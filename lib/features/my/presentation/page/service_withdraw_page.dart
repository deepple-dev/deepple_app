import 'package:deepple_app/app/constants/constants.dart';
import 'package:deepple_app/app/router/router.dart';
import 'package:deepple_app/app/widget/button/default_elevated_button.dart';
import 'package:deepple_app/app/widget/view/view.dart';
import 'package:deepple_app/app/widget/dialogue/confirm_dialogue.dart';
import 'package:deepple_app/app/widget/dialogue/error_dialog.dart';
import 'package:deepple_app/app/widget/error/dialogue_error.dart';
import 'package:deepple_app/core/extension/extended_context.dart';
import 'package:flutter/material.dart';
import 'package:deepple_app/features/my/presentation/provider/my_setting_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class ServiceWithdrawPage extends ConsumerWidget {
  const ServiceWithdrawPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: const DefaultAppBar(title: '서비스 탈퇴'),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('서비스를 탈퇴 하시겠습니까?', style: Fonts.body01Medium()),
              const Gap(16),
              Text(
                '서비스를 탈퇴할 경우 계정의 모든 정보와 구매/획득한 하트가 모두 삭제되며 복구할 수 없습니다.\n\n계정을 휴면전환 하시면 프로필이 상대방에게 노출되지 않으며 언제든지 해제할 수 있고 구매/획득한 하트는 1년동안 유지됩니다.',
                style: Fonts.body02Medium().copyWith(
                  color: const Color(0xff7E7E7E),
                  height: 1.5,
                ),
              ),
              const Spacer(),
              DefaultElevatedButton(
                child: Text(
                  '휴면 전환하기',
                  style: Fonts.body02Medium().copyWith(color: Colors.white),
                ),
                onPressed: () {
                  _handleDormantChange(context, ref);
                },
              ),
              const Gap(8),
              DefaultElevatedButton(
                primary: context.palette.onPrimary,
                border: const BorderSide(color: Palette.colorPrimary500),
                onPressed: () =>
                    navigate(context, route: AppRoute.withdrawReason),
                child: Text(
                  '서비스 탈퇴하기',
                  style: Fonts.body02Medium().copyWith(
                    color: Palette.colorPrimary500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleDormantChange(BuildContext context, WidgetRef ref) async {
    await _showUpdateDormantStatus(
      context,
      onDormantChanged: () async {
        final isSuccess = await ref
            .read(mySettingProvider.notifier)
            .deactiveAccount();
        if (!context.mounted) return;
        if (!isSuccess) {
          ErrorDialog.open(
            context,
            error: DialogueErrorType.unknown,
            onConfirm: () => context
              ..pop()
              ..pop(),
          );

          return;
        }

        await _handleSignOut(context, ref);

        if (!context.mounted) return;

        context.pop();

        navigate(context, route: AppRoute.onboard, method: NavigationMethod.go);
      },
    );
  }

  Future<void> _handleSignOut(BuildContext context, WidgetRef ref) async {
    final signOutCompleted = await ref
        .read(mySettingProvider.notifier)
        .signOut();
    if (!context.mounted) return;
    if (!signOutCompleted) {
      ErrorDialog.open(
        context,
        error: DialogueErrorType.failSignOut,
        onConfirm: () => context
          ..pop()
          ..pop(),
      );
    }
  }
}

Future<bool?> _showUpdateDormantStatus(
  BuildContext context, {
  required VoidCallback onDormantChanged,
}) async => context.showConfirmDialog<bool>(
  submit: DialogButton(label: '확인', onTap: onDormantChanged),
  enableCloseButton: false,
  child: Padding(
    padding: const EdgeInsets.only(top: 16.0),
    child: Column(
      children: [
        Text(
          '휴면 회원 전환',
          style: Fonts.header02().copyWith(fontWeight: FontWeight.w700),
        ),
        const Gap(16),
        Text(
          '프로필이 상대방에게 노출되지 않고\n'
          '매칭을 포함한 모든 활동이 제한됩니다\n'
          '휴면회원으로 전환하시겠습니까?',
          style: Fonts.body02Medium().copyWith(
            fontWeight: FontWeight.w400,
            color: const Color(0xff515151),
            height: 1.3,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    ),
  ),
  buttonVerticalPadding: 12,
);
