import 'package:flutter/material.dart';
import 'package:deepple_app/app/constants/palette.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AgeRangeSlider extends ConsumerWidget {
  final RangeValues ageRange;
  final void Function(RangeValues) onChanged;
  const AgeRangeSlider({
    super.key,
    required this.ageRange,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return RangeSlider(
      values: ageRange,
      min: 20,
      max: 46,
      onChanged: onChanged,
      activeColor: Palette.colorPrimary500,
      inactiveColor: Palette.colorGrey100,
    );
  }
}
