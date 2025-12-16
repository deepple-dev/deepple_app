import 'package:deepple_app/app/constants/constants.dart';
import 'package:deepple_app/app/widget/icon/default_icon.dart';
import 'package:deepple_app/app/widget/view/default_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class MyBlockFriendPage extends StatelessWidget {
  const MyBlockFriendPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(
        isDivider: true,
        title: '지인 차단',
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Text(
              '전체 선택',
              style: Fonts.body01Medium().copyWith(
                fontWeight: FontWeight.w400,
                color: Palette.colorBlack,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Palette.colorGrey50, width: 1),
                ),
              ),
              child: Row(
                children: [
                  Text(
                    '차단된 연락처',
                    style: Fonts.body02Medium().copyWith(
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                  ),
                  const Gap(5),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xffEAECEF),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Text(
                      '0',
                      style: Fonts.body02Medium().copyWith(
                        fontWeight: FontWeight.w500,
                        color: const Color(0xff222529),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: 8,
                itemBuilder: (context, index) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 12,
                    ),
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Palette.colorGrey50,
                          width: 1,
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '김민지',
                              style: Fonts.body02Medium().copyWith(
                                fontWeight: FontWeight.w400,
                                color: Palette.colorBlack,
                              ),
                            ),
                            const Gap(4),
                            Text(
                              '010-0000-0000',
                              style: Fonts.body02Medium().copyWith(
                                fontWeight: FontWeight.w400,
                                color: const Color(0xff9F9F9F),
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        const DefaultIcon(IconPath.checkFillGray, size: 24),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
