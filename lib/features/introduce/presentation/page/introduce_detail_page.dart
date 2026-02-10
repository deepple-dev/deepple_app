import 'package:deepple_app/app/constants/region_data.dart';
import 'package:deepple_app/app/provider/provider.dart';
import 'package:deepple_app/app/widget/image/rounded_image.dart';
import 'package:deepple_app/core/state/base_page_state.dart';
import 'package:deepple_app/app/widget/view/default_app_bar.dart';
import 'package:deepple_app/app/widget/button/default_elevated_button.dart';
import 'package:deepple_app/core/util/toast.dart';
import 'package:deepple_app/features/introduce/domain/model/introduce_detail.dart';
import 'package:deepple_app/features/introduce/domain/provider/introduce_detail_notifier.dart';
import 'package:deepple_app/features/introduce/presentation/widget/profile_exchange_dialog.dart';
import 'package:flutter/material.dart';
import 'package:deepple_app/app/constants/constants.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:deepple_app/app/widget/chip/default_chip.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class IntroduceDetailPage extends ConsumerStatefulWidget {
  final int introduceId;
  const IntroduceDetailPage({super.key, required this.introduceId});

  @override
  IntroduceDetailPageState createState() => IntroduceDetailPageState();
}

// 상대방 프로필 조회
// yes -> 프로필 보여줘
// no -> 셀프소개 상세 조회 시작

class IntroduceDetailPageState
    extends AppBaseConsumerStatefulPageState<IntroduceDetailPage> {
  @override
  Widget buildPage(BuildContext context) {
    final double horizontalPadding = screenWidth * 0.05;

    final stateAsync = ref.watch(
      introduceDetailProvider(introduceId: widget.introduceId),
    );
    final notifier = ref.read(
      introduceDetailProvider(introduceId: widget.introduceId).notifier,
    );

    final myGender = ref.read(globalProvider).profile.gender;

    return Scaffold(
      appBar: const DefaultAppBar(title: '상대방 정보'),
      body: stateAsync.when(
        data: (data) {
          if (data.introduceDetail == null) {
            // TODO: 에러 처리
            showToastMessage('상대방 정보를 불러오는데 실패했습니다.');
            return const SizedBox.shrink();
          }

          final introduceDetail = data.introduceDetail!;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _IntroduceProfileSection(
                introduceDetail: introduceDetail,
                myGender: myGender,
                heartPoint: data.heartPoint,
                horizontalPadding: horizontalPadding,
                notifier: notifier,
              ),
              Expanded(
                child: _IntroduceContentSection(
                  introduceDetail: introduceDetail,
                  horizontalPadding: horizontalPadding,
                ),
              ),
            ],
          );
        },
        error: (error, stackTrace) {
          return Center(child: Text('Error: $error'));
        },
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}

class _IntroduceProfileSection extends StatelessWidget {
  final IntroduceDetail introduceDetail;
  final Gender myGender;
  final int heartPoint;
  final double horizontalPadding;
  final IntroduceDetailNotifier notifier;

  const _IntroduceProfileSection({
    required this.introduceDetail,
    required this.myGender,
    required this.heartPoint,
    required this.horizontalPadding,
    required this.notifier,
  });

  @override
  Widget build(BuildContext context) {
    final member = introduceDetail.memberBasicInfo;
    final location = addressData.getLocationString(
      member.city,
      member.district,
    );
    final hobbies = member.hobbies
        .map((hobby) => Hobby.parse(hobby).label)
        .toList();

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: 10.0,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              RoundedImage(imageURL: member.profileImageUrl, size: 100),
              const Gap(16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${member.nickname}, ${member.age}',
                      style: Fonts.header02(const Color(0xFF1F1E23)),
                    ),
                    const Gap(6),
                    Text(
                      '${member.mbti} · $location',
                      style: Fonts.body02Regular(Palette.colorGrey600),
                    ),
                    const Gap(6),
                    SizedBox(height: 2.h),
                    DefaultChip(titleList: hobbies),
                  ],
                ),
              ),
            ],
          ),
          const Gap(16),
          if (myGender != member.gender)
            switch (introduceDetail.profileExchangeStatus) {
              ProfileExchangeStatus.none => _InteractionButton('프로필 교환하기', () {
                ProfileExchangeDialog.open(
                  context,
                  myHeartPoint: heartPoint,
                  onSendExchange: () {
                    // 프로필 교환 보내기
                    notifier.requestProfileExchange(member.memberId);
                    Navigator.of(context).pop();
                  },
                );
              }),
              ProfileExchangeStatus.rejected => const _WaitingButton(
                '상대방이 프로필 교환을 거절하셨습니다',
              ),
              _ => const _WaitingButton('상대방의 수락을 기다리고 있어요'),
            },
        ],
      ),
    );
  }
}

class _IntroduceContentSection extends StatelessWidget {
  final IntroduceDetail introduceDetail;
  final double horizontalPadding;

  const _IntroduceContentSection({
    required this.introduceDetail,
    required this.horizontalPadding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Palette.colorGrey100,
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: 12.0,
          ),
          child: Container(
            decoration: const BoxDecoration(
              color: Palette.colorWhite,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(16.0),
                bottom: Radius.circular(16.0),
              ),
            ),
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding,
              vertical: 20.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  introduceDetail.title,
                  style: Fonts.semibold(
                    color: Palette.colorBlack,
                    fontSize: 16.sp,
                  ),
                ),
                const Gap(12),
                Text(
                  introduceDetail.content,
                  style: Fonts.regular(
                    color: Palette.colorGrey600,
                    fontSize: 14.sp,
                    lineHeight: 1.5.h,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _InteractionButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const _InteractionButton(this.text, this.onPressed);

  @override
  Widget build(BuildContext context) {
    return DefaultElevatedButton(
      height: 40,
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      onPressed: onPressed,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [Text(text, style: Fonts.body02Medium(Colors.white))],
      ),
    );
  }
}

class _WaitingButton extends StatelessWidget {
  final String text;

  const _WaitingButton(this.text);

  @override
  Widget build(BuildContext context) {
    return DefaultElevatedButton(
      height: 40,
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      onPressed: null,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [Text(text, style: Fonts.body02Medium(Colors.white))],
      ),
    );
  }
}
