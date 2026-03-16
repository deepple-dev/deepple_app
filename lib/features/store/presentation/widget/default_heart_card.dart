import 'package:deepple_app/core/extension/extension.dart';
import 'package:flutter/material.dart';
import 'package:deepple_app/app/constants/constants.dart';
import 'package:deepple_app/app/widget/button/button.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class DefaultHeartCard extends StatelessWidget {
  const DefaultHeartCard({
    super.key,
    required this.heart,
    required this.price,
    required this.code,
    required this.onCreate,
  });

  final String heart;
  final String price;
  final String code;
  final void Function(String code) onCreate;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70.h,
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F2F2),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          Image.asset(
            '${ImagePath.imagesPath}/heart$heart.png',
            width: 40.w,
            height: 40.h,
          ),
          const Gap(10),
          Text(heart, style: Fonts.numeric01Bold().copyWith(fontSize: 20.0.sp)),
          const Gap(10),
          Text(
            '${price.formatThousands} 원',
            style: Fonts.medium(fontSize: 16.0, color: Palette.colorBlack),
          ),
          const Spacer(),
          DefaultElevatedButton(
            onPressed: () => onCreate(code),
            height: 32.0,
            width: 100,
            padding: const EdgeInsets.only(top: 3.0),
            expandedWidth: false,
            borderRadius: BorderRadiusGeometry.circular(99),
            child: Text(
              '구매하기',
              style: Fonts.body03Regular().copyWith(
                fontSize: 14,
                color: Palette.colorWhite,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
