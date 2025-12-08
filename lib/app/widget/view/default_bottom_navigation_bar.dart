import 'package:deepple_app/app/constants/constants.dart';
import 'package:deepple_app/app/widget/icon/default_icon.dart';
import 'package:deepple_app/core/extension/extended_context.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DefaultBottomNavigationBar extends StatelessWidget {
  const DefaultBottomNavigationBar({
    super.key,
    required this.controller,
    required this.tabs,
  });

  final TabController controller;
  final List<TabItemInfo> tabs;

  @override
  Widget build(BuildContext context) {
    final defaultTextStyle = Fonts.body03Regular(
      Palette.colorGrey400,
    ).copyWith(fontSize: 11.sp);

    return DecoratedBox(
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: Palette.colorGrey100, width: 1.0),
        ),
      ),
      child: BottomNavigationBar(
        currentIndex: controller.index,
        onTap: (index) => controller.animateTo(index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: context.palette.primary,
        unselectedItemColor: Palette.colorGrey500,
        selectedLabelStyle: TextStyle(color: context.palette.primary),
        unselectedLabelStyle: defaultTextStyle,
        items: tabs.mapIndexed((index, item) {
          final isSelected = controller.index == index;
          return BottomNavigationBarItem(
            icon: Padding(
              padding: const EdgeInsets.only(top: 15, bottom: 8),
              child: DefaultIcon(
                size: 20.h,
                isSelected ? item.iconFill : item.icon,
              ),
            ),
            label: item.label,
          );
        }).toList(),
      ),
    );
  }
}

class TabItemInfo {
  final String icon;
  final String iconFill;
  final String label;
  final Widget container;

  const TabItemInfo({
    required this.icon,
    required this.iconFill,
    required this.label,
    required this.container,
  });
}
