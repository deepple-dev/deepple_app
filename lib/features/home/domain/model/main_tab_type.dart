import 'package:deepple_app/app/constants/icon_path.dart';
import 'package:deepple_app/app/widget/view/default_bottom_navigation_bar.dart';
import 'package:deepple_app/features/favorite_list/presentation/page/favorite_list_page.dart';
import 'package:deepple_app/features/home/presentation/page/home_page.dart';
import 'package:deepple_app/features/introduce/presentation/page/introduce_page.dart';
import 'package:deepple_app/features/message_list/presentation/page/message_list_page.dart';
import 'package:deepple_app/features/my/presentation/page/my_page.dart';

enum MainTabType {
  home('홈'),
  favorite('좋아요'),
  introduce('셀프소개'),
  message('메시지'),
  my('MY');

  const MainTabType(this.label);

  final String label;
}

final mainTabs = [
  TabItemInfo(
    icon: IconPath.home,
    iconFill: IconPath.homeFill,
    label: MainTabType.home.label,
    container: const HomePage(),
  ),
  TabItemInfo(
    icon: IconPath.like,
    iconFill: IconPath.likeFill,
    label: MainTabType.favorite.label,
    container: const FavoriteListPage(),
  ),
  TabItemInfo(
    icon: IconPath.self,
    iconFill: IconPath.selfFill,
    label: MainTabType.introduce.label,
    container: const IntroducePage(),
  ),
  TabItemInfo(
    icon: IconPath.message,
    iconFill: IconPath.messageFill,
    label: MainTabType.message.label,
    container: const MessageListPage(),
  ),
  TabItemInfo(
    icon: IconPath.mypage,
    iconFill: IconPath.mypageFill,
    label: MainTabType.my.label,
    container: const MyPage(),
  ),
];
