import 'package:deepple_app/app/widget/list/list_chip.dart';
import 'package:deepple_app/features/introduce/domain/provider/filter_temp_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:deepple_app/app/constants/constants.dart';
import 'package:deepple_app/app/widget/button/button.dart';
import 'package:deepple_app/features/introduce/domain/provider/filter_notifier.dart';

class Regionselectdialog extends ConsumerWidget {
  const Regionselectdialog({super.key});

  static const List<String> _cityList = [
    '서울',
    '인천',
    '부산',
    '대전',
    '대구',
    '광주',
    '울산',
    '제주',
    '세종',
    '강원도',
    '경기도',
    '경상남도',
    '경상북도',
    '충청남도',
    '충청북도',
    '전라남도',
    '전라북도',
  ];

  static Future open(BuildContext context) => showDialog(
    context: context,
    builder: (context) => const Regionselectdialog(),
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCityList = ref.watch(filterTempProvider).selectedCitys;

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16.0),
      shape: const RoundedRectangleBorder(borderRadius: Dimens.dialogRadius),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          spacing: 20.0,
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              spacing: 14.0,
              children: [
                Text(
                  '지역',
                  style: Fonts.header03().copyWith(
                    fontWeight: FontWeight.w600,
                    color: Palette.colorBlack,
                  ),
                ),
                Text(
                  '최대 2개 선택이 가능해요',
                  style: Fonts.body02Regular().copyWith(
                    color: Palette.colorGrey500,
                  ),
                ),
                ListChip(
                  options: _cityList,
                  selectedOptions: selectedCityList,
                  onSelectionChanged: (updatedSelections) {
                    if (updatedSelections.length > 2) return;
                    ref
                        .read(filterTempProvider.notifier)
                        .updateCitys(updatedSelections);
                  },
                ),
              ],
            ),
            DefaultElevatedButton(
              onPressed: Navigator.of(context).pop,
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: const Text('확인'),
            ),
          ],
        ),
      ),
    );
  }
}
