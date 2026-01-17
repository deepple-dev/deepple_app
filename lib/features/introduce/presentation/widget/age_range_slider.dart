import 'package:deepple_app/features/introduce/domain/provider/filter_temp_notifier.dart';
import 'package:flutter/material.dart';
import 'package:deepple_app/app/constants/palette.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AgeRangeSlider extends ConsumerWidget {
  const AgeRangeSlider({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final range = ref.watch(filterTempProvider).rangeValues;

    return RangeSlider(
      values: range,
      min: 20,
      max: 46,
      onChanged: (RangeValues values) {
        ref.read(filterTempProvider.notifier).updateRange(values);
      },
      activeColor: Palette.colorPrimary500,
      inactiveColor: Palette.colorGrey100,
    );
  }
}
