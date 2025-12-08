import 'package:deepple_app/app/constants/constants.dart';
import 'package:deepple_app/app/router/route_arguments.dart';
import 'package:deepple_app/app/router/router.dart';
import 'package:deepple_app/app/widget/button/button.dart';
import 'package:deepple_app/app/widget/input/default_text_form_field.dart';
import 'package:deepple_app/features/my/my.dart';
import 'package:flutter/material.dart';
import 'package:deepple_app/features/auth/data/usecase/auth_usecase_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

const List<String> _labels = [
  '직업',
  '지역',
  '학력',
  '흡연여부',
  '음주빈도',
  '종교',
  'MBTI',
  '취미',
];

class ProfileManageInfoArea extends ConsumerWidget {
  const ProfileManageInfoArea({
    super.key,
    required this.profile,
    required this.isRejectedProfile,
  });

  final MyProfile profile;
  final bool isRejectedProfile;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.5, vertical: 24),
      decoration: const BoxDecoration(color: Palette.colorGrey50),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DefaultElevatedButton(
            child: Text(
              isRejectedProfile ? '재심사 요청하기' : '프로필 미리보기',
              style: Fonts.body01Regular().copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
            onPressed: () async {
              if (isRejectedProfile) {
                final authUseCase = ref.read(authUsecaseProvider);
                await authUseCase.rescreenProfile();
                navigate(context, route: AppRoute.signUpProfileReview);
                return;
              }

              navigate(
                context,
                route: AppRoute.profilePreview,
                extra: ProfilePreviewArguments(profile: profile),
              );
            },
          ),
          const Gap(24),
          Text(
            '프로필 정보',
            style: Fonts.header03().copyWith(fontWeight: FontWeight.w600),
          ),
          const Gap(16),
          Column(
            children: _labels.map((label) {
              final String displayValue = switch (label) {
                '직업' => profile.job.label,
                '지역' => profile.region,
                '학력' => profile.education.label,
                '흡연여부' => profile.smokingStatus.label,
                '음주빈도' => profile.drinkingStatus.label,
                '종교' => profile.religion.label,
                'MBTI' => profile.mbti,
                '취미' => profile.hobbies.map((hobby) => hobby.label).join(', '),
                _ => '',
              };
              return Column(
                children: [
                  buildLabeledRow(
                    label: label,
                    child: GestureDetector(
                      onTap: () => navigate(
                        context,
                        route: AppRoute.profileUpdate,
                        extra: MyProfileUpdateArguments(profileType: label),
                      ),
                      child: DefaultTextFormField(
                        hintText: displayValue,
                        hintStyle: Fonts.body02Medium().copyWith(
                          color: Palette.colorBlack,
                        ),
                        fillColor: Palette.colorGrey100,
                        readOnly: true,
                      ),
                    ),
                    context: context,
                  ),
                  const Gap(24),
                ],
              );
            }).toList(),
          ),
          const Gap(8),
          DefaultOutlinedButton(
            expandedWidth: true,
            onPressed: () {
              navigate(context, route: AppRoute.interview);
            },
            child: const Text('인터뷰 수정하기'),
          ),
          ProfileManageBasicInfoArea(profile: profile),
        ],
      ),
    );
  }
}
