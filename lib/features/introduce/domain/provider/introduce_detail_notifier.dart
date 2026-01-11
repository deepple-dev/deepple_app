import 'package:deepple_app/app/provider/provider.dart';
import 'package:deepple_app/core/util/toast.dart';
import 'package:deepple_app/features/introduce/domain/provider/introduce_detail_state.dart';
import 'package:deepple_app/features/introduce/domain/usecase/fetch_introduce_detail_use_case.dart';
import 'package:deepple_app/features/profile/data/repository/profile_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'introduce_detail_notifier.g.dart';

@riverpod
class IntroduceDetailNotifier extends _$IntroduceDetailNotifier {
  @override
  Future<IntroduceDetailState> build({required int introduceId}) async {
    try {
      final heartPoint = ref
          .read(globalProvider)
          .heartBalance
          .totalHeartBalance;
      final introduceDetail = await ref
          .read(fetchIntroduceDetailUseCaseProvider)
          .execute(introduceId: introduceId);

      return IntroduceDetailState(
        introduceId: introduceId,
        introduceDetail: introduceDetail,
        isLoaded: true,
        heartPoint: heartPoint,
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
    final heartPoint = ref.read(globalProvider).heartBalance.totalHeartBalance;

    state = AsyncValue.data(
      state.requireValue.copyWith(
        introduceDetail: introduceDetail,
        heartPoint: heartPoint,
      ),
    );
    return true;
  }

  Future<bool> requestProfileExchange(int responderId) async {
    final repository = ref.read(profileRepositoryProvider);

    final success = await repository.requestProfileExchange(responderId);

    if (!success) {
      showToastMessage('프로필 교환 요청에 실패했습니다. 다시 시도해주세요.');
      return false;
    }

    final updatedHeartBalance = await ref
        .read(globalProvider.notifier)
        .fetchHeartBalance();

    final introduceDetail = await ref
        .read(fetchIntroduceDetailUseCaseProvider)
        .execute(introduceId: introduceId);

    state = AsyncValue.data(
      state.requireValue.copyWith(
        introduceDetail: introduceDetail,
        heartPoint: updatedHeartBalance?.totalHeartBalance ?? 0,
      ),
    );
    return true;
  }
}
