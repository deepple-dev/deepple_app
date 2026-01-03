import 'package:deepple_app/core/util/log.dart';
import 'package:deepple_app/features/introduce/data/mapper/introduce_mapper.dart';
import 'package:deepple_app/features/introduce/data/repository/introduce_repository.dart';
import 'package:deepple_app/features/introduce/domain/model/introduce_info.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final fetchIntroduceMyListUseCaseProvider =
    Provider<FetchIntroduceMyListUseCase>(
      (ref) => FetchIntroduceMyListUseCase(ref),
    );

class FetchIntroduceMyListUseCase {
  final Ref ref;

  FetchIntroduceMyListUseCase(this.ref);

  Future<List<IntroduceInfo>> execute({int? lastId}) async {
    try {
      final introduces = await ref
          .read(introduceRepositoryProvider)
          .getMyIntroduceList(lastId: lastId);

      return introduces
          .map(
            (e) => e.toDomain(),
          )
          .toList();
    } catch (e) {
      Log.e('셀프 소개 리스트 호출 실패 : $e');
      return [];
    }
  }
}
