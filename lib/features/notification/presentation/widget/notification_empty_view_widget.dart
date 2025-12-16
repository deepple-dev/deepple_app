import 'package:deepple_app/app/widget/icon/default_icon.dart';
import 'package:flutter/material.dart';
import 'package:deepple_app/app/constants/constants.dart';
import 'package:deepple_app/app/widget/button/default_outlined_button.dart';
import 'package:gap/gap.dart';

class NotificationEmptyViewWidget extends StatelessWidget {
  final VoidCallback onSettingsPressed;

  const NotificationEmptyViewWidget({
    super.key,
    required this.onSettingsPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const DefaultIcon(IconPath.frowningFace, size: 48),
          const Gap(16),
          Text(
            '아직 받은 알람이 없어요\n새로운 알람을 받을 수 있도록 설정하시겠어요?',
            textAlign: TextAlign.center,
            style: Fonts.body02Regular(),
          ),
          const Gap(32),
          DefaultOutlinedButton(
            onPressed: onSettingsPressed,
            child: const Text('알람 설정하러 가기'),
          ),
        ],
      ),
    );
  }
}
