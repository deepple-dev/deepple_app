import 'package:deepple_app/app/constants/constants.dart';
import 'package:deepple_app/app/router/router.dart';
import 'package:deepple_app/app/widget/widget.dart';
import 'package:deepple_app/core/extension/extended_context.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class HeartShortageDialog extends StatelessWidget {
  const HeartShortageDialog({super.key, required this.heartBalance});

  final int heartBalance;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: context.screenWidth,
          margin: const EdgeInsets.symmetric(horizontal: 25),
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Text(
                '하트가 부족해요!',
                style: Fonts.header02().copyWith(fontWeight: FontWeight.w700),
              ),
              const Gap(12),
              Text(
                '보유한 하트 : $heartBalance',
                style: Fonts.body02Medium().copyWith(
                  fontWeight: FontWeight.w400,
                ),
              ),
              const Gap(24),
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Flexible(
                      flex: 3,
                      child: DefaultElevatedButton(
                        onPressed: context.pop,
                        primary: Colors.white,
                        border: const BorderSide(color: Color(0xffE1E1E1)),
                        child: Text(
                          '취소',
                          style: Fonts.body02Medium().copyWith(
                            fontWeight: FontWeight.w400,
                            color: Palette.colorBlack,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8), // Gap 대신 SizedBox 사용
                    Flexible(
                      flex: 7,
                      child: DefaultElevatedButton(
                        onPressed: () {
                          context.pop();
                          navigate(context, route: AppRoute.store);
                        },
                        primary: Palette.colorPrimary500,
                        child: Text(
                          '하트 충전하러 가기',
                          style: Fonts.body02Medium().copyWith(
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
