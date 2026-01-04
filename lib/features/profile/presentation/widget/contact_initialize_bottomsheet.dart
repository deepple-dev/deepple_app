import 'package:deepple_app/app/constants/constants.dart';
import 'package:deepple_app/app/enum/contact_method.dart';
import 'package:deepple_app/core/extension/extension.dart';
import 'package:deepple_app/features/contact_setting/domain/provider/contact_setting_notifier.dart';
import 'package:deepple_app/features/contact_setting/presentation/widget/contact_setting_body.dart';
import 'package:deepple_app/features/profile/presentation/widget/common_button_group.dart';
import 'package:deepple_app/features/profile/presentation/widget/message_send_bottomsheet.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ContactInitializeBottomsheet extends StatelessWidget {
  const ContactInitializeBottomsheet({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [ScrollHandler(), Gap(4.0), _ContactSettingBody()],
    );
  }

  static Future<bool?> open(BuildContext context) => showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    useSafeArea: true,
    builder: (context) => Padding(
      padding: EdgeInsets.only(bottom: context.mediaQueryViewInsets.bottom),
      child: const ContactInitializeBottomsheet(),
    ),
  );
}

class _ContactSettingBody extends ConsumerStatefulWidget {
  const _ContactSettingBody();

  @override
  ConsumerState<_ContactSettingBody> createState() =>
      _ContactSettingBodyState();
}

class _ContactSettingBodyState extends ConsumerState<_ContactSettingBody> {
  String? _kakaoId;
  late ContactMethod _selected;

  @override
  void initState() {
    super.initState();
    final state = ref.read(contactSettingProvider);
    _kakaoId = state.kakao;
    _selected = state.method ?? ContactMethod.phone;
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(contactSettingProvider);

    return Material(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      type: MaterialType.canvas,
      color: context.colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 32.0, horizontal: 16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    '잠깐만요!\n'
                    '연락처 등록이 안되었네요',
                    style: Fonts.header03(
                      context.colorScheme.onSurface,
                    ).copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox.square(
                  dimension: 24.0,
                  child: CloseButton(onPressed: context.pop),
                ),
              ],
            ),
            const Gap(8.0),
            Text(
              '메시지를 보내기 위해서는 최초 1회 등록이 필요해요',
              style: Fonts.body02Medium(context.colorScheme.primary),
            ),
            const Gap(24.0),
            Text('연락처 선택', style: Fonts.header03()),
            const Gap(4.0),
            Text('상대방이 데이트 신청을 수락하면 선택한 연락처만 보여줘요'),
            const Gap(12.0),
            ContactSelectForm(
              phoneNumber: state.phone,
              kakaoId: state.kakao,
              selected: _selected,
              onChanged: (selected) => setState(() => _selected = selected),
              onKakaoIdChanged: (kakaoId) => setState(() => _kakaoId = kakaoId),
            ),
            const Gap(24.0),
            CommonButtonGroup(
              onCancel: context.pop,
              onSubmit: () async {
                await ref
                    .read(contactSettingProvider.notifier)
                    .registerContactSetting(
                      method: _selected,
                      kakaoId: _selected == ContactMethod.kakao
                          ? _kakaoId
                          : null,
                    );
                if (!context.mounted) return;
                context.pop<bool>(true);
              },
              enabledSubmit:
                  _selected == ContactMethod.phone ||
                  _kakaoId?.trim().isNotEmpty == true,
              cancelLabel: '취소',
              submitLabel: '저장',
            ),
          ],
        ),
      ),
    );
  }
}
