import 'package:deepple_app/app/constants/dimens.dart';
import 'package:deepple_app/app/constants/fonts.dart';
import 'package:deepple_app/app/constants/icon_path.dart';
import 'package:deepple_app/app/constants/palette.dart';
import 'package:deepple_app/app/widget/button/default_elevated_button.dart';
import 'package:deepple_app/app/widget/button/default_outlined_button.dart';
import 'package:deepple_app/app/widget/icon/default_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileExchangeDialog extends ConsumerStatefulWidget {
  final int heartBalance;
  final VoidCallback onSendExchange;
  final VoidCallback onNotEnoughHeart;
  const ProfileExchangeDialog({
    super.key,
    required this.heartBalance,
    required this.onSendExchange,
    required this.onNotEnoughHeart,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ProfileExchangeDialogState();

  static Future<void> open(
    BuildContext context, {
    required int myHeart,
    required VoidCallback onSendExchange,
    required VoidCallback onNotEnoughHeart,
  }) => showDialog(
    context: context,
    builder: (context) => ProfileExchangeDialog(
      heartBalance: myHeart,
      onSendExchange: onSendExchange,
      onNotEnoughHeart: onNotEnoughHeart,
    ),
  );
}

class _ProfileExchangeDialogState extends ConsumerState<ProfileExchangeDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16.0),
      shape: const RoundedRectangleBorder(borderRadius: Dimens.dialogRadius),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 16.0.h,
          children: [
            Text(
              '상대방이 요청을 수락하면\n서로의 프로필을 볼 수 있어요',
              style: Fonts.header04(),
              textAlign: TextAlign.center,
            ),
            Text(
              '보유한 하트: ${widget.heartBalance}',
              style: Fonts.body01Regular(const Color(0xFF7E7E7E)),
              textAlign: TextAlign.center,
            ),

            Row(
              spacing: 8.0.w,
              children: [
                Expanded(
                  child: DefaultOutlinedButton(
                    onPressed: Navigator.of(context).pop,
                    primary: const Color(0xFFE1E1E1),
                    textColor: const Color(0xFF7E7E7E),
                    child: Text(
                      '취소',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14.0.sp,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: DefaultElevatedButton(
                    child: Row(
                      spacing: 4.0.w,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const DefaultIcon(IconPath.heartLine),
                        Text(
                          '${Dimens.profileExchangeHeartCount}',
                          style: TextStyle(
                            color: Palette.colorWhite,
                            fontWeight: FontWeight.w600,
                            fontSize: 14.0.sp,
                          ),
                        ),
                      ],
                    ),
                    onPressed: () {
                      // if (widget.heartBalance <
                      //     Dimens.profileExchangeHeartCount) {
                      //   widget.onNotEnoughHeart();
                      // } else {
                      widget.onSendExchange();
                      // }
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
