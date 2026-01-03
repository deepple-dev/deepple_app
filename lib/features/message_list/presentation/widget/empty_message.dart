import 'package:deepple_app/app/router/router.dart';
import 'package:deepple_app/app/widget/button/button.dart';
import 'package:deepple_app/features/home/domain/model/main_tab_type.dart';
import 'package:deepple_app/features/home/presentation/page/main_tab_view.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import 'package:deepple_app/app/constants/icon_path.dart';
import 'package:deepple_app/app/widget/icon/default_icon.dart';
import 'package:deepple_app/features/message_list/presentation/page/message_list_page.dart';

class EmptyMessage extends StatelessWidget {
  const EmptyMessage({super.key, required this.type});

  final MessageTabType type;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const DefaultIcon(IconPath.sadEmotion, size: 48.0),
        const Gap(8.0),
        Text(_content, textAlign: TextAlign.center),
        const Gap(22.0),
        DefaultOutlinedButton(
          child: Text(_buttonLabel),
          onPressed: () {
            switch (type) {
              case MessageTabType.received:
                navigate(context, route: AppRoute.profileManage);
                break;
              case MessageTabType.sent:
                context.moveToMainTabOf(MainTabType.home);
                break;
            }
          },
        ),
      ],
    );
  }

  String get _content => switch (type) {
    MessageTabType.received =>
      '아직 이성에게 받은 메시지가 없어요\n'
          '프로필을 조금 더 채워두면\n'
          '그 마음이 더 쉽게 닿을 거예요.\n',
    MessageTabType.sent =>
      '아직 이성에게 보낸 메시지가 없어요\n'
          '마음에 드는 이성이 있다면\n'
          '용기 내어 먼저 다가가보면 어떨까요?\n',
  };

  String get _buttonLabel => switch (type) {
    MessageTabType.received => '프로필 수정하러 가기',
    MessageTabType.sent => '프로필 살펴보기',
  };
}
