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
  static const String ALL = '전체 보기';
  static const String OPPOSITE = '이성만 보기';

  late RangeValues initialAgeRange;
  List<String> initialSelectedCityList = [];
  late Gender? initialSelectedGender;
  late RangeValues ageRange;
  List<String> selectedCityList = [];
  late Gender? selectedGender;
  bool isMale = false;

  bool hasChanged = false;

  @override
  void initState() {
    super.initState();

    final filterState = ref.read(filterProvider);
    initialAgeRange = filterState.rangeValues;

    initialSelectedCityList = List<String>.of(filterState.selectedCities);
    initialSelectedGender = filterState.selectedGender;

    ageRange = initialAgeRange;
    selectedCityList = initialSelectedCityList;
    selectedGender = initialSelectedGender;

    isMale = ref.read(globalProvider).profile.isMale;
  }

  @override
  Widget build(BuildContext context) {
    print('hasChanged $hasChanged');
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
                  '${ageRange.start.toInt()}세~${ageRange.end.toInt()}세',
                  style: Fonts.body02Regular(Palette.colorBlack),
                ),
              ],
            ),
          ),
          AgeRangeSlider(
            ageRange: ageRange,
            onChanged: (newAgeRange) {
              setState(() {
                ageRange = newAgeRange;
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
                  initialValue: selectedCityList.isNotEmpty
                      ? selectedCityList.join(', ')
                      : null,
                  selectedCityList: selectedCityList,
                  onSelectedCity: (newSelectedList) {
                    setState(() {
                      selectedCityList = newSelectedList;
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
                    options: [ALL, OPPOSITE],
                    initialOptions: selectedGender == null ? ALL : OPPOSITE,
                    onChange: (str) {
                      if (str == ALL) {
                        selectedGender = null;
                      } else {
                        selectedGender = isMale ? Gender.female : Gender.male;
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
                            newGender: selectedGender,
                            newCities: selectedCityList,
                            newRange: ageRange,
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
