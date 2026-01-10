import 'package:deepple_app/app/widget/text/bullet_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:deepple_app/app/constants/constants.dart';
import 'package:deepple_app/app/widget/button/default_elevated_button.dart';
import 'package:deepple_app/app/widget/icon/default_icon.dart';
import 'package:gap/gap.dart';
import 'package:deepple_app/app/router/router.dart';

class SignUpProfileReviewPage extends ConsumerWidget {
  const SignUpProfileReviewPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.only(
            top: 24.0,
            left: 20.0,
            right: 20.0,
            bottom: Dimens.bottomPadding,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                '안전한 서비스를 위해\n'
                '작성하신 프로필을 심사 중이에요.',
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
                          const DefaultIcon(
                            IconPath.reviewProfileImage,
                            size: 128.0,
                          ),
                          const Gap(8.0),
                          Text(
                            '심사 완료 후, 서비스 이용이 활성화됩니다.',
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
                              '모두가 안심하고 만남을 이어갈 수 있도록 작성해주신 프로필을 현재 관리자가 꼼꼼히 확인 중에 있어요',
                              '서비스 이용 기준에 부적합한 내용이 있을 경우 가입이 제한될 수 있어요',
                              '심사는 최대한 빠르게 진행 중이며, 심사가 완료 되면 푸시 알림을 통해 알려드려요',
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
              DefaultElevatedButton(
                child: const Text('인터뷰 작성하고 하트 받아 가세요!'),
                onPressed: () async {
                  navigate(context, route: AppRoute.interview);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
