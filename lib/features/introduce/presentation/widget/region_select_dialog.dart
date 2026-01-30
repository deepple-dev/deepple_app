import 'package:deepple_app/app/widget/list/list_chip.dart';
import 'package:flutter/material.dart';
import 'package:deepple_app/app/constants/constants.dart';
import 'package:deepple_app/app/widget/button/button.dart';

class RegionSelectDialog extends StatefulWidget {
  final List<String> selectedCityList;
  const RegionSelectDialog({super.key, required this.selectedCityList});

  @override
  State<RegionSelectDialog> createState() => _RegionSelectDialogState();

  static Future open(BuildContext context, List<String> selectedCityList) =>
      showDialog<List<String>?>(
        context: context,
        builder: (context) =>
            RegionSelectDialog(selectedCityList: selectedCityList),
      );
}

class _RegionSelectDialogState extends State<RegionSelectDialog> {
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

  List<String> selectedCityList = [];

  @override
  void initState() {
    super.initState();
    selectedCityList = List<String>.of(widget.selectedCityList);
  }

  @override
  Widget build(BuildContext context) {
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

                    setState(() {
                      selectedCityList = updatedSelections;
                    });
                  },
                ),
              ],
            ),
            DefaultElevatedButton(
              onPressed: () => Navigator.of(context).pop(selectedCityList),
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: const Text('확인'),
            ),
          ],
        ),
      ),
    );
  }
}
