import 'package:deepple_app/app/widget/button/default_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:deepple_app/app/constants/constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class EventHeartCard extends StatelessWidget {
  const EventHeartCard({super.key, required this.code, required this.onCreate});

  final String code;
  final void Function(String code) onCreate;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SizedBox(
        height: 97.h,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 80.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: const LinearGradient(
                    colors: [
                      Palette.colorPrimary500,
                      Color(0xFF715AFF),
                      Color(0xFF4B5DFF),
                    ],
                  ),
                ),
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                child: GestureDetector(
                  onTap: () => onCreate(code),
                  child: Row(
                    children: [
                      Image.asset(
                        '${ImagePath.imagesPath}/heart90.png',
                        color: const Color(0xFFFCEEFE),
                        width: 40,
                        height: 40,
                      ),
                      const Gap(10),
                      Text(
                        '90',
                        style: Fonts.numeric01Bold().copyWith(
                          fontSize: 28.sp,
                          color: Palette.colorWhite,
                        ),
                      ),
                      const Gap(10),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                '15,000',
                                style: Fonts.numeric01Bold().copyWith(
                                  fontSize: 20,
                                  color: Palette.colorWhite,
                                ),
                              ),
                              Text(
                                '원',
                                style: Fonts.numeric01Bold().copyWith(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                  color: Palette.colorWhite,
                                ),
                              ),
                            ],
                          ),
                          const Gap(4),
                          Text(
                            '18,000원',
                            style: Fonts.numeric01Medium().copyWith(
                              fontSize: 14,
                              color: const Color(0xFFC8C8C8),
                              decoration: TextDecoration.lineThrough,
                              decorationColor: const Color(0xFFC8C8C8),
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      DefaultElevatedButton(
                        onPressed: () => onCreate(code),
                        height: 32.0,
                        width: 100,
                        primary: Palette.colorWhite,
                        padding: const EdgeInsets.only(top: 3.0),
                        expandedWidth: false,
                        borderRadius: BorderRadiusGeometry.circular(99),
                        child: Text(
                          '구매하기',
                          style: Fonts.body03Regular().copyWith(
                            fontSize: 14,
                            color: Palette.colorPrimary500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: 0,
              left: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 0,
                ),
                height: 34,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  color: const Color(0xFF0B0436),
                ),
                child: Text(
                  'EVENT🎉',
                  style: Fonts.semibold(
                    color: Palette.colorWhite,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
