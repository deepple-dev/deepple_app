import 'package:deepple_app/app/constants/dimens.dart';
import 'package:deepple_app/app/constants/fonts.dart';
import 'package:deepple_app/app/constants/icon_path.dart';
import 'package:deepple_app/app/constants/palette.dart';
import 'package:deepple_app/app/widget/button/default_elevated_button.dart';
import 'package:deepple_app/app/widget/button/default_outlined_button.dart';
import 'package:deepple_app/app/widget/icon/default_icon.dart';
import 'package:deepple_app/features/home/presentation/widget/category/heart_shortage_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileExchangeDialog extends ConsumerWidget {
  final int myHeartPoint;
  final VoidCallback onSendExchange;

  const ProfileExchangeDialog({
    super.key,
    required this.myHeartPoint,
    required this.onSendExchange,
  });

  bool get _notEnoughHeart => myHeartPoint < Dimens.profileExchangeHeartCount;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (_notEnoughHeart) {
      return HeartShortageDialog(heartBalance: myHeartPoint);
    }

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
              '보유한 하트: $myHeartPoint',
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
                    onPressed: onSendExchange,
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
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  static Future<void> open(
    BuildContext context, {
    required int myHeartPoint,
    required VoidCallback onSendExchange,
  }) => showDialog(
    context: context,
    builder: (context) => ProfileExchangeDialog(
      myHeartPoint: myHeartPoint,
      onSendExchange: onSendExchange,
    ),
  );
}
