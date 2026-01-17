import 'package:deepple_app/app/constants/enum.dart';
import 'package:deepple_app/app/constants/region_data.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'filter_temp_state.freezed.dart';

@freezed
abstract class FilterTempState with _$FilterTempState {
  const FilterTempState._();

  String? get getGender => switch (selectedGender) {
    Gender.male => 'MALE',
    Gender.female => 'FEMALE',
    _ => null,
  };

  List<String> get selectedCitysEng => selectedCitys
      .map((label) => addressData.getCityByLabel(label).value)
      .toList();

  const factory FilterTempState({
    required RangeValues rangeValues,
    required List<String> selectedCitys,
    required Gender? selectedGender,
    required bool hasChanged,
  }) = _FilterState;

  // 초기 상태
  factory FilterTempState.initial() => const FilterTempState(
    rangeValues: RangeValues(27, 32),
    selectedCitys: [],
    selectedGender: null,
    hasChanged: false,
  );
}
