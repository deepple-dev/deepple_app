// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'exam_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ExamState {

 QuestionData get questionList; SoulmateData get soulmateList; int get currentSubjectIndex; bool get isDone; bool get hasResultData; bool get hasSoulmate; bool get isLoaded; int get currentPage; Map<int, int> get currentAnswerMap; QuestionListErrorType? get error;
/// Create a copy of ExamState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExamStateCopyWith<ExamState> get copyWith => _$ExamStateCopyWithImpl<ExamState>(this as ExamState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExamState&&(identical(other.questionList, questionList) || other.questionList == questionList)&&(identical(other.soulmateList, soulmateList) || other.soulmateList == soulmateList)&&(identical(other.currentSubjectIndex, currentSubjectIndex) || other.currentSubjectIndex == currentSubjectIndex)&&(identical(other.isDone, isDone) || other.isDone == isDone)&&(identical(other.hasResultData, hasResultData) || other.hasResultData == hasResultData)&&(identical(other.hasSoulmate, hasSoulmate) || other.hasSoulmate == hasSoulmate)&&(identical(other.isLoaded, isLoaded) || other.isLoaded == isLoaded)&&(identical(other.currentPage, currentPage) || other.currentPage == currentPage)&&const DeepCollectionEquality().equals(other.currentAnswerMap, currentAnswerMap)&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,questionList,soulmateList,currentSubjectIndex,isDone,hasResultData,hasSoulmate,isLoaded,currentPage,const DeepCollectionEquality().hash(currentAnswerMap),error);

@override
String toString() {
  return 'ExamState(questionList: $questionList, soulmateList: $soulmateList, currentSubjectIndex: $currentSubjectIndex, isDone: $isDone, hasResultData: $hasResultData, hasSoulmate: $hasSoulmate, isLoaded: $isLoaded, currentPage: $currentPage, currentAnswerMap: $currentAnswerMap, error: $error)';
}


}

/// @nodoc
abstract mixin class $ExamStateCopyWith<$Res>  {
  factory $ExamStateCopyWith(ExamState value, $Res Function(ExamState) _then) = _$ExamStateCopyWithImpl;
@useResult
$Res call({
 QuestionData questionList, SoulmateData soulmateList, int currentSubjectIndex, bool isDone, bool hasResultData, bool hasSoulmate, bool isLoaded, int currentPage, Map<int, int> currentAnswerMap, QuestionListErrorType? error
});


$QuestionDataCopyWith<$Res> get questionList;$SoulmateDataCopyWith<$Res> get soulmateList;

}
/// @nodoc
class _$ExamStateCopyWithImpl<$Res>
    implements $ExamStateCopyWith<$Res> {
  _$ExamStateCopyWithImpl(this._self, this._then);

  final ExamState _self;
  final $Res Function(ExamState) _then;

/// Create a copy of ExamState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? questionList = null,Object? soulmateList = null,Object? currentSubjectIndex = null,Object? isDone = null,Object? hasResultData = null,Object? hasSoulmate = null,Object? isLoaded = null,Object? currentPage = null,Object? currentAnswerMap = null,Object? error = freezed,}) {
  return _then(_self.copyWith(
questionList: null == questionList ? _self.questionList : questionList // ignore: cast_nullable_to_non_nullable
as QuestionData,soulmateList: null == soulmateList ? _self.soulmateList : soulmateList // ignore: cast_nullable_to_non_nullable
as SoulmateData,currentSubjectIndex: null == currentSubjectIndex ? _self.currentSubjectIndex : currentSubjectIndex // ignore: cast_nullable_to_non_nullable
as int,isDone: null == isDone ? _self.isDone : isDone // ignore: cast_nullable_to_non_nullable
as bool,hasResultData: null == hasResultData ? _self.hasResultData : hasResultData // ignore: cast_nullable_to_non_nullable
as bool,hasSoulmate: null == hasSoulmate ? _self.hasSoulmate : hasSoulmate // ignore: cast_nullable_to_non_nullable
as bool,isLoaded: null == isLoaded ? _self.isLoaded : isLoaded // ignore: cast_nullable_to_non_nullable
as bool,currentPage: null == currentPage ? _self.currentPage : currentPage // ignore: cast_nullable_to_non_nullable
as int,currentAnswerMap: null == currentAnswerMap ? _self.currentAnswerMap : currentAnswerMap // ignore: cast_nullable_to_non_nullable
as Map<int, int>,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as QuestionListErrorType?,
  ));
}
/// Create a copy of ExamState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$QuestionDataCopyWith<$Res> get questionList {
  
  return $QuestionDataCopyWith<$Res>(_self.questionList, (value) {
    return _then(_self.copyWith(questionList: value));
  });
}/// Create a copy of ExamState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SoulmateDataCopyWith<$Res> get soulmateList {
  
  return $SoulmateDataCopyWith<$Res>(_self.soulmateList, (value) {
    return _then(_self.copyWith(soulmateList: value));
  });
}
}


