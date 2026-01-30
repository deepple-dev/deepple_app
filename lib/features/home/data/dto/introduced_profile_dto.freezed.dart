// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'introduced_profile_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$IntroducedProfileDto {

// HiveField 어노테이션은 그대로 유지
@HiveField(0) int get memberId;@HiveField(1) String get profileImageUrl;@HiveField(2) List<String> get hobbies;@HiveField(3) String get mbti;@HiveField(4) String? get religion;@HiveField(5) String? get likeLevel;@HiveField(6) bool get isIntroduced;@HiveField(7) int get age;@HiveField(8) String get nickname;@HiveField(9) String get city;@HiveField(10) String get district;
/// Create a copy of IntroducedProfileDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$IntroducedProfileDtoCopyWith<IntroducedProfileDto> get copyWith => _$IntroducedProfileDtoCopyWithImpl<IntroducedProfileDto>(this as IntroducedProfileDto, _$identity);

  /// Serializes this IntroducedProfileDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is IntroducedProfileDto&&(identical(other.memberId, memberId) || other.memberId == memberId)&&(identical(other.profileImageUrl, profileImageUrl) || other.profileImageUrl == profileImageUrl)&&const DeepCollectionEquality().equals(other.hobbies, hobbies)&&(identical(other.mbti, mbti) || other.mbti == mbti)&&(identical(other.religion, religion) || other.religion == religion)&&(identical(other.likeLevel, likeLevel) || other.likeLevel == likeLevel)&&(identical(other.isIntroduced, isIntroduced) || other.isIntroduced == isIntroduced)&&(identical(other.age, age) || other.age == age)&&(identical(other.nickname, nickname) || other.nickname == nickname)&&(identical(other.city, city) || other.city == city)&&(identical(other.district, district) || other.district == district));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,memberId,profileImageUrl,const DeepCollectionEquality().hash(hobbies),mbti,religion,likeLevel,isIntroduced,age,nickname,city,district);

@override
String toString() {
  return 'IntroducedProfileDto(memberId: $memberId, profileImageUrl: $profileImageUrl, hobbies: $hobbies, mbti: $mbti, religion: $religion, likeLevel: $likeLevel, isIntroduced: $isIntroduced, age: $age, nickname: $nickname, city: $city, district: $district)';
}


}

