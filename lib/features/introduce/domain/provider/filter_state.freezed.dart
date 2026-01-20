// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'filter_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$FilterState {

 RangeValues get rangeValues; List<String> get selectedCities; Gender? get selectedGender;
/// Create a copy of FilterState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FilterStateCopyWith<FilterState> get copyWith => _$FilterStateCopyWithImpl<FilterState>(this as FilterState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FilterState&&(identical(other.rangeValues, rangeValues) || other.rangeValues == rangeValues)&&const DeepCollectionEquality().equals(other.selectedCities, selectedCities)&&(identical(other.selectedGender, selectedGender) || other.selectedGender == selectedGender));
}


@override
int get hashCode => Object.hash(runtimeType,rangeValues,const DeepCollectionEquality().hash(selectedCities),selectedGender);

@override
String toString() {
  return 'FilterState(rangeValues: $rangeValues, selectedCities: $selectedCities, selectedGender: $selectedGender)';
}


}

/// @nodoc
abstract mixin class $FilterStateCopyWith<$Res>  {
  factory $FilterStateCopyWith(FilterState value, $Res Function(FilterState) _then) = _$FilterStateCopyWithImpl;
@useResult
$Res call({
 RangeValues rangeValues, List<String> selectedCities, Gender? selectedGender
});




}
/// @nodoc
class _$FilterStateCopyWithImpl<$Res>
    implements $FilterStateCopyWith<$Res> {
  _$FilterStateCopyWithImpl(this._self, this._then);

  final FilterState _self;
  final $Res Function(FilterState) _then;

/// Create a copy of FilterState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? rangeValues = null,Object? selectedCities = null,Object? selectedGender = freezed,}) {
  return _then(_self.copyWith(
rangeValues: null == rangeValues ? _self.rangeValues : rangeValues // ignore: cast_nullable_to_non_nullable
as RangeValues,selectedCities: null == selectedCities ? _self.selectedCities : selectedCities // ignore: cast_nullable_to_non_nullable
as List<String>,selectedGender: freezed == selectedGender ? _self.selectedGender : selectedGender // ignore: cast_nullable_to_non_nullable
as Gender?,
  ));
}

}


/// Adds pattern-matching-related methods to [FilterState].
extension FilterStatePatterns on FilterState {
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( RangeValues rangeValues,  List<String> selectedCities,  Gender? selectedGender)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FilterState() when $default != null:
return $default(_that.rangeValues,_that.selectedCities,_that.selectedGender);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( RangeValues rangeValues,  List<String> selectedCities,  Gender? selectedGender)  $default,) {final _that = this;
switch (_that) {
case _FilterState():
return $default(_that.rangeValues,_that.selectedCities,_that.selectedGender);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( RangeValues rangeValues,  List<String> selectedCities,  Gender? selectedGender)?  $default,) {final _that = this;
switch (_that) {
case _FilterState() when $default != null:
return $default(_that.rangeValues,_that.selectedCities,_that.selectedGender);case _:
  return null;

}
}

}

/// @nodoc


class _FilterState extends FilterState {
  const _FilterState({required this.rangeValues, required final  List<String> selectedCities, required this.selectedGender}): _selectedCities = selectedCities,super._();
  

@override final  RangeValues rangeValues;
 final  List<String> _selectedCities;
@override List<String> get selectedCities {
  if (_selectedCities is EqualUnmodifiableListView) return _selectedCities;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_selectedCities);
}

@override final  Gender? selectedGender;

/// Create a copy of FilterState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FilterStateCopyWith<_FilterState> get copyWith => __$FilterStateCopyWithImpl<_FilterState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FilterState&&(identical(other.rangeValues, rangeValues) || other.rangeValues == rangeValues)&&const DeepCollectionEquality().equals(other._selectedCities, _selectedCities)&&(identical(other.selectedGender, selectedGender) || other.selectedGender == selectedGender));
}


@override
int get hashCode => Object.hash(runtimeType,rangeValues,const DeepCollectionEquality().hash(_selectedCities),selectedGender);

@override
String toString() {
  return 'FilterState(rangeValues: $rangeValues, selectedCities: $selectedCities, selectedGender: $selectedGender)';
}


}

/// @nodoc
abstract mixin class _$FilterStateCopyWith<$Res> implements $FilterStateCopyWith<$Res> {
  factory _$FilterStateCopyWith(_FilterState value, $Res Function(_FilterState) _then) = __$FilterStateCopyWithImpl;
@override @useResult
$Res call({
 RangeValues rangeValues, List<String> selectedCities, Gender? selectedGender
});




}
/// @nodoc
class __$FilterStateCopyWithImpl<$Res>
    implements _$FilterStateCopyWith<$Res> {
  __$FilterStateCopyWithImpl(this._self, this._then);

  final _FilterState _self;
  final $Res Function(_FilterState) _then;

/// Create a copy of FilterState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? rangeValues = null,Object? selectedCities = null,Object? selectedGender = freezed,}) {
  return _then(_FilterState(
rangeValues: null == rangeValues ? _self.rangeValues : rangeValues // ignore: cast_nullable_to_non_nullable
as RangeValues,selectedCities: null == selectedCities ? _self._selectedCities : selectedCities // ignore: cast_nullable_to_non_nullable
as List<String>,selectedGender: freezed == selectedGender ? _self.selectedGender : selectedGender // ignore: cast_nullable_to_non_nullable
as Gender?,
  ));
}


}

// dart format on
