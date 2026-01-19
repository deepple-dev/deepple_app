// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'introduce_detail_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$IntroduceDetailState {

 int get introduceId; IntroduceDetail? get introduceDetail; bool get isLoaded; int get heartPoint;
/// Create a copy of IntroduceDetailState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$IntroduceDetailStateCopyWith<IntroduceDetailState> get copyWith => _$IntroduceDetailStateCopyWithImpl<IntroduceDetailState>(this as IntroduceDetailState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is IntroduceDetailState&&(identical(other.introduceId, introduceId) || other.introduceId == introduceId)&&(identical(other.introduceDetail, introduceDetail) || other.introduceDetail == introduceDetail)&&(identical(other.isLoaded, isLoaded) || other.isLoaded == isLoaded)&&(identical(other.heartPoint, heartPoint) || other.heartPoint == heartPoint));
}


@override
int get hashCode => Object.hash(runtimeType,introduceId,introduceDetail,isLoaded,heartPoint);

@override
String toString() {
  return 'IntroduceDetailState(introduceId: $introduceId, introduceDetail: $introduceDetail, isLoaded: $isLoaded, heartPoint: $heartPoint)';
}


}

/// @nodoc
abstract mixin class $IntroduceDetailStateCopyWith<$Res>  {
  factory $IntroduceDetailStateCopyWith(IntroduceDetailState value, $Res Function(IntroduceDetailState) _then) = _$IntroduceDetailStateCopyWithImpl;
@useResult
$Res call({
 int introduceId, IntroduceDetail? introduceDetail, bool isLoaded, int heartPoint
});


$IntroduceDetailCopyWith<$Res>? get introduceDetail;

}
/// @nodoc
class _$IntroduceDetailStateCopyWithImpl<$Res>
    implements $IntroduceDetailStateCopyWith<$Res> {
  _$IntroduceDetailStateCopyWithImpl(this._self, this._then);

  final IntroduceDetailState _self;
  final $Res Function(IntroduceDetailState) _then;

/// Create a copy of IntroduceDetailState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? introduceId = null,Object? introduceDetail = freezed,Object? isLoaded = null,Object? heartPoint = null,}) {
  return _then(_self.copyWith(
introduceId: null == introduceId ? _self.introduceId : introduceId // ignore: cast_nullable_to_non_nullable
as int,introduceDetail: freezed == introduceDetail ? _self.introduceDetail : introduceDetail // ignore: cast_nullable_to_non_nullable
as IntroduceDetail?,isLoaded: null == isLoaded ? _self.isLoaded : isLoaded // ignore: cast_nullable_to_non_nullable
as bool,heartPoint: null == heartPoint ? _self.heartPoint : heartPoint // ignore: cast_nullable_to_non_nullable
as int,
  ));
}
/// Create a copy of IntroduceDetailState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$IntroduceDetailCopyWith<$Res>? get introduceDetail {
    if (_self.introduceDetail == null) {
    return null;
  }

  return $IntroduceDetailCopyWith<$Res>(_self.introduceDetail!, (value) {
    return _then(_self.copyWith(introduceDetail: value));
  });
}
}


/// Adds pattern-matching-related methods to [IntroduceDetailState].
extension IntroduceDetailStatePatterns on IntroduceDetailState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _IntroduceDetailState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _IntroduceDetailState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _IntroduceDetailState value)  $default,){
final _that = this;
switch (_that) {
case _IntroduceDetailState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _IntroduceDetailState value)?  $default,){
final _that = this;
switch (_that) {
case _IntroduceDetailState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int introduceId,  IntroduceDetail? introduceDetail,  bool isLoaded,  int heartPoint)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _IntroduceDetailState() when $default != null:
return $default(_that.introduceId,_that.introduceDetail,_that.isLoaded,_that.heartPoint);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int introduceId,  IntroduceDetail? introduceDetail,  bool isLoaded,  int heartPoint)  $default,) {final _that = this;
switch (_that) {
case _IntroduceDetailState():
return $default(_that.introduceId,_that.introduceDetail,_that.isLoaded,_that.heartPoint);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int introduceId,  IntroduceDetail? introduceDetail,  bool isLoaded,  int heartPoint)?  $default,) {final _that = this;
switch (_that) {
case _IntroduceDetailState() when $default != null:
return $default(_that.introduceId,_that.introduceDetail,_that.isLoaded,_that.heartPoint);case _:
  return null;

}
}

}

