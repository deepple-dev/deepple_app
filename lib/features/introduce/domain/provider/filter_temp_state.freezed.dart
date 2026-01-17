// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'filter_temp_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$FilterTempState {

 RangeValues get rangeValues; List<String> get selectedCitys; Gender? get selectedGender; bool get hasChanged;
/// Create a copy of FilterTempState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FilterTempStateCopyWith<FilterTempState> get copyWith => _$FilterTempStateCopyWithImpl<FilterTempState>(this as FilterTempState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FilterTempState&&(identical(other.rangeValues, rangeValues) || other.rangeValues == rangeValues)&&const DeepCollectionEquality().equals(other.selectedCitys, selectedCitys)&&(identical(other.selectedGender, selectedGender) || other.selectedGender == selectedGender)&&(identical(other.hasChanged, hasChanged) || other.hasChanged == hasChanged));
}


@override
int get hashCode => Object.hash(runtimeType,rangeValues,const DeepCollectionEquality().hash(selectedCitys),selectedGender,hasChanged);

@override
String toString() {
  return 'FilterTempState(rangeValues: $rangeValues, selectedCitys: $selectedCitys, selectedGender: $selectedGender, hasChanged: $hasChanged)';
}


}

/// @nodoc
abstract mixin class $FilterTempStateCopyWith<$Res>  {
  factory $FilterTempStateCopyWith(FilterTempState value, $Res Function(FilterTempState) _then) = _$FilterTempStateCopyWithImpl;
@useResult
$Res call({
 RangeValues rangeValues, List<String> selectedCitys, Gender? selectedGender, bool hasChanged
});




}
/// @nodoc
class _$FilterTempStateCopyWithImpl<$Res>
    implements $FilterTempStateCopyWith<$Res> {
  _$FilterTempStateCopyWithImpl(this._self, this._then);

  final FilterTempState _self;
  final $Res Function(FilterTempState) _then;

/// Create a copy of FilterTempState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? rangeValues = null,Object? selectedCitys = null,Object? selectedGender = freezed,Object? hasChanged = null,}) {
  return _then(_self.copyWith(
rangeValues: null == rangeValues ? _self.rangeValues : rangeValues // ignore: cast_nullable_to_non_nullable
as RangeValues,selectedCitys: null == selectedCitys ? _self.selectedCitys : selectedCitys // ignore: cast_nullable_to_non_nullable
as List<String>,selectedGender: freezed == selectedGender ? _self.selectedGender : selectedGender // ignore: cast_nullable_to_non_nullable
as Gender?,hasChanged: null == hasChanged ? _self.hasChanged : hasChanged // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [FilterTempState].
extension FilterTempStatePatterns on FilterTempState {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FilterState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FilterState() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FilterState value)  $default,){
final _that = this;
switch (_that) {
case _FilterState():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FilterState value)?  $default,){
final _that = this;
switch (_that) {
case _FilterState() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( RangeValues rangeValues,  List<String> selectedCitys,  Gender? selectedGender,  bool hasChanged)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FilterState() when $default != null:
return $default(_that.rangeValues,_that.selectedCitys,_that.selectedGender,_that.hasChanged);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( RangeValues rangeValues,  List<String> selectedCitys,  Gender? selectedGender,  bool hasChanged)  $default,) {final _that = this;
switch (_that) {
case _FilterState():
return $default(_that.rangeValues,_that.selectedCitys,_that.selectedGender,_that.hasChanged);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( RangeValues rangeValues,  List<String> selectedCitys,  Gender? selectedGender,  bool hasChanged)?  $default,) {final _that = this;
switch (_that) {
case _FilterState() when $default != null:
return $default(_that.rangeValues,_that.selectedCitys,_that.selectedGender,_that.hasChanged);case _:
  return null;

}
}

}

/// @nodoc


class _FilterState extends FilterTempState {
  const _FilterState({required this.rangeValues, required final  List<String> selectedCitys, required this.selectedGender, required this.hasChanged}): _selectedCitys = selectedCitys,super._();
  

@override final  RangeValues rangeValues;
 final  List<String> _selectedCitys;
@override List<String> get selectedCitys {
  if (_selectedCitys is EqualUnmodifiableListView) return _selectedCitys;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_selectedCitys);
}

@override final  Gender? selectedGender;
@override final  bool hasChanged;

/// Create a copy of FilterTempState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FilterStateCopyWith<_FilterState> get copyWith => __$FilterStateCopyWithImpl<_FilterState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FilterState&&(identical(other.rangeValues, rangeValues) || other.rangeValues == rangeValues)&&const DeepCollectionEquality().equals(other._selectedCitys, _selectedCitys)&&(identical(other.selectedGender, selectedGender) || other.selectedGender == selectedGender)&&(identical(other.hasChanged, hasChanged) || other.hasChanged == hasChanged));
}


@override
int get hashCode => Object.hash(runtimeType,rangeValues,const DeepCollectionEquality().hash(_selectedCitys),selectedGender,hasChanged);

@override
String toString() {
  return 'FilterTempState(rangeValues: $rangeValues, selectedCitys: $selectedCitys, selectedGender: $selectedGender, hasChanged: $hasChanged)';
}


}

/// @nodoc
abstract mixin class _$FilterStateCopyWith<$Res> implements $FilterTempStateCopyWith<$Res> {
  factory _$FilterStateCopyWith(_FilterState value, $Res Function(_FilterState) _then) = __$FilterStateCopyWithImpl;
@override @useResult
$Res call({
 RangeValues rangeValues, List<String> selectedCitys, Gender? selectedGender, bool hasChanged
});




}
/// @nodoc
class __$FilterStateCopyWithImpl<$Res>
    implements _$FilterStateCopyWith<$Res> {
  __$FilterStateCopyWithImpl(this._self, this._then);

  final _FilterState _self;
  final $Res Function(_FilterState) _then;

/// Create a copy of FilterTempState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? rangeValues = null,Object? selectedCitys = null,Object? selectedGender = freezed,Object? hasChanged = null,}) {
  return _then(_FilterState(
rangeValues: null == rangeValues ? _self.rangeValues : rangeValues // ignore: cast_nullable_to_non_nullable
as RangeValues,selectedCitys: null == selectedCitys ? _self._selectedCitys : selectedCitys // ignore: cast_nullable_to_non_nullable
as List<String>,selectedGender: freezed == selectedGender ? _self.selectedGender : selectedGender // ignore: cast_nullable_to_non_nullable
as Gender?,hasChanged: null == hasChanged ? _self.hasChanged : hasChanged // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
