import 'package:deepple_app/app/constants/constants.dart';
import 'package:deepple_app/app/constants/region_data.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'filter_state.freezed.dart';

@freezed
abstract class FilterState with _$FilterState {
  const FilterState._();

  String? get getGender => switch (selectedGender) {
    Gender.male => 'MALE',
    Gender.female => 'FEMALE',
    _ => null,
  };

  List<String> get selectedCitiesEng => selectedCities
      .map((label) => addressData.getCityByLabel(label).value)
      .toList();

  const factory FilterState({
    required RangeValues rangeValues,
    required List<String> selectedCities,
    required Gender? selectedGender,
  }) = _FilterState;

  // 초기 상태
  factory FilterState.initial() => const FilterState(
    rangeValues: RangeValues(27, 32),
    selectedCities: [],
    selectedGender: null,
  );
}