/// @nodoc


class _IntroduceDetailState extends IntroduceDetailState {
  const _IntroduceDetailState({this.introduceId = -1, this.introduceDetail = null, this.isLoaded = false, this.heartPoint = 0}): super._();
  

@override@JsonKey() final  int introduceId;
@override@JsonKey() final  IntroduceDetail? introduceDetail;
@override@JsonKey() final  bool isLoaded;
@override@JsonKey() final  int heartPoint;

/// Create a copy of IntroduceDetailState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$IntroduceDetailStateCopyWith<_IntroduceDetailState> get copyWith => __$IntroduceDetailStateCopyWithImpl<_IntroduceDetailState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _IntroduceDetailState&&(identical(other.introduceId, introduceId) || other.introduceId == introduceId)&&(identical(other.introduceDetail, introduceDetail) || other.introduceDetail == introduceDetail)&&(identical(other.isLoaded, isLoaded) || other.isLoaded == isLoaded)&&(identical(other.heartPoint, heartPoint) || other.heartPoint == heartPoint));
}


@override
int get hashCode => Object.hash(runtimeType,introduceId,introduceDetail,isLoaded,heartPoint);

@override
String toString() {
  return 'IntroduceDetailState(introduceId: $introduceId, introduceDetail: $introduceDetail, isLoaded: $isLoaded, heartPoint: $heartPoint)';
}


}

/// @nodoc
abstract mixin class _$IntroduceDetailStateCopyWith<$Res> implements $IntroduceDetailStateCopyWith<$Res> {
  factory _$IntroduceDetailStateCopyWith(_IntroduceDetailState value, $Res Function(_IntroduceDetailState) _then) = __$IntroduceDetailStateCopyWithImpl;
@override @useResult
$Res call({
 int introduceId, IntroduceDetail? introduceDetail, bool isLoaded, int heartPoint
});


@override $IntroduceDetailCopyWith<$Res>? get introduceDetail;

}
/// @nodoc
class __$IntroduceDetailStateCopyWithImpl<$Res>
    implements _$IntroduceDetailStateCopyWith<$Res> {
  __$IntroduceDetailStateCopyWithImpl(this._self, this._then);

  final _IntroduceDetailState _self;
  final $Res Function(_IntroduceDetailState) _then;

/// Create a copy of IntroduceDetailState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? introduceId = null,Object? introduceDetail = freezed,Object? isLoaded = null,Object? heartPoint = null,}) {
  return _then(_IntroduceDetailState(
introduceId: null == introduceId ? _self.introduceId : introduceId // ignore: cast_nullable_to_non_nullable
as int,introduceDetail: freezed == introduceDetail ? _self.introduceDetail : introduceDetail // ignore: cast_nullable_to_non_nullable
as IntroduceDetail?,isLoaded: null == isLoaded ? _self.isLoaded : isLoaded // ignore: cast_nullable_to_non_nullable
as bool,heartPoint: null == heartPoint ? _self.heartPoint : heartPoint // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

/// Create a copy of IntroduceDetailState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$IntroduceDetailCopyWith<$Res>? get introduceDetail {
    if (_self.introduceDetail == null) {
    return null;
  }

  return $IntroduceDetailCopyWith<$Res>(_self.introduceDetail!, (value) {
    return _then(_self.copyWith(introduceDetail: value));
  });
}
}

// dart format on
