import 'package:deepple_app/core/util/log.dart';
import 'package:deepple_app/features/favorite_list/data/repository/favorite_repository.dart';
import 'package:deepple_app/features/introduce/domain/provider/introduce_detail_state.dart';
import 'package:deepple_app/features/introduce/domain/usecase/fetch_introduce_detail_use_case.dart';
import 'package:deepple_app/features/profile/data/repository/profile_repository.dart';
import 'package:deepple_app/features/profile/domain/common/enum.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'introduce_detail_notifier.g.dart';

@riverpod
class IntroduceDetailNotifier extends _$IntroduceDetailNotifier {
  @override
  Future<IntroduceDetailState> build({required int introduceId}) async {
    try {
      final introduceDetail = await ref
          .read(fetchIntroduceDetailUseCaseProvider)
          .execute(introduceId: introduceId);

      return IntroduceDetailState(
        introduceId: introduceId,
        introduceDetail: introduceDetail,
        isLoaded: true,
      );
    } catch (e) {
      return IntroduceDetailState(
        introduceId: introduceId,
        introduceDetail: null,
        isLoaded: true,
      );
    }
  }

  Future<bool> getIntroduceDetail() async {
    final introduceDetail = await ref
        .read(fetchIntroduceDetailUseCaseProvider)
        .execute(introduceId: introduceId);

    state = AsyncValue.data(
      state.requireValue.copyWith(introduceDetail: introduceDetail),
    );
    return true;
  }

  Future<bool> requestProfileExchange(int responderId) async {
    final repository = ref.read(profileRepositoryProvider);

    final success = await repository.requestProfileExchange(responderId);

    if (!success) {
      // TODO: 에러 처리
      return false;
    }

    // success했으면 introduceDetail 갱신해보자

    final introduceDetail = await ref
        .read(fetchIntroduceDetailUseCaseProvider)
        .execute(introduceId: introduceId);

    state = AsyncValue.data(
      state.requireValue.copyWith(introduceDetail: introduceDetail),
    );
    return true;
  }
}
