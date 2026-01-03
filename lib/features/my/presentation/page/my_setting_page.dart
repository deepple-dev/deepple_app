import 'package:deepple_app/app/constants/constants.dart';
import 'package:deepple_app/app/router/router.dart';
import 'package:deepple_app/app/widget/icon/default_icon.dart';
import 'package:deepple_app/app/widget/view/default_app_bar.dart';
import 'package:deepple_app/features/my/my.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MySettingPage extends ConsumerWidget {
  const MySettingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mySettingAsync = ref.watch(mySettingProvider);

    return Scaffold(
      appBar: const DefaultAppBar(title: '설정'),
      body: Column(
        children: [
          _MySettingListItem(
            title: '알림 설정',
            onTapMove: () =>
                navigate(context, route: AppRoute.pushNotificationSetting),
          ),
          _MySettingListItem(
            title: '계정 설정',
            onTapMove: () => navigate(context, route: AppRoute.accountSetting),
          ),
          mySettingAsync.when(
            data: (data) =>
                _MySettingListItem(title: '앱 버전', version: data.version),
            loading: () =>
                const _MySettingListItem(title: '앱 버전', version: null),
            error: (error, stackTrace) =>
                const _MySettingListItem(title: '앱 버전', version: null),
          ),
          _MySettingListItem(
            title: '연락처 설정',
            onTapMove: () => navigate(context, route: AppRoute.contactSetting),
          ),
          _MySettingListItem(
            title: '개인정보 처리방침',
            onTapMove: () => navigate(context, route: AppRoute.privacyPolicy),
          ),
          _MySettingListItem(
            title: '이용약관',
            onTapMove: () => navigate(context, route: AppRoute.termsOfUse),
          ),
        ],
      ),
    );
  }
}

class _MySettingListItem extends StatelessWidget {
  final String title;
  final VoidCallback? onTapMove;
  final String? version;

  const _MySettingListItem({required this.title, this.onTapMove, this.version});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        children: [
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onTapMove,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: Fonts.body02Medium().copyWith(
                      fontWeight: FontWeight.w400,
                      color: Palette.colorBlack,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (version != null)
                    SizedBox(
                      height: 24,
                      child: Text(
                        'V$version',
                        style: Fonts.body02Medium(const Color(0xff9E9E9E)),
                      ),
                    )
                  else
                    const DefaultIcon(IconPath.chevronRight, size: 24),
                ],
              ),
            ),
          ),
          const Divider(height: 1, thickness: 1, color: Palette.colorGrey50),
        ],
      ),
    );
  }
}