/// Adds pattern-matching-related methods to [ExamState].
extension ExamStatePatterns on ExamState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ExamState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ExamState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ExamState value)  $default,){
final _that = this;
switch (_that) {
case _ExamState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ExamState value)?  $default,){
final _that = this;
switch (_that) {
case _ExamState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( QuestionData questionList,  SoulmateData soulmateList,  int currentSubjectIndex,  bool isDone,  bool hasResultData,  bool hasSoulmate,  bool isLoaded,  int currentPage,  Map<int, int> currentAnswerMap,  QuestionListErrorType? error)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ExamState() when $default != null:
return $default(_that.questionList,_that.soulmateList,_that.currentSubjectIndex,_that.isDone,_that.hasResultData,_that.hasSoulmate,_that.isLoaded,_that.currentPage,_that.currentAnswerMap,_that.error);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( QuestionData questionList,  SoulmateData soulmateList,  int currentSubjectIndex,  bool isDone,  bool hasResultData,  bool hasSoulmate,  bool isLoaded,  int currentPage,  Map<int, int> currentAnswerMap,  QuestionListErrorType? error)  $default,) {final _that = this;
switch (_that) {
case _ExamState():
return $default(_that.questionList,_that.soulmateList,_that.currentSubjectIndex,_that.isDone,_that.hasResultData,_that.hasSoulmate,_that.isLoaded,_that.currentPage,_that.currentAnswerMap,_that.error);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( QuestionData questionList,  SoulmateData soulmateList,  int currentSubjectIndex,  bool isDone,  bool hasResultData,  bool hasSoulmate,  bool isLoaded,  int currentPage,  Map<int, int> currentAnswerMap,  QuestionListErrorType? error)?  $default,) {final _that = this;
switch (_that) {
case _ExamState() when $default != null:
return $default(_that.questionList,_that.soulmateList,_that.currentSubjectIndex,_that.isDone,_that.hasResultData,_that.hasSoulmate,_that.isLoaded,_that.currentPage,_that.currentAnswerMap,_that.error);case _:
  return null;

}
}

}

/// @nodoc


class _ExamState extends ExamState {
  const _ExamState({required this.questionList, required this.soulmateList, required this.currentSubjectIndex, required this.isDone, required this.hasResultData, required this.hasSoulmate, this.isLoaded = false, this.currentPage = 0, final  Map<int, int> currentAnswerMap = const {}, this.error}): _currentAnswerMap = currentAnswerMap,super._();
  

@override final  QuestionData questionList;
@override final  SoulmateData soulmateList;
@override final  int currentSubjectIndex;
@override final  bool isDone;
@override final  bool hasResultData;
@override final  bool hasSoulmate;
@override@JsonKey() final  bool isLoaded;
@override@JsonKey() final  int currentPage;
 final  Map<int, int> _currentAnswerMap;
@override@JsonKey() Map<int, int> get currentAnswerMap {
  if (_currentAnswerMap is EqualUnmodifiableMapView) return _currentAnswerMap;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_currentAnswerMap);
}

@override final  QuestionListErrorType? error;

/// Create a copy of ExamState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExamStateCopyWith<_ExamState> get copyWith => __$ExamStateCopyWithImpl<_ExamState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ExamState&&(identical(other.questionList, questionList) || other.questionList == questionList)&&(identical(other.soulmateList, soulmateList) || other.soulmateList == soulmateList)&&(identical(other.currentSubjectIndex, currentSubjectIndex) || other.currentSubjectIndex == currentSubjectIndex)&&(identical(other.isDone, isDone) || other.isDone == isDone)&&(identical(other.hasResultData, hasResultData) || other.hasResultData == hasResultData)&&(identical(other.hasSoulmate, hasSoulmate) || other.hasSoulmate == hasSoulmate)&&(identical(other.isLoaded, isLoaded) || other.isLoaded == isLoaded)&&(identical(other.currentPage, currentPage) || other.currentPage == currentPage)&&const DeepCollectionEquality().equals(other._currentAnswerMap, _currentAnswerMap)&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,questionList,soulmateList,currentSubjectIndex,isDone,hasResultData,hasSoulmate,isLoaded,currentPage,const DeepCollectionEquality().hash(_currentAnswerMap),error);

@override
String toString() {
  return 'ExamState(questionList: $questionList, soulmateList: $soulmateList, currentSubjectIndex: $currentSubjectIndex, isDone: $isDone, hasResultData: $hasResultData, hasSoulmate: $hasSoulmate, isLoaded: $isLoaded, currentPage: $currentPage, currentAnswerMap: $currentAnswerMap, error: $error)';
}


}

