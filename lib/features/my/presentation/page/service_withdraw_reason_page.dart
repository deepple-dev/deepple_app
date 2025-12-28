import 'package:deepple_app/app/constants/constants.dart';
import 'package:deepple_app/app/router/router.dart';
import 'package:deepple_app/app/widget/dialogue/confirm_dialogue.dart';
import 'package:deepple_app/app/widget/dialogue/error_dialog.dart';
import 'package:deepple_app/app/widget/error/dialogue_error.dart';
import 'package:deepple_app/app/widget/widget.dart';
import 'package:deepple_app/features/my/domain/enum.dart';
import 'package:deepple_app/features/my/my.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class ServiceWithdrawReasonPage extends ConsumerStatefulWidget {
  const ServiceWithdrawReasonPage({super.key});

  @override
  ConsumerState<ServiceWithdrawReasonPage> createState() =>
      _ServiceWithdrawReasonPageState();
}

class _ServiceWithdrawReasonPageState
    extends ConsumerState<ServiceWithdrawReasonPage> {
  WithdrawReason? _selectedReason;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const DefaultAppBar(title: '서비스 탈퇴'),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 16.0,
            right: 16.0,
            top: 24.0,
            bottom: 24.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('서비스를 탈퇴 하시는 이유를 알려주세요.', style: Fonts.body01Medium()),
              const Gap(16),
              Text(
                '서비스 개선에 많은 도움이 됩니다',
                style: Fonts.body02Medium().copyWith(
                  color: const Color(0xff7E7E7E),
                ),
              ),
              const Gap(24),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                spacing: 8,
                children: [
                  ...WithdrawReason.values.map(
                    (reason) => _ReasonItem(
                      reason: reason,
                      selected: _selectedReason == reason,
                      onTap: () => setState(() => _selectedReason = reason),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              DefaultElevatedButton(
                onPressed: _selectedReason != null
                    ? () => context.showConfirmDialog(
                        submit: DialogButton(
                          label: '탈퇴',
                          onTap: () async {
                            final success = await ref
                                .read(mySettingProvider.notifier)
                                .withdrawAccount();
                            if (!context.mounted) return;
                            if (!success) {
                              ErrorDialog.open(
                                context,
                                error: DialogueErrorType.unknown,
                                onConfirm: () => context
                                  ..pop()
                                  ..pop(),
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
                        enableCloseButton: true,
                        child: const _WithdrawConfirmDialogContent(),
                        buttonVerticalPadding: 8,
                      )
                    : null,
                primary: _selectedReason != null
                    ? Palette.colorPrimary500
                    : const Color(0xffE9EBEC), //배경색
                child: Text(
                  '탈퇴하기',
                  style: Fonts.body01Medium().copyWith(
                    fontWeight: FontWeight.w600,
                    color: _selectedReason != null
                        ? Colors.white
                        : const Color(0xffB3B7C0),
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

class _ReasonItem extends StatelessWidget {
  final WithdrawReason reason;
  final bool selected;
  final VoidCallback onTap;

  const _ReasonItem({
    required this.reason,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 19),
        decoration: BoxDecoration(
          color: selected
              ? Palette.colorPrimary500.withValues(alpha: 0.1)
              : Colors.white,
          border: Border.all(
            color: selected
                ? Palette.colorPrimary500.withValues(alpha: 0.3)
                : const Color(0xffE1E1E1),
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          reason.value,
          style: Fonts.body02Medium().copyWith(
            color: selected ? Palette.colorPrimary500 : const Color(0xff515151),
          ),
        ),
      ),
    );
  }
}

class _WithdrawConfirmDialogContent extends StatelessWidget {
  const _WithdrawConfirmDialogContent();

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 327.0),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '서비스 탈퇴',
            style: Fonts.header02().copyWith(fontWeight: FontWeight.w700),
          ),
          const Gap(16),
          Text(
            '탈퇴 후 3개월간 재가입이 불가능합니다.\n정말로 서비스를 탈퇴하시겠습니까?',
            style: Fonts.body02Medium().copyWith(
              fontWeight: FontWeight.w400,
              color: const Color(0xff515151),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
