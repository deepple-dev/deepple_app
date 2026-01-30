import 'package:deepple_app/app/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DefaultChip extends StatelessWidget {
  const DefaultChip({super.key, required this.titleList});

  final List<String> titleList;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: titleList
          .map(
            (title) => Container(
              margin: EdgeInsets.only(right: 4.w, bottom: 4.h),
              padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 4.w),

              decoration: const BoxDecoration(
                color: Palette.colorPrimary100,
                borderRadius: BorderRadius.all(Radius.circular(2)),
              ),
              child: Text(
                title,
                style: Fonts.medium(
                  fontSize: 12,
                  color: Palette.colorPrimary600,
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}
