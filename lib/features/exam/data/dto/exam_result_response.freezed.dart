// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'exam_result_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ExamResultResponse {

 PersonalityType get personalityType;
/// Create a copy of ExamResultResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExamResultResponseCopyWith<ExamResultResponse> get copyWith => _$ExamResultResponseCopyWithImpl<ExamResultResponse>(this as ExamResultResponse, _$identity);

  /// Serializes this ExamResultResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExamResultResponse&&(identical(other.personalityType, personalityType) || other.personalityType == personalityType));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,personalityType);

@override
String toString() {
  return 'ExamResultResponse(personalityType: $personalityType)';
}


}

/// @nodoc
abstract mixin class $ExamResultResponseCopyWith<$Res>  {
  factory $ExamResultResponseCopyWith(ExamResultResponse value, $Res Function(ExamResultResponse) _then) = _$ExamResultResponseCopyWithImpl;
@useResult
$Res call({
 PersonalityType personalityType
});




}
/// @nodoc
class _$ExamResultResponseCopyWithImpl<$Res>
    implements $ExamResultResponseCopyWith<$Res> {
  _$ExamResultResponseCopyWithImpl(this._self, this._then);

  final ExamResultResponse _self;
  final $Res Function(ExamResultResponse) _then;

/// Create a copy of ExamResultResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? personalityType = null,}) {
  return _then(_self.copyWith(
personalityType: null == personalityType ? _self.personalityType : personalityType // ignore: cast_nullable_to_non_nullable
as PersonalityType,
  ));
}

}


/// Adds pattern-matching-related methods to [ExamResultResponse].
extension ExamResultResponsePatterns on ExamResultResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ExamResultResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ExamResultResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ExamResultResponse value)  $default,){
final _that = this;
switch (_that) {
case _ExamResultResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ExamResultResponse value)?  $default,){
final _that = this;
switch (_that) {
case _ExamResultResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( PersonalityType personalityType)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ExamResultResponse() when $default != null:
return $default(_that.personalityType);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( PersonalityType personalityType)  $default,) {final _that = this;
switch (_that) {
case _ExamResultResponse():
return $default(_that.personalityType);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( PersonalityType personalityType)?  $default,) {final _that = this;
switch (_that) {
case _ExamResultResponse() when $default != null:
return $default(_that.personalityType);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ExamResultResponse implements ExamResultResponse {
  const _ExamResultResponse({required this.personalityType});
  factory _ExamResultResponse.fromJson(Map<String, dynamic> json) => _$ExamResultResponseFromJson(json);

@override final  PersonalityType personalityType;

/// Create a copy of ExamResultResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExamResultResponseCopyWith<_ExamResultResponse> get copyWith => __$ExamResultResponseCopyWithImpl<_ExamResultResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ExamResultResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ExamResultResponse&&(identical(other.personalityType, personalityType) || other.personalityType == personalityType));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,personalityType);

@override
String toString() {
  return 'ExamResultResponse(personalityType: $personalityType)';
}


}

/// @nodoc
abstract mixin class _$ExamResultResponseCopyWith<$Res> implements $ExamResultResponseCopyWith<$Res> {
  factory _$ExamResultResponseCopyWith(_ExamResultResponse value, $Res Function(_ExamResultResponse) _then) = __$ExamResultResponseCopyWithImpl;
@override @useResult
$Res call({
 PersonalityType personalityType
});




}
/// @nodoc
class __$ExamResultResponseCopyWithImpl<$Res>
    implements _$ExamResultResponseCopyWith<$Res> {
  __$ExamResultResponseCopyWithImpl(this._self, this._then);

  final _ExamResultResponse _self;
  final $Res Function(_ExamResultResponse) _then;

/// Create a copy of ExamResultResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? personalityType = null,}) {
  return _then(_ExamResultResponse(
personalityType: null == personalityType ? _self.personalityType : personalityType // ignore: cast_nullable_to_non_nullable
as PersonalityType,
  ));
}


}

// dart format on
