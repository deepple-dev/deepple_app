import 'package:deepple_app/app/constants/enum.dart';
import 'package:deepple_app/core/util/shared_preference/shared_preference_key.dart';
import 'package:deepple_app/core/util/shared_preference/shared_preference_manager.dart';
import 'package:deepple_app/features/home/presentation/provider/ideal_type_notifier.dart';
import 'package:deepple_app/features/introduce/domain/provider/filter_state.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'filter_notifier.g.dart';

@riverpod
class FilterNotifier extends _$FilterNotifier {
  @override
  FilterState build() {
    final idealState = ref.read(idealTypeProvider).value;

    final showAllGender = SharedPreferenceManager.getValue(
      SharedPreferenceKeys.showAllGender,
    );

    Gender? selectedGender = showAllGender == 1
        ? Gender.male
        : showAllGender == 2
        ? Gender.female
        : null;

    final preferredAgeStart =
        SharedPreferenceManager.getValue(
          SharedPreferenceKeys.preferredAgeStart,
        ) ??
        (idealState?.idealType.minAge ?? 20);

    final preferredAgeEnd =
        SharedPreferenceManager.getValue(
          SharedPreferenceKeys.preferredAgeEnd,
        ) ??
        (idealState?.idealType.maxAge ?? 46);

    final preferredCities =
        SharedPreferenceManager.getValue(
          SharedPreferenceKeys.preferredCities,
        ) ??
        [];

    return FilterState(
      rangeValues: RangeValues(
        preferredAgeStart.toDouble(),
        preferredAgeEnd.toDouble(),
      ),
      selectedCities: preferredCities,
      selectedGender: selectedGender,
    );
  }

  void updateFilter({
    required Gender? newGender,
    required List<String> newCities,
    required RangeValues newRange,
  }) {
    state = state.copyWith(
      selectedGender: newGender,
      selectedCities: newCities,
      rangeValues: newRange,
    );
    _saveFilter();
  }

  void _saveFilter() {
    SharedPreferenceManager.setValue(
      SharedPreferenceKeys.preferredAgeStart,
      state.rangeValues.start.toInt(),
    );
    SharedPreferenceManager.setValue(
      SharedPreferenceKeys.preferredAgeEnd,
      state.rangeValues.end.toInt(),
    );
    SharedPreferenceManager.setValue(
      SharedPreferenceKeys.preferredCities,
      state.selectedCities,
    );
    SharedPreferenceManager.setValue(
      SharedPreferenceKeys.showAllGender,
      state.selectedGender == Gender.male
          ? 1
          : state.selectedGender == Gender.female
          ? 2
          : 0,
    );
  }
}
