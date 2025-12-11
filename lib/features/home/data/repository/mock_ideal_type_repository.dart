import 'package:deepple_app/features/home/data/dto/ideal_type_dto.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final idealTypeRepository = Provider<MockIdealTypeRepository>((ref) {
  return MockIdealTypeRepository();
});

class MockIdealTypeRepository {
  IdealTypeDto _mockData = const IdealTypeDto(
    // TODO: api 연동 시 제거
    minAge: 20,
    maxAge: 30,
    hobbies: ['등산/클라이밍', '맛집탐방', '쇼핑'],
    cities: ['서울', '대구'],
    religion: null,
    smokingStatus: null,
    drinkingStatus: null,
  );

  Future<IdealTypeDto> getIdealType() async {
    // TODO: 테스트용 코드. api 연동 시 변경
    return _mockData;
  }

  Future<void> setIdealType(IdealTypeDto idealTypeDto) async {
    // TODO: 테스트용 코드. api 연동 시 변경
    _mockData = idealTypeDto;
  }
}
