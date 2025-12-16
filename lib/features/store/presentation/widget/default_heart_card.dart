import 'package:deepple_app/core/extension/extension.dart';
import 'package:flutter/material.dart';
import 'package:deepple_app/app/constants/constants.dart';
import 'package:deepple_app/app/widget/button/button.dart';
import 'package:deepple_app/app/widget/icon/default_icon.dart';
import 'package:gap/gap.dart';

class DefaultHeartCard extends StatelessWidget {
  const DefaultHeartCard({
    super.key,
    required this.heart,
    required this.price,
    required this.code,
    required this.onCreate,
  });

  final String heart;
  final String price;
  final String code;
  final void Function(String code) onCreate;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Palette.colorGrey50,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          const DefaultIcon(IconPath.storeHeart, size: 16),
          const Gap(1),
          Text(heart, style: Fonts.numeric01Bold()),
          const Gap(2),
          Text('₩${price.formatThousands}', style: Fonts.numeric01Medium()),
          const Gap(2),
          const Gap(24),
          DefaultElevatedButton(
            onPressed: () => onCreate(code),
            height: 34.0,
            padding: const EdgeInsets.only(top: 3.0),
            child: Text(
              '구매하기',
              style: Fonts.body03Regular().copyWith(color: Palette.colorWhite),
            ),
          ),
        ],
      ),
    );
  }
}
