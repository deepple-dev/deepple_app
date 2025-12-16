import 'package:deepple_app/app/constants/constants.dart';
import 'package:deepple_app/features/home/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

class IdealAgeSettingArea extends ConsumerWidget {
  const IdealAgeSettingArea({
    super.key,
    required this.minAge,
    required this.maxAge,
  });

  final int minAge;
  final int maxAge;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final idealTypeNotifier = ref.read(idealTypeProvider.notifier);

    return IdealAgeSlider(
      minAge: minAge,
      maxAge: maxAge,
      onChanged: idealTypeNotifier.updateAgeRange,
    );
  }
}

class IdealAgeSlider extends StatelessWidget {
  final int minAge;
  final int maxAge;
  final void Function(int start, int end)? onChanged;

  const IdealAgeSlider({
    super.key,
    required this.minAge,
    required this.maxAge,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '나이',
                style: Fonts.body02Regular().copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                '$minAge세~$maxAge세',
                style: Fonts.body02Regular().copyWith(
                  fontWeight: FontWeight.w500,
                  color: const Color(0xff3B3B3B),
                ),
              ),
            ],
          ),
        ),
        const Gap(20),
        Row(
          children: [
            Expanded(
              child: RangeSlider(
                values: RangeValues(
                  minAge
                      .clamp(Dimens.minSelectableAge, Dimens.maxSelectableAge)
                      .toDouble(),
                  maxAge
                      .clamp(Dimens.minSelectableAge, Dimens.maxSelectableAge)
                      .toDouble(),
                ),
                min: Dimens.minSelectableAge.toDouble(),
                max: Dimens.maxSelectableAge.toDouble(),
                onChanged: onChanged != null
                    ? (values) =>
                          onChanged!(values.start.toInt(), values.end.toInt())
                    : null,
                activeColor: Palette.colorPrimary500,
                inactiveColor: const Color(0xffEEEEEE),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