/// @nodoc
abstract mixin class _$ExamStateCopyWith<$Res> implements $ExamStateCopyWith<$Res> {
  factory _$ExamStateCopyWith(_ExamState value, $Res Function(_ExamState) _then) = __$ExamStateCopyWithImpl;
@override @useResult
$Res call({
 QuestionData questionList, SoulmateData soulmateList, int currentSubjectIndex, bool isDone, bool hasResultData, bool hasSoulmate, bool isLoaded, int currentPage, Map<int, int> currentAnswerMap, QuestionListErrorType? error
});


@override $QuestionDataCopyWith<$Res> get questionList;@override $SoulmateDataCopyWith<$Res> get soulmateList;

}
/// @nodoc
class __$ExamStateCopyWithImpl<$Res>
    implements _$ExamStateCopyWith<$Res> {
  __$ExamStateCopyWithImpl(this._self, this._then);

  final _ExamState _self;
  final $Res Function(_ExamState) _then;

/// Create a copy of ExamState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? questionList = null,Object? soulmateList = null,Object? currentSubjectIndex = null,Object? isDone = null,Object? hasResultData = null,Object? hasSoulmate = null,Object? isLoaded = null,Object? currentPage = null,Object? currentAnswerMap = null,Object? error = freezed,}) {
  return _then(_ExamState(
questionList: null == questionList ? _self.questionList : questionList // ignore: cast_nullable_to_non_nullable
as QuestionData,soulmateList: null == soulmateList ? _self.soulmateList : soulmateList // ignore: cast_nullable_to_non_nullable
as SoulmateData,currentSubjectIndex: null == currentSubjectIndex ? _self.currentSubjectIndex : currentSubjectIndex // ignore: cast_nullable_to_non_nullable
as int,isDone: null == isDone ? _self.isDone : isDone // ignore: cast_nullable_to_non_nullable
as bool,hasResultData: null == hasResultData ? _self.hasResultData : hasResultData // ignore: cast_nullable_to_non_nullable
as bool,hasSoulmate: null == hasSoulmate ? _self.hasSoulmate : hasSoulmate // ignore: cast_nullable_to_non_nullable
as bool,isLoaded: null == isLoaded ? _self.isLoaded : isLoaded // ignore: cast_nullable_to_non_nullable
as bool,currentPage: null == currentPage ? _self.currentPage : currentPage // ignore: cast_nullable_to_non_nullable
as int,currentAnswerMap: null == currentAnswerMap ? _self._currentAnswerMap : currentAnswerMap // ignore: cast_nullable_to_non_nullable
as Map<int, int>,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as QuestionListErrorType?,
  ));
}

