import 'package:deepple_app/app/router/route_arguments.dart';
import 'package:deepple_app/app/widget/button/button.dart';
import 'package:deepple_app/app/widget/text/bullet_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:deepple_app/app/constants/constants.dart';
import 'package:deepple_app/app/widget/icon/default_icon.dart';
import 'package:gap/gap.dart';
import 'package:deepple_app/app/router/router.dart';

class SignUpProfileRejectPage extends ConsumerWidget {
  const SignUpProfileRejectPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 12.0,
          ).copyWith(top: 24.0, bottom: Dimens.bottomPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                '프로필 심사 결과\n'
                '재심사가 필요합니다.',
                style: Fonts.header02().copyWith(
                  fontWeight: FontWeight.w700,
                  height: 1.2,
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const DefaultIcon(IconPath.sadEmotion, size: 48.0),
                          const Gap(8.0),
                          Text(
                            '프로필을 수정하신 뒤 다시 심사를 요청해 주세요.',
                            style: Fonts.body02Medium(),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      decoration: const BoxDecoration(
                        color: Palette.colorGrey50,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          BulletText(
                            texts: [
                              '제출해주신 프로필을 검토한 결과 일부 내용이 서비스 기준에 부합하지 않아 승인이 어려웠어요',
                              '커뮤니티 가이드를 참고해 프로필을 보완해주시면 다시 심사를 도와드릴게요',
                              '재심사가 완료 되면 푸시 알림을 통해 알려드려요',
                            ],
                            textStyle: Fonts.body03Regular(
                              Palette.colorGrey600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Gap(24.0),
              Row(
                spacing: 8.0,
                children: [
                  Expanded(
                    child: DefaultOutlinedButton(
                      child: const Text('커뮤니티 가이드'),
                      onPressed: () async {
                        navigate(context, route: AppRoute.communityGuide);
                      },
                    ),
                  ),
                  Expanded(
                    child: DefaultElevatedButton(
                      child: const Text('프로필 수정하기'),
                      onPressed: () async {
                        navigate(
                          context,
                          route: AppRoute.profileManage,
                          extra: const MyProfileManageArguments(
                            isRejectedProfile: true,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
