import 'package:deepple_app/app/widget/view/default_app_bar_action_group.dart';
import 'package:deepple_app/app/constants/constants.dart';
import 'package:deepple_app/app/router/router.dart';
import 'package:deepple_app/app/widget/icon/default_icon.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

typedef MenuItem = ({String title, String iconPath, AppRoute? route});

const List<MenuItem> _menuItems = [
  (
    title: '프로필 관리',
    iconPath: IconPath.myProfile,
    route: AppRoute.profileManage,
  ),
  (
    title: '이상형 설정',
    iconPath: IconPath.idealSetting,
    route: AppRoute.idealSetting,
  ),
  (
    title: '차단친구 관리',
    iconPath: IconPath.blockFriend,
    route: AppRoute.blockFriend,
  ),
  (title: '스토어', iconPath: IconPath.store, route: AppRoute.store),
  (
    title: '고객센터',
    iconPath: IconPath.customerCenter,
    route: AppRoute.customerCenter,
  ),
  (title: '설정', iconPath: IconPath.setting, route: AppRoute.setting),
];

class MyPage extends ConsumerStatefulWidget {
  const MyPage({super.key});

  @override
  MyPageState createState() => MyPageState();
}

class MyPageState extends ConsumerState<MyPage> {
  MyPageState();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          '마이페이지',
          style: Fonts.header03().copyWith(fontWeight: FontWeight.w700),
        ),
        actions: [const DefaultAppBarActionGroup()],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 24),
        child: Column(
          children: _menuItems
              .map((item) => _MyPageListItem(item: item))
              .toList(),
        ),
      ),
    );
  }
}

class _MyPageListItem extends StatelessWidget {
  final MenuItem item;

  const _MyPageListItem({required this.item});

  @override
  Widget build(BuildContext context) {
    final isLast = item == _menuItems.last;

    return Column(
      children: [
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            if (item.route != null) {
              navigate(context, route: item.route!);
            }
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      DefaultIcon(item.iconPath, size: 24),
                      const Gap(8),
                      Text(
                        item.title,
                        style: Fonts.body02Medium().copyWith(
                          fontWeight: FontWeight.w400,
                          color: Palette.colorBlack,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const DefaultIcon(IconPath.chevronRight, size: 24),
              ],
            ),
          ),
        ),
        if (!isLast)
          const Divider(height: 1, thickness: 1, color: Palette.colorGrey50),
      ],
    );
  }
}
