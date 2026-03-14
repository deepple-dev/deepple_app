// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exam_result_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ExamResultResponse _$ExamResultResponseFromJson(Map<String, dynamic> json) =>
    _ExamResultResponse(
      personalityType: $enumDecode(
        _$PersonalityTypeEnumMap,
        json['personalityType'],
      ),
    );

Map<String, dynamic> _$ExamResultResponseToJson(_ExamResultResponse instance) =>
    <String, dynamic>{
      'personalityType': _$PersonalityTypeEnumMap[instance.personalityType]!,
    };

const _$PersonalityTypeEnumMap = {
  PersonalityType.decisiveIndependent: 'decisiveIndependent',
  PersonalityType.growingRunningMate: 'growingRunningMate',
  PersonalityType.devotedRomantic: 'devotedRomantic',
  PersonalityType.realisticShelter: 'realisticShelter',
};
