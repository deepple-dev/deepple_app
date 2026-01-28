// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'introduced_profile_dto.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class IntroducedProfileDtoAdapter extends TypeAdapter<IntroducedProfileDto> {
  @override
  final typeId = 6;

  @override
  IntroducedProfileDto read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return IntroducedProfileDto(
      memberId: (fields[0] as num).toInt(),
      profileImageUrl: fields[1] as String,
      hobbies: (fields[2] as List).cast<String>(),
      mbti: fields[3] as String,
      religion: fields[4] as String?,
      likeLevel: fields[6] as String?,
      isIntroduced: fields[7] as bool,
      age: (fields[8] as num).toInt(),
      nickname: fields[9] as String,
      city: fields[10] as String,
      district: fields[11] as String,
    );
  }

  @override
  void write(BinaryWriter writer, IntroducedProfileDto obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.memberId)
      ..writeByte(1)
      ..write(obj.profileImageUrl)
      ..writeByte(2)
      ..write(obj.hobbies)
      ..writeByte(3)
      ..write(obj.mbti)
      ..writeByte(4)
      ..write(obj.religion)
      ..writeByte(6)
      ..write(obj.likeLevel)
      ..writeByte(7)
      ..write(obj.isIntroduced)
      ..writeByte(8)
      ..write(obj.age)
      ..writeByte(9)
      ..write(obj.nickname)
      ..writeByte(10)
      ..write(obj.city)
      ..writeByte(11)
      ..write(obj.district);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IntroducedProfileDtoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_IntroducedProfileDto _$IntroducedProfileDtoFromJson(
  Map<String, dynamic> json,
) => _IntroducedProfileDto(
  memberId: (json['memberId'] as num).toInt(),
  profileImageUrl: json['profileImageUrl'] as String,
  hobbies: (json['hobbies'] as List<dynamic>).map((e) => e as String).toList(),
  mbti: json['mbti'] as String,
  religion: json['religion'] as String?,
  likeLevel: json['likeLevel'] as String?,
  isIntroduced: json['isIntroduced'] as bool,
  age: (json['age'] as num).toInt(),
  nickname: json['nickname'] as String,
  city: json['city'] as String,
  district: json['district'] as String,
);

Map<String, dynamic> _$IntroducedProfileDtoToJson(
  _IntroducedProfileDto instance,
) => <String, dynamic>{
  'memberId': instance.memberId,
  'profileImageUrl': instance.profileImageUrl,
  'hobbies': instance.hobbies,
  'mbti': instance.mbti,
  'religion': instance.religion,
  'likeLevel': instance.likeLevel,
  'isIntroduced': instance.isIntroduced,
  'age': instance.age,
  'nickname': instance.nickname,
  'city': instance.city,
  'district': instance.district,
};