/// Create a copy of ExamState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$QuestionDataCopyWith<$Res> get questionList {
  
  return $QuestionDataCopyWith<$Res>(_self.questionList, (value) {
    return _then(_self.copyWith(questionList: value));
  });
}/// Create a copy of ExamState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SoulmateDataCopyWith<$Res> get soulmateList {
  
  return $SoulmateDataCopyWith<$Res>(_self.soulmateList, (value) {
    return _then(_self.copyWith(soulmateList: value));
  });
}
}

/// @nodoc
mixin _$QuestionData {

 List<SubjectItem> get questionList;
/// Create a copy of QuestionData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QuestionDataCopyWith<QuestionData> get copyWith => _$QuestionDataCopyWithImpl<QuestionData>(this as QuestionData, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QuestionData&&const DeepCollectionEquality().equals(other.questionList, questionList));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(questionList));

@override
String toString() {
  return 'QuestionData(questionList: $questionList)';
}


}

/// @nodoc
abstract mixin class $QuestionDataCopyWith<$Res>  {
  factory $QuestionDataCopyWith(QuestionData value, $Res Function(QuestionData) _then) = _$QuestionDataCopyWithImpl;
@useResult
$Res call({
 List<SubjectItem> questionList
});




}
/// @nodoc
class _$QuestionDataCopyWithImpl<$Res>
    implements $QuestionDataCopyWith<$Res> {
  _$QuestionDataCopyWithImpl(this._self, this._then);

  final QuestionData _self;
  final $Res Function(QuestionData) _then;

/// Create a copy of QuestionData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? questionList = null,}) {
  return _then(_self.copyWith(
questionList: null == questionList ? _self.questionList : questionList // ignore: cast_nullable_to_non_nullable
as List<SubjectItem>,
  ));
}

}


/// Adds pattern-matching-related methods to [QuestionData].
extension QuestionDataPatterns on QuestionData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _QuestionData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _QuestionData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _QuestionData value)  $default,){
final _that = this;
switch (_that) {
case _QuestionData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _QuestionData value)?  $default,){
final _that = this;
switch (_that) {
case _QuestionData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<SubjectItem> questionList)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _QuestionData() when $default != null:
return $default(_that.questionList);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<SubjectItem> questionList)  $default,) {final _that = this;
switch (_that) {
case _QuestionData():
return $default(_that.questionList);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<SubjectItem> questionList)?  $default,) {final _that = this;
switch (_that) {
case _QuestionData() when $default != null:
return $default(_that.questionList);case _:
  return null;

}
}

}

/// @nodoc


class _QuestionData implements QuestionData {
  const _QuestionData({final  List<SubjectItem> questionList = const []}): _questionList = questionList;
  

 final  List<SubjectItem> _questionList;
@override@JsonKey() List<SubjectItem> get questionList {
  if (_questionList is EqualUnmodifiableListView) return _questionList;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_questionList);
}


/// Create a copy of QuestionData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QuestionDataCopyWith<_QuestionData> get copyWith => __$QuestionDataCopyWithImpl<_QuestionData>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _QuestionData&&const DeepCollectionEquality().equals(other._questionList, _questionList));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_questionList));

@override
String toString() {
  return 'QuestionData(questionList: $questionList)';
}


}

/// @nodoc
abstract mixin class _$QuestionDataCopyWith<$Res> implements $QuestionDataCopyWith<$Res> {
  factory _$QuestionDataCopyWith(_QuestionData value, $Res Function(_QuestionData) _then) = __$QuestionDataCopyWithImpl;
@override @useResult
$Res call({
 List<SubjectItem> questionList
});




}
/// @nodoc
class __$QuestionDataCopyWithImpl<$Res>
    implements _$QuestionDataCopyWith<$Res> {
  __$QuestionDataCopyWithImpl(this._self, this._then);

  final _QuestionData _self;
  final $Res Function(_QuestionData) _then;

/// Create a copy of QuestionData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? questionList = null,}) {
  return _then(_QuestionData(
questionList: null == questionList ? _self._questionList : questionList // ignore: cast_nullable_to_non_nullable
as List<SubjectItem>,
  ));
}


}

