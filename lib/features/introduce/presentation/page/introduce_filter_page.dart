import 'package:deepple_app/app/provider/global_notifier.dart';
import 'package:deepple_app/app/widget/input/selection.dart';
import 'package:deepple_app/app/widget/widget.dart';
import 'package:deepple_app/features/introduce/introduce.dart';
import 'package:deepple_app/features/introduce/presentation/widget/age_range_slider.dart';
import 'package:deepple_app/features/introduce/presentation/widget/row_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:deepple_app/app/constants/constants.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class IntroduceFilterPage extends ConsumerStatefulWidget {
  const IntroduceFilterPage({super.key});

  @override
  ConsumerState<IntroduceFilterPage> createState() =>
      _IntroduceFilterPageState();
}

class _IntroduceFilterPageState extends ConsumerState<IntroduceFilterPage> {
  late RangeValues _initialAgeRange;
  List<String> _initialSelectedCityList = [];
  late Gender? _initialSelectedGender;
  late RangeValues _ageRange;
  List<String> _selectedCityList = [];
  late Gender? _selectedGender;
  bool _isMale = false;
  bool hasChanged = false;

  @override
  void initState() {
    super.initState();

    final filterState = ref.read(filterProvider);
    _initialAgeRange = filterState.rangeValues;

    _initialSelectedCityList = List<String>.of(filterState.selectedCities);
    _initialSelectedGender = filterState.selectedGender;

    _ageRange = _initialAgeRange;
    _selectedCityList = _initialSelectedCityList;
    _selectedGender = _initialSelectedGender;

    _isMale = ref.read(globalProvider).profile.isMale;
  }

  @override
  Widget build(BuildContext context) {
    final all = IntroduceFilter.all.label;
    final opposite = IntroduceFilter.opposite.label;

    return Scaffold(
      appBar: DefaultAppBar(
        title: '필터 설정',
        leadingAction: (context) {
          // 필터 원상복귀
          Navigator.of(context).pop();
        },
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('나이', style: Fonts.body02Medium()),
                Text(
                  '${_ageRange.start.toInt()}세~${_ageRange.end.toInt()}세',
                  style: Fonts.body02Regular(Palette.colorBlack),
                ),
              ],
            ),
          ),
          AgeRangeSlider(
            ageRange: _ageRange,
            onChanged: (newAgeRange) {
              setState(() {
                _ageRange = newAgeRange;
                hasChanged = true;
              });
            },
          ),
          Gap(12.h),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                RowTextFormField(
                  label: '선호 지역',
                  textStyle: Fonts.body02Medium(),
                  hintText: '선호 지역을 선택해주세요',
                  initialValue: _selectedCityList.isNotEmpty
                      ? _selectedCityList.join(', ')
                      : null,
                  selectedCityList: _selectedCityList,
                  onSelectedCity: (newSelectedList) {
                    setState(() {
                      _selectedCityList = newSelectedList;
                      hasChanged = true;
                    });
                  },
                ),

                Gap(24.h),
                buildLabeledRow(
                  context: context,
                  label: '성별',
                  textStyle: Fonts.body02Medium(),
                  child: SelectionWidget(
                    options: [all, opposite],
                    initialOptions: _selectedGender == null ? all : opposite,
                    onChange: (str) {
                      if (str == all) {
                        _selectedGender = null;
                      } else {
                        _selectedGender = _isMale ? Gender.female : Gender.male;
                      }
                      setState(() {
                        hasChanged = true;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: Dimens.bottomPadding,
            ),
            child: DefaultElevatedButton(
              onPressed: hasChanged
                  ? () {
                      ref
                          .read(filterProvider.notifier)
                          .updateFilter(
                            newGender: _selectedGender,
                            newCities: _selectedCityList,
                            newRange: _ageRange,
                          );
                      Navigator.of(context).pop();
                    }
                  : null,
              child: Text(
                '필터 적용하기',
                style: Fonts.bold(
                  fontSize: 14,
                  color: hasChanged ? Palette.colorWhite : Palette.colorGrey300,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
