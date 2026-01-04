import 'package:deepple_app/app/constants/constants.dart';
import 'package:deepple_app/app/enum/contact_method.dart';
import 'package:deepple_app/app/router/router.dart';
import 'package:deepple_app/app/widget/icon/default_icon.dart';
import 'package:deepple_app/app/widget/input/default_text_form_field.dart';
import 'package:deepple_app/core/extension/extension.dart';
import 'package:deepple_app/features/contact_setting/domain/provider/contact_setting_notifier.dart';
import 'package:deepple_app/features/profile/domain/provider/profile_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import 'package:deepple_app/features/profile/domain/common/model.dart';
import 'package:deepple_app/features/profile/presentation/widget/common_button_group.dart';

class MessageSendBottomSheet extends ConsumerStatefulWidget {
  const MessageSendBottomSheet(
    this.userId, {
    super.key,
    required this.onSubmit,
  });

  final Future Function() onSubmit;

  final int userId;

  @override
  ConsumerState<MessageSendBottomSheet> createState() =>
      _MessageSendBottomSheetState();

  static Future<void> open(
    BuildContext context, {
    required int userId,
    required Future Function() onSubmit,
  }) => showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    useSafeArea: true,
    builder: (context) => Padding(
      padding: EdgeInsets.only(bottom: context.mediaQueryViewInsets.bottom),
      child: MessageSendBottomSheet(userId, onSubmit: onSubmit),
    ),
  );
}

class _MessageSendBottomSheetState
    extends ConsumerState<MessageSendBottomSheet> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    final message = ref.read(profileProvider(widget.userId)).message;

    _controller = TextEditingController(text: message)
      ..addListener(() async {
        await Future.delayed(Duration.zero);
        ref.read(profileProvider(widget.userId).notifier).message =
            _controller.text;
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final status = ref.watch(profileProvider(widget.userId));
    final contactState = ref.watch(contactSettingProvider);
    final messageReceived = status.matchStatus is MatchingReceived;

    final (
      :sendMessageGuide,
      :sendMessageSubGuide,
      :expectedResultAfterSend,
    ) = _generateLanguageResource(
      messageReceived: messageReceived,
      myUserName: status.myUserName,
    );

    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const ScrollHandler(),
          const Gap(4.0),
          Material(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
            ),
            type: MaterialType.canvas,
            color: context.colorScheme.surface,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 32.0,
                horizontal: 16.0,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _BottomSheetHeader(sendMessageGuide),
                  const Gap(8.0),
                  _MessageSendGuide(
                    sendMessageSubGuide: sendMessageSubGuide,
                    hasKakaoId: contactState.kakao?.isNotEmpty == true,
                    contactMethod: contactState.method ?? ContactMethod.phone,
                    onChangedContactMethod: (method) => ref
                        .read(contactSettingProvider.notifier)
                        .registerContactSetting(method: method),
                  ),
                  const Gap(24.0),
                  _MessageSendForm(
                    expectedResultAfterSend: expectedResultAfterSend,
                    controller: _controller,
                  ),
                  const Gap(24.0),
                  _MessageButtonGroup(
                    onMessageSend: () =>
                        _onSubmit(messageReceived: messageReceived),
                    enabledSubmit: _controller.text.isNotEmpty,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  ({
    String sendMessageGuide,
    String sendMessageSubGuide,
    String expectedResultAfterSend,
  })
  _generateLanguageResource({
    required bool messageReceived,
    required String myUserName,
  }) {
    return (
      sendMessageGuide:
          '$myUserName님, \n${messageReceived ? '메시지로 관심에 답해주세요' : '메시지로 관심을 표현하세요'}',
      sendMessageSubGuide: messageReceived
          ? '등록한 연락처 상대에게 공개됩니다'
          : '상대방도 관심을 표현했어요! 매칭 확률이 매우 높습니다.',
      expectedResultAfterSend: messageReceived
          ? '빠른 응답은 상대에게 좋은 이미지를 줄 수 있어요!'
          : '진심이 담긴 메시지로 좋은 인상을 줄 수 있어요',
    );
  }

  Future<void> _onSubmit({required bool messageReceived}) async {
    final hasPoint = ref.read(profileProvider(widget.userId)).heartPoint;

    context.pop();

    if (messageReceived) {
      return _messageSendAndDetuctPoint();
    }

    await showDialog(
      context: context,
      builder: (context) => _MessageSendConfirm(
        hasPoint: hasPoint,
        needPoint: Dimens.messageSendHeartCount,
        onMessageSend: _messageSendAndDetuctPoint,
      ),
    );
  }

  Future<void> _messageSendAndDetuctPoint() async {
    await widget.onSubmit();

    if (!mounted) return;
    context.pop();
  }
}

class ScrollHandler extends StatelessWidget {
  const ScrollHandler({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 38.0,
      height: 4.0,
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        borderRadius: const BorderRadius.all(Radius.circular(100.0)),
      ),
    );
  }
}

class _BottomSheetHeader extends StatelessWidget {
  const _BottomSheetHeader(this.sendMessageGuide);

  final String sendMessageGuide;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: Text(sendMessageGuide, style: Fonts.header03())),
        GestureDetector(
          onTap: context.pop,
          child: const Icon(Icons.close, size: 24.0),
        ),
      ],
    );
  }
}

class _MessageSendGuide extends StatelessWidget {
  const _MessageSendGuide({
    required this.sendMessageSubGuide,
    required this.hasKakaoId,
    required this.contactMethod,
    required this.onChangedContactMethod,
  });

