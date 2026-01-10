import 'dart:async';

import 'package:deepple_app/app/constants/constants.dart';
import 'package:deepple_app/app/router/router.dart';
import 'package:deepple_app/app/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class TemporalForbiddenPage extends StatefulWidget {
  const TemporalForbiddenPage({super.key, this.suspensionExpireAt});

  final DateTime? suspensionExpireAt;

  @override
  State<TemporalForbiddenPage> createState() => _TemporalForbiddenPageState();
}

class _TemporalForbiddenPageState extends State<TemporalForbiddenPage> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(minutes: 1), (_) {
      if (!mounted) return;
      setState(() {}); // 1분마다 UI 갱신
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final remainingDuration = getRemainingDuration(widget.suspensionExpireAt);
    final isReleased =
        remainingDuration != null &&
        formatRemainingTime(remainingDuration) == '00시간 00분';

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.only(
            left: 12.0,
            right: 12.0,
            bottom: Dimens.bottomPadding,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Gap(24),
              Text(
                '커뮤니티 가이드 위반으로\n이용 제한 중입니다.',
                style: Fonts.header02().copyWith(
                  color: Palette.colorBlack,
                  fontWeight: FontWeight.w700,
                  height: 1.2,
                ),
              ),
              const Spacer(),
              Column(
                children: [
                  const DefaultIcon(IconPath.sadEmotion, size: 48.0),
                  Text(
                    '회원님의 계정은 3일동안\n서비스 이용이 제한되어 있습니다.',
                    style: Fonts.body02Medium().copyWith(
                      color: Palette.colorBlack,
                      fontWeight: FontWeight.w400,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              const Spacer(),
              DefaultElevatedButton(
                primary: isReleased
                    ? Palette.colorPrimary500
                    : Palette.colorGrey200,
                onPressed: isReleased
                    ? () {
                        navigate(
                          context,
                          route: AppRoute.communityGuide,
                          method: NavigationMethod.go,
                        );
                      }
                    : null,
                child: Text(
                  remainingDuration == null
                      ? '가이드라인 확인 후 시작하기'
                      : formatRemainingTime(remainingDuration) == '00시간 00분'
                      ? '가이드라인 확인 후 시작하기'
                      : '남은 시간 : ${formatRemainingTime(remainingDuration)}',
                  style: Fonts.body01Medium().copyWith(
                    color: Palette.colorWhite,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Duration? getRemainingDuration(DateTime? suspensionExpirAt) {
    if (suspensionExpirAt == null) return null;

    final now = DateTime.now();

    final diff = suspensionExpirAt.difference(now);

    if (diff.isNegative) return Duration.zero;
    return diff;
  }

  String formatRemainingTime(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);

    return '${hours.toString().padLeft(2, '0')}시간 '
        '${minutes.toString().padLeft(2, '0')}분';
  }
}
