import 'package:deepple_app/app/constants/constants.dart';
import 'package:deepple_app/app/router/route_arguments.dart';
import 'package:deepple_app/app/router/router.dart';
import 'package:deepple_app/app/widget/widget.dart';
import 'package:deepple_app/features/my/my.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

final TextStyle _defaultHintStyle = Fonts.body02Medium().copyWith(
  color: const Color(0xffB4B8C0),
);

final TextStyle _blackHintStyle = Fonts.body02Medium().copyWith(
  color: Palette.colorBlack,
);

final List<String> _labels = ['닉네임', '나이', '키', '성별', '연락처'];

class ProfileManageBasicInfoArea extends StatelessWidget {
  final MyProfile profile;
  const ProfileManageBasicInfoArea({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 16.0,
        children: [
          Text(
            '기본 정보',
            style: Fonts.header03().copyWith(fontWeight: FontWeight.w600),
          ),
          Column(
            children: _labels.map((label) {
              final String value = switch (label) {
                '닉네임' => profile.nickname,
                '나이' => profile.age.toString(),
                '키' => '${profile.height}cm',
                '성별' => profile.gender.label,
                '연락처' => profile.phoneNum,
                _ => '',
              };
              return Column(
                children: [
                  buildLabeledRow(
                    label: label,
                    child: GestureDetector(
                      onTap: () {
                        if (label == '닉네임') {
                          navigate(
                            context,
                            route: AppRoute.profileUpdate,
                            extra: const MyProfileUpdateArguments(
                              profileType: '닉네임',
                            ),
                          );
                        } else if (label == '연락처') {
                          navigate(context, route: AppRoute.contactSetting);
                        }
                      },
                      child: DefaultTextFormField(
                        fillColor: Palette.colorGrey100,
                        readOnly: true,
                        hintText: value,
                        hintStyle: label == '닉네임' || label == '연락처'
                            ? _blackHintStyle
                            : _defaultHintStyle,
                      ),
                    ),
                    context: context,
                  ),
                  const Gap(24),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