  final String sendMessageSubGuide;
  final bool hasKakaoId;
  final ContactMethod contactMethod;
  final ValueChanged<ContactMethod> onChangedContactMethod;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          sendMessageSubGuide,
          style: Fonts.body02Medium(const Color(0xFF7462E8)),
        ),
        const Gap(24.0),
        if (hasKakaoId)
          _ContactSelectOption(
            selected: contactMethod,
            onChanged: onChangedContactMethod,
          ),
      ],
    );
  }
}

class _ContactSelectOption extends StatelessWidget {
  const _ContactSelectOption({required this.selected, required this.onChanged});

  final ContactMethod selected;
  final ValueChanged<ContactMethod> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('연락처 선택', style: Fonts.header03()),
        const Gap(4.0),
        Text('상대방이 데이트 신청을 수락하면 선택한 연락처만 보여줘요'),
        const Gap(12.0),
        RadioGroup<ContactMethod>(
          groupValue: selected,
          onChanged: (value) {
            if (value == null) return;
            onChanged(value);
          },
          child: Row(
            children: [
              Expanded(
                child: _ContactOptionWithLabel(
                  method: ContactMethod.phone,
                  onChanged: (method) => onChanged(method),
                ),
              ),
              Expanded(
                child: _ContactOptionWithLabel(
                  method: ContactMethod.kakao,
                  onChanged: (method) => onChanged(method),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ContactOptionWithLabel extends StatelessWidget {
  const _ContactOptionWithLabel({
    required this.method,
    required this.onChanged,
  });

  final ContactMethod method;
  final ValueChanged<ContactMethod> onChanged;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(method),
      behavior: HitTestBehavior.translucent,
      child: Row(
        spacing: 8.0,
        children: [
          SizedBox.square(dimension: 16.0, child: Radio(value: method)),
          Text(method.label, style: Fonts.body02Medium()),
        ],
      ),
    );
  }
}

class _MessageSendForm extends StatelessWidget {
  const _MessageSendForm({
    required this.expectedResultAfterSend,
    required this.controller,
  });

  final String expectedResultAfterSend;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('메시지 입력하기', style: Fonts.header03()),
        const Gap(4.0),
        Text(expectedResultAfterSend),
        const Gap(16.0),
        DefaultTextFormField(
          controller: controller,
          border: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(8.0)),
            borderSide: BorderSide(color: context.colorScheme.secondary),
          ),
          hintText: '개인 연락처를 기재하시면 경고없이 서비스 이용이 정지될 수 있습니다.',
          hintStyle: Fonts.body02Medium(context.colorScheme.secondary),
          contentPadding: const EdgeInsets.all(16.0).copyWith(left: .0),
          maxLines: 6,
          maxLength: 200,
          showCharacterCount: true,
        ),
      ],
    );
  }
}

class _MessageButtonGroup extends StatelessWidget {
  const _MessageButtonGroup({
    required this.onMessageSend,
    required this.enabledSubmit,
  });

  final VoidCallback onMessageSend;
  final bool enabledSubmit;

  @override
  Widget build(BuildContext context) {
    return CommonButtonGroup(
      onCancel: context.pop,
      onSubmit: onMessageSend,
      cancelLabel: '취소',
      submitLabel: '확인',
      enabledSubmit: enabledSubmit,
    );
  }
}

class _MessageSendConfirm extends StatelessWidget {
  const _MessageSendConfirm({
    required this.hasPoint,
    required this.needPoint,
    required this.onMessageSend,
  });

  final int hasPoint;
  final int needPoint;
  final VoidCallback onMessageSend;

  bool get _isEnoughPoint => hasPoint >= needPoint;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          color: context.colorScheme.surface,
          borderRadius: const BorderRadius.all(Radius.circular(16.0)),
        ),
        constraints: BoxConstraints(maxWidth: context.screenWidth * .8),
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 13.0),
        child: _isEnoughPoint
            ? Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Gap(8.0),
                  Text('메시지 보내기', style: Fonts.header02()),
                  const Gap(12.0),
                  Text('보유한 하트: $hasPoint'),
                  const Gap(8.0),
                  const Text(
                    '3일 동안 상대방으로부터 응답이 없으면\n사용하신 하트를 100% 돌려드려요',
                    textAlign: TextAlign.center,
                  ),
                  const Gap(17.0),
                  CommonButtonGroup.custom(
                    onCancel: context.pop,
                    onSubmit: () async {
                      context.pop();
                      onMessageSend();
                    },
                    cancel: Text(
                      '취소',
                      style: Fonts.body02Medium().copyWith(
                        fontWeight: FontWeight.w400,
                        color: Palette.colorBlack,
                      ),
                    ),
                    submit: Text.rich(
                      TextSpan(
                        children: [
                          const WidgetSpan(
                            child: Padding(
                              padding: EdgeInsets.only(right: 4.0),
                              child: DefaultIcon(IconPath.heart, size: 20),
                            ),
                          ),
                          TextSpan(
                            text: needPoint.toString(),
                            style: Fonts.body02Medium().copyWith(
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )
            : Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Gap(8.0),
                  Text('하트가 부족해요!', style: Fonts.header02()),
                  const Gap(12.0),
                  Text('보유한 하트: $hasPoint'),
                  const Gap(24.0),
                  CommonButtonGroup.custom(
                    onCancel: context.pop,
                    onSubmit: () async {
                      context.pop();
                      navigate(context, route: AppRoute.store);
                    },
                    cancel: Text(
                      '취소',
                      style: Fonts.body02Medium().copyWith(
                        fontWeight: FontWeight.w400,
                        color: Palette.colorBlack,
                      ),
                    ),
                    submit: Text(
                      '하트 충전하기',
                      style: Fonts.body02Medium().copyWith(
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
