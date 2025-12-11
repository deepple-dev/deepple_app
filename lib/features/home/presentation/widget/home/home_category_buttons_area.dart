import 'package:deepple_app/app/constants/enum.dart';
import 'package:deepple_app/app/constants/fonts.dart';
import 'package:deepple_app/app/constants/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

class HomeCategoryButtonsArea extends ConsumerWidget {
  final void Function(String category) onTapButton;
  const HomeCategoryButtonsArea({super.key, required this.onTapButton});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '이런 분들은 어떠세요? 🧐',
          style: Fonts.header03().copyWith(fontWeight: FontWeight.w600),
        ),
        const Gap(16),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 45.5, vertical: 24),
          decoration: BoxDecoration(
            color: Palette.colorGrey50,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: IntroducedCategory.values.map((value) {
              return ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Palette.colorBlack,
                  padding: const EdgeInsets.all(10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () => onTapButton(value.label),
                child: Text(
                  value.label,
                  style: Fonts.body02Regular().copyWith(
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