/// @nodoc
abstract mixin class $IntroducedProfileDtoCopyWith<$Res>  {
  factory $IntroducedProfileDtoCopyWith(IntroducedProfileDto value, $Res Function(IntroducedProfileDto) _then) = _$IntroducedProfileDtoCopyWithImpl;
@useResult
$Res call({
@HiveField(0) int memberId,@HiveField(1) String profileImageUrl,@HiveField(2) List<String> hobbies,@HiveField(3) String mbti,@HiveField(4) String? religion,@HiveField(5) String? likeLevel,@HiveField(6) bool isIntroduced,@HiveField(7) int age,@HiveField(8) String nickname,@HiveField(9) String city,@HiveField(10) String district
});




}
/// @nodoc
class _$IntroducedProfileDtoCopyWithImpl<$Res>
    implements $IntroducedProfileDtoCopyWith<$Res> {
  _$IntroducedProfileDtoCopyWithImpl(this._self, this._then);

  final IntroducedProfileDto _self;
  final $Res Function(IntroducedProfileDto) _then;

/// Create a copy of IntroducedProfileDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? memberId = null,Object? profileImageUrl = null,Object? hobbies = null,Object? mbti = null,Object? religion = freezed,Object? likeLevel = freezed,Object? isIntroduced = null,Object? age = null,Object? nickname = null,Object? city = null,Object? district = null,}) {
  return _then(_self.copyWith(
memberId: null == memberId ? _self.memberId : memberId // ignore: cast_nullable_to_non_nullable
as int,profileImageUrl: null == profileImageUrl ? _self.profileImageUrl : profileImageUrl // ignore: cast_nullable_to_non_nullable
as String,hobbies: null == hobbies ? _self.hobbies : hobbies // ignore: cast_nullable_to_non_nullable
as List<String>,mbti: null == mbti ? _self.mbti : mbti // ignore: cast_nullable_to_non_nullable
as String,religion: freezed == religion ? _self.religion : religion // ignore: cast_nullable_to_non_nullable
as String?,likeLevel: freezed == likeLevel ? _self.likeLevel : likeLevel // ignore: cast_nullable_to_non_nullable
as String?,isIntroduced: null == isIntroduced ? _self.isIntroduced : isIntroduced // ignore: cast_nullable_to_non_nullable
as bool,age: null == age ? _self.age : age // ignore: cast_nullable_to_non_nullable
as int,nickname: null == nickname ? _self.nickname : nickname // ignore: cast_nullable_to_non_nullable
as String,city: null == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String,district: null == district ? _self.district : district // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [IntroducedProfileDto].
extension IntroducedProfileDtoPatterns on IntroducedProfileDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _IntroducedProfileDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _IntroducedProfileDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _IntroducedProfileDto value)  $default,){
final _that = this;
switch (_that) {
case _IntroducedProfileDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _IntroducedProfileDto value)?  $default,){
final _that = this;
switch (_that) {
case _IntroducedProfileDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@HiveField(0)  int memberId, @HiveField(1)  String profileImageUrl, @HiveField(2)  List<String> hobbies, @HiveField(3)  String mbti, @HiveField(4)  String? religion, @HiveField(5)  String? likeLevel, @HiveField(6)  bool isIntroduced, @HiveField(7)  int age, @HiveField(8)  String nickname, @HiveField(9)  String city, @HiveField(10)  String district)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _IntroducedProfileDto() when $default != null:
return $default(_that.memberId,_that.profileImageUrl,_that.hobbies,_that.mbti,_that.religion,_that.likeLevel,_that.isIntroduced,_that.age,_that.nickname,_that.city,_that.district);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@HiveField(0)  int memberId, @HiveField(1)  String profileImageUrl, @HiveField(2)  List<String> hobbies, @HiveField(3)  String mbti, @HiveField(4)  String? religion, @HiveField(5)  String? likeLevel, @HiveField(6)  bool isIntroduced, @HiveField(7)  int age, @HiveField(8)  String nickname, @HiveField(9)  String city, @HiveField(10)  String district)  $default,) {final _that = this;
switch (_that) {
case _IntroducedProfileDto():
return $default(_that.memberId,_that.profileImageUrl,_that.hobbies,_that.mbti,_that.religion,_that.likeLevel,_that.isIntroduced,_that.age,_that.nickname,_that.city,_that.district);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@HiveField(0)  int memberId, @HiveField(1)  String profileImageUrl, @HiveField(2)  List<String> hobbies, @HiveField(3)  String mbti, @HiveField(4)  String? religion, @HiveField(5)  String? likeLevel, @HiveField(6)  bool isIntroduced, @HiveField(7)  int age, @HiveField(8)  String nickname, @HiveField(9)  String city, @HiveField(10)  String district)?  $default,) {final _that = this;
switch (_that) {
case _IntroducedProfileDto() when $default != null:
return $default(_that.memberId,_that.profileImageUrl,_that.hobbies,_that.mbti,_that.religion,_that.likeLevel,_that.isIntroduced,_that.age,_that.nickname,_that.city,_that.district);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _IntroducedProfileDto implements IntroducedProfileDto {
  const _IntroducedProfileDto({@HiveField(0) required this.memberId, @HiveField(1) required this.profileImageUrl, @HiveField(2) required final  List<String> hobbies, @HiveField(3) required this.mbti, @HiveField(4) required this.religion, @HiveField(5) this.likeLevel, @HiveField(6) required this.isIntroduced, @HiveField(7) required this.age, @HiveField(8) required this.nickname, @HiveField(9) required this.city, @HiveField(10) required this.district}): _hobbies = hobbies;
  factory _IntroducedProfileDto.fromJson(Map<String, dynamic> json) => _$IntroducedProfileDtoFromJson(json);

// HiveField 어노테이션은 그대로 유지
@override@HiveField(0) final  int memberId;
@override@HiveField(1) final  String profileImageUrl;
 final  List<String> _hobbies;
@override@HiveField(2) List<String> get hobbies {
  if (_hobbies is EqualUnmodifiableListView) return _hobbies;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_hobbies);
}

@override@HiveField(3) final  String mbti;
@override@HiveField(4) final  String? religion;
@override@HiveField(5) final  String? likeLevel;
@override@HiveField(6) final  bool isIntroduced;
@override@HiveField(7) final  int age;
@override@HiveField(8) final  String nickname;
@override@HiveField(9) final  String city;
@override@HiveField(10) final  String district;

/// Create a copy of IntroducedProfileDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$IntroducedProfileDtoCopyWith<_IntroducedProfileDto> get copyWith => __$IntroducedProfileDtoCopyWithImpl<_IntroducedProfileDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$IntroducedProfileDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _IntroducedProfileDto&&(identical(other.memberId, memberId) || other.memberId == memberId)&&(identical(other.profileImageUrl, profileImageUrl) || other.profileImageUrl == profileImageUrl)&&const DeepCollectionEquality().equals(other._hobbies, _hobbies)&&(identical(other.mbti, mbti) || other.mbti == mbti)&&(identical(other.religion, religion) || other.religion == religion)&&(identical(other.likeLevel, likeLevel) || other.likeLevel == likeLevel)&&(identical(other.isIntroduced, isIntroduced) || other.isIntroduced == isIntroduced)&&(identical(other.age, age) || other.age == age)&&(identical(other.nickname, nickname) || other.nickname == nickname)&&(identical(other.city, city) || other.city == city)&&(identical(other.district, district) || other.district == district));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,memberId,profileImageUrl,const DeepCollectionEquality().hash(_hobbies),mbti,religion,likeLevel,isIntroduced,age,nickname,city,district);

@override
String toString() {
  return 'IntroducedProfileDto(memberId: $memberId, profileImageUrl: $profileImageUrl, hobbies: $hobbies, mbti: $mbti, religion: $religion, likeLevel: $likeLevel, isIntroduced: $isIntroduced, age: $age, nickname: $nickname, city: $city, district: $district)';
}


}

/// @nodoc
abstract mixin class _$IntroducedProfileDtoCopyWith<$Res> implements $IntroducedProfileDtoCopyWith<$Res> {
  factory _$IntroducedProfileDtoCopyWith(_IntroducedProfileDto value, $Res Function(_IntroducedProfileDto) _then) = __$IntroducedProfileDtoCopyWithImpl;
@override @useResult
$Res call({
@HiveField(0) int memberId,@HiveField(1) String profileImageUrl,@HiveField(2) List<String> hobbies,@HiveField(3) String mbti,@HiveField(4) String? religion,@HiveField(5) String? likeLevel,@HiveField(6) bool isIntroduced,@HiveField(7) int age,@HiveField(8) String nickname,@HiveField(9) String city,@HiveField(10) String district
});




}
/// @nodoc
class __$IntroducedProfileDtoCopyWithImpl<$Res>
    implements _$IntroducedProfileDtoCopyWith<$Res> {
  __$IntroducedProfileDtoCopyWithImpl(this._self, this._then);

  final _IntroducedProfileDto _self;
  final $Res Function(_IntroducedProfileDto) _then;

/// Create a copy of IntroducedProfileDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? memberId = null,Object? profileImageUrl = null,Object? hobbies = null,Object? mbti = null,Object? religion = freezed,Object? likeLevel = freezed,Object? isIntroduced = null,Object? age = null,Object? nickname = null,Object? city = null,Object? district = null,}) {
  return _then(_IntroducedProfileDto(
memberId: null == memberId ? _self.memberId : memberId // ignore: cast_nullable_to_non_nullable
as int,profileImageUrl: null == profileImageUrl ? _self.profileImageUrl : profileImageUrl // ignore: cast_nullable_to_non_nullable
as String,hobbies: null == hobbies ? _self._hobbies : hobbies // ignore: cast_nullable_to_non_nullable
as List<String>,mbti: null == mbti ? _self.mbti : mbti // ignore: cast_nullable_to_non_nullable
as String,religion: freezed == religion ? _self.religion : religion // ignore: cast_nullable_to_non_nullable
as String?,likeLevel: freezed == likeLevel ? _self.likeLevel : likeLevel // ignore: cast_nullable_to_non_nullable
as String?,isIntroduced: null == isIntroduced ? _self.isIntroduced : isIntroduced // ignore: cast_nullable_to_non_nullable
as bool,age: null == age ? _self.age : age // ignore: cast_nullable_to_non_nullable
as int,nickname: null == nickname ? _self.nickname : nickname // ignore: cast_nullable_to_non_nullable
as String,city: null == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String,district: null == district ? _self.district : district // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
