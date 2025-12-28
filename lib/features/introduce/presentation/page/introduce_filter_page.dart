import 'package:deepple_app/app/provider/global_notifier.dart';
import 'package:deepple_app/app/widget/input/selection.dart';
import 'package:deepple_app/app/widget/widget.dart';
import 'package:deepple_app/features/introduce/domain/provider/filter_notifier.dart';
import 'package:deepple_app/features/introduce/presentation/widget/age_range_slider.dart';
import 'package:deepple_app/features/introduce/presentation/widget/row_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:deepple_app/app/constants/constants.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class IntroduceFilterPage extends ConsumerStatefulWidget {
  const IntroduceFilterPage({super.key});

  @override
  IntroduceFilterPageState createState() => IntroduceFilterPageState();
}

class IntroduceFilterPageState extends ConsumerState<IntroduceFilterPage> {
  static const String ALL = "전체 보기";
  static const String OPPOSITE = "이성만 보기";

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filterNotifer = ref.read(filterProvider.notifier);
    final isMale = ref.read(globalProvider).profile.isMale;
    final ageRange = ref.watch(filterProvider).newRangeValues;
    final selectedCityList = ref.watch(filterProvider).newSelectedCitys;
    final selectedGender = ref.watch(filterProvider).newSelectedGender;
    final hasChanged = ref.watch(filterProvider).hasChanged;

    return Scaffold(
      appBar: DefaultAppBar(
        title: '필터 설정',
        leadingAction: (context) {
          filterNotifer.initChangedState();
          if (!context.mounted) return;
          context.pop();
        },
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '나이',
                  style: Fonts.body02Medium(),
                ),
                Text(
                  "${ageRange.start.toInt()}세~${ageRange.end.toInt()}세",
                  style: Fonts.body02Regular(Palette.colorBlack),
                ),
              ],
            ),
          ),
          const AgeRangeSlider(),
          Gap(12.h),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                RowTextFormField(
                  label: '선호 지역',
                  textStyle: Fonts.body02Medium(),
                  hintText: '선호 지역을 선택해주세요',
                  initialValues: selectedCityList,
                  onSubmit: (updatedSelections) {
                    filterNotifer.updateCitys(updatedSelections);
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
                        filterNotifer.updateGender(null);
                      } else {
                        filterNotifer.updateGender(
                          isMale ? Gender.female : Gender.male,
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: DefaultElevatedButton(
              onPressed: hasChanged
                  ? () {
                      filterNotifer.saveFilter();
                      context.pop();
                    }
                  : null,
              child: const Text("필터 적용하기"),
            ),
          ),
        ],
      ),
    );
  }
}
