import 'package:deepple_app/app/constants/enum.dart';
import 'package:deepple_app/core/util/shared_preference/shared_preference_key.dart';
import 'package:deepple_app/core/util/shared_preference/shared_preference_manager.dart';
import 'package:deepple_app/features/introduce/domain/provider/filter_notifier.dart';
import 'package:deepple_app/features/introduce/domain/provider/filter_state.dart';
import 'package:deepple_app/features/introduce/domain/provider/filter_temp_state.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'filter_temp_notifier.g.dart';

@riverpod
class FilterTempNotifier extends _$FilterTempNotifier {
  @override
  FilterTempState build() {
    FilterState filterState = ref.read(filterProvider);

    return FilterTempState(
      rangeValues: filterState.rangeValues,
      selectedCitys: filterState.selectedCitys,
      selectedGender: filterState.selectedGender,
      hasChanged: false,
    );
  }

  void updateRange(RangeValues values) {
    state = state.copyWith(rangeValues: values, hasChanged: true);
  }

  void updateCitys(List<String> citys) {
    state = state.copyWith(selectedCitys: citys, hasChanged: true);
  }

  void updateGender(Gender? gender) {
    state = state.copyWith(selectedGender: gender, hasChanged: true);
  }

  void updateChanged(bool hasChanged) {
    state = state.copyWith(hasChanged: hasChanged);
  }

  void saveFilter() {
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
      state.selectedCitys,
    );
    SharedPreferenceManager.setValue(
      SharedPreferenceKeys.showAllGender,
      state.selectedGender == Gender.male
          ? 1
          : state.selectedGender == Gender.female
          ? 2
          : 0,
    );

    state = state.copyWith(hasChanged: false);
  }
}
