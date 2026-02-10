import 'package:deepple_app/core/extension/extended_context.dart';
import 'package:deepple_app/app/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class IntroduceTabBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final double? horizontalPadding;
  final List<String> tabs;

  const IntroduceTabBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.horizontalPadding,
    required this.tabs,
  });

  @override
  Widget build(BuildContext context) {
    final double padding = horizontalPadding ?? context.screenWidth * 0.05;
    final double tabWidth = context.screenWidth * 0.9 / 2;

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: padding),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: tabs.asMap().entries.map((entry) {
              final int index = entry.key;
              final String label = entry.value;

              return Expanded(
                child: GestureDetector(
                  onTap: () => onTap(index),
                  child: Container(
                    decoration: const BoxDecoration(),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 17.0,
                        horizontal: padding,
                      ),
                      child: Center(
                        child: Text(
                          label,
                          style: index == currentIndex
                              ? Fonts.medium(
                                  fontSize: 14.sp,
                                  color: Palette.colorBlack,
                                )
                              : Fonts.regular(
                                  fontSize: 14.sp,
                                  color: Palette.colorGrey500,
                                ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        // 하단 경계선
        Stack(
          children: [
            Container(height: 1, color: Palette.colorGrey100),
            AnimatedPositioned(
              duration: const Duration(milliseconds: 200),
              left: currentIndex == 0 ? padding : (padding) + tabWidth,
              child: Container(
                width: currentIndex == 0 ? tabWidth : tabWidth,
                height: 2,
                color: Palette.colorBlack,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
