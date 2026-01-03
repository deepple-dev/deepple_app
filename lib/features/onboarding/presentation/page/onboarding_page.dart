import 'package:flutter/material.dart';

import 'package:deepple_app/core/state/base_page_state.dart';
import 'package:deepple_app/app/widget/overlay/bubble.dart';
import 'package:deepple_app/app/router/router.dart';
import 'package:deepple_app/app/constants/constants.dart';
import 'package:deepple_app/app/widget/button/default_elevated_button.dart';
import 'package:deepple_app/features/onboarding/presentation/widget/balloon_animation_widget.dart';

class OnBoardPage extends StatefulWidget {
  const OnBoardPage({super.key});

  @override
  State<OnBoardPage> createState() => _OnBoardPageState();
}

class _OnBoardPageState extends AppBaseStatefulPageBase<OnBoardPage> {
  final List<Map<String, dynamic>> balloons = [
    {'text': '진정한 사랑, 연인', 'color': const Color.fromARGB(255, 206, 233, 255)},
    {'text': '나에게 사랑이란?', 'color': const Color.fromARGB(255, 241, 192, 255)},
    {'text': '같은 생각, 같은 마음', 'color': const Color(0xFFFF97CA)},
    {'text': '사랑의 시작', 'color': const Color.fromARGB(255, 192, 201, 227)},
    {'text': '나와 잘 맞는 사람', 'color': const Color(0xFF30D0A7)},
    {'text': '추구하는 美', 'color': const Color.fromARGB(255, 255, 181, 210)},
    {'text': '#나의 생각 #마음', 'color': const Color(0xFFFF5C5D)},
    {'text': '사랑, 가치관에서 시작된다.', 'color': const Color(0xFF9ECEFD)},
    {'text': '세상에서 가장 편한 사람', 'color': const Color(0xFFFFE4AF)},
    {'text': '#힘들 때 #내 곁에', 'color': const Color(0xFFFBD4D3)},
    {'text': '#즐거운 순간은 #함께', 'color': const Color(0xFFA9DFDA)},
    {'text': '만남의 시작', 'color': const Color(0xFFFF5219)},
    {'text': '인연의 시작', 'color': const Color(0xFF81DF79)},
    {'text': '만남부터 차근차근', 'color': const Color(0xFF1FCF69)},
    {'text': '행복한 미래', 'color': const Color(0xFF5AA4D2)},
    {'text': '영원한 내 편', 'color': const Color(0xFFC478D3)},
    {'text': '소중한 사람과의 시간', 'color': const Color(0xFF73C2FB)},
    {'text': '내 마음의 평온', 'color': const Color.fromARGB(255, 255, 211, 242)},
    {'text': '작은 행복의 시작', 'color': const Color(0xFF9370DB)},
    {'text': '지금 이 순간의 즐거움', 'color': const Color.fromARGB(255, 255, 146, 201)},
  ];

  @override
  Widget buildPage(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(flex: 7, child: BalloonAnimationWidget(balloons: balloons)),
          Expanded(
            flex: 3,
            child: Padding(
              padding: EdgeInsets.all(screenWidth * 0.05),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: bubbleWidget(
                      comment: '회원가입하고 포인트 선물받기',
                      boldText: '포인트 선물',
                      width: screenWidth * 0.5,
                      textStyle: Fonts.body03Regular(),
                      shadowColor: Palette.colorGrey200,
                    ),
                  ),
                  DefaultElevatedButton(
                    primary: palette.primary,
                    onPressed: () async {
                      navigate(context, route: AppRoute.onboardPhone);
                    },
                    child: Text(
                      '전화번호로 시작하기',
                      style: Fonts.body01Regular(palette.onPrimary),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '만 18세 이상만 이용 가능하며 회원가입 시\n'
                    '이용약관, 개인정보처리방침에 동의하게 됩니다.',
                    textAlign: TextAlign.center,
                    style: Fonts.body03Regular().copyWith(
                      color: Palette.colorGrey400,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