/// @nodoc
mixin _$SoulmateData {

 List<IntroducedProfile> get soulmateList;
/// Create a copy of SoulmateData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SoulmateDataCopyWith<SoulmateData> get copyWith => _$SoulmateDataCopyWithImpl<SoulmateData>(this as SoulmateData, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SoulmateData&&const DeepCollectionEquality().equals(other.soulmateList, soulmateList));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(soulmateList));

@override
String toString() {
  return 'SoulmateData(soulmateList: $soulmateList)';
}


}

/// @nodoc
abstract mixin class $SoulmateDataCopyWith<$Res>  {
  factory $SoulmateDataCopyWith(SoulmateData value, $Res Function(SoulmateData) _then) = _$SoulmateDataCopyWithImpl;
@useResult
$Res call({
 List<IntroducedProfile> soulmateList
});




}
/// @nodoc
class _$SoulmateDataCopyWithImpl<$Res>
    implements $SoulmateDataCopyWith<$Res> {
  _$SoulmateDataCopyWithImpl(this._self, this._then);

  final SoulmateData _self;
  final $Res Function(SoulmateData) _then;

/// Create a copy of SoulmateData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? soulmateList = null,}) {
  return _then(_self.copyWith(
soulmateList: null == soulmateList ? _self.soulmateList : soulmateList // ignore: cast_nullable_to_non_nullable
as List<IntroducedProfile>,
  ));
}

}


/// Adds pattern-matching-related methods to [SoulmateData].
extension SoulmateDataPatterns on SoulmateData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SoulmateData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SoulmateData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SoulmateData value)  $default,){
final _that = this;
switch (_that) {
case _SoulmateData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SoulmateData value)?  $default,){
final _that = this;
switch (_that) {
case _SoulmateData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<IntroducedProfile> soulmateList)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SoulmateData() when $default != null:
return $default(_that.soulmateList);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<IntroducedProfile> soulmateList)  $default,) {final _that = this;
switch (_that) {
case _SoulmateData():
return $default(_that.soulmateList);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<IntroducedProfile> soulmateList)?  $default,) {final _that = this;
switch (_that) {
case _SoulmateData() when $default != null:
return $default(_that.soulmateList);case _:
  return null;

}
}

}

/// @nodoc


class _SoulmateData implements SoulmateData {
  const _SoulmateData({final  List<IntroducedProfile> soulmateList = const []}): _soulmateList = soulmateList;
  

 final  List<IntroducedProfile> _soulmateList;
@override@JsonKey() List<IntroducedProfile> get soulmateList {
  if (_soulmateList is EqualUnmodifiableListView) return _soulmateList;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_soulmateList);
}


/// Create a copy of SoulmateData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SoulmateDataCopyWith<_SoulmateData> get copyWith => __$SoulmateDataCopyWithImpl<_SoulmateData>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SoulmateData&&const DeepCollectionEquality().equals(other._soulmateList, _soulmateList));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_soulmateList));

@override
String toString() {
  return 'SoulmateData(soulmateList: $soulmateList)';
}


}

/// @nodoc
abstract mixin class _$SoulmateDataCopyWith<$Res> implements $SoulmateDataCopyWith<$Res> {
  factory _$SoulmateDataCopyWith(_SoulmateData value, $Res Function(_SoulmateData) _then) = __$SoulmateDataCopyWithImpl;
@override @useResult
$Res call({
 List<IntroducedProfile> soulmateList
});




}
/// @nodoc
class __$SoulmateDataCopyWithImpl<$Res>
    implements _$SoulmateDataCopyWith<$Res> {
  __$SoulmateDataCopyWithImpl(this._self, this._then);

  final _SoulmateData _self;
  final $Res Function(_SoulmateData) _then;

/// Create a copy of SoulmateData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? soulmateList = null,}) {
  return _then(_SoulmateData(
soulmateList: null == soulmateList ? _self._soulmateList : soulmateList // ignore: cast_nullable_to_non_nullable
as List<IntroducedProfile>,
  ));
}


}

// dart format on
