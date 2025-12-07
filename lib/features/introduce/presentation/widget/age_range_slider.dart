import 'package:flutter/material.dart';
import 'package:deepple_app/app/constants/palette.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:deepple_app/features/introduce/domain/provider/filter_notifier.dart';

class AgeRangeSlider extends ConsumerWidget {
  const AgeRangeSlider({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final RangeValues range = ref.watch(filterProvider).newRangeValues;

    return RangeSlider(
      values: range,
      min: 20,
      max: 46,
      onChanged: (RangeValues values) {
        ref.read(filterProvider.notifier).updateRange(values);
      },
      activeColor: Palette.colorPrimary500,
      inactiveColor: Palette.colorGrey100,
    );
  }
}
