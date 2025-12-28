import 'package:deepple_app/core/util/util.dart';
import 'package:deepple_app/features/introduce/domain/model/introduce_detail.dart';
import 'package:deepple_app/features/introduce/domain/provider/filter_notifier.dart';
import 'package:deepple_app/features/introduce/domain/provider/introduce_state.dart';
import 'package:deepple_app/features/introduce/domain/usecase/delete_introduce_use_case.dart';
import 'package:deepple_app/features/introduce/domain/usecase/fetch_introduce_detail_use_case.dart';
import 'package:deepple_app/features/introduce/domain/usecase/fetch_introduce_list_use_case.dart';
import 'package:deepple_app/features/introduce/domain/usecase/fetch_introduce_my_list_use_case.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'introduce_notifier.g.dart';

@riverpod
class IntroduceNotifier extends _$IntroduceNotifier {
  @override
  Future<IntroduceState> build() async {
    try {
      final filterState = ref.watch(filterProvider);

      final introduces = await ref
          .read(fetchIntroduceListUseCaseProvider)
          .execute(
            preferredCities: filterState.selectedCitysEng,
            fromAge: filterState.rangeValues.start.toInt(),
            toAge: filterState.rangeValues.end.toInt(),
            gender: filterState.getGender,
          );

      return IntroduceState(
        introduceList: introduces,
        isLoaded: true,
        introduceLastId: introduces.isNotEmpty ? introduces.last.id : null,
      );
    } catch (e, s) {
      throw AsyncError(e, s);
    }
  }

  /// 셀프 소개 목록 조회
  Future<void> fetchIntroduceList() async {
    try {
      final filterState = ref.watch(filterProvider);

      final prevState = state.value;

      if (prevState == null) return;

      final introduces = await ref
          .read(fetchIntroduceListUseCaseProvider)
          .execute(
            preferredCities: filterState.selectedCitysEng,
            fromAge: filterState.rangeValues.start.toInt(),
            toAge: filterState.rangeValues.end.toInt(),
            gender: filterState.getGender,
          );

      state = AsyncData(
        prevState.copyWith(
          introduceList: introduces,
          introduceLastId: introduces.isNotEmpty ? introduces.last.id : null,
        ),
      );
    } catch (e, s) {
      // TODO: 에러 처리
      Log.e('셀프 소개 목록 조회 중 오류 발생 : $e');
      state = AsyncError(e, s);
    }
  }

  // 셀프 소개 추가 조회
  Future<void> fetchIntroduceMore() async {
    try {
      final filterState = ref.watch(filterProvider);
      final prevState = state.value;

      if (prevState == null) return;

      if (state.value?.introduceLastId == null) return;

      final introduces = await ref
          .read(fetchIntroduceListUseCaseProvider)
          .execute(
            preferredCities: filterState.selectedCitysEng,
            fromAge: filterState.rangeValues.start.toInt(),
            toAge: filterState.rangeValues.end.toInt(),
            gender: filterState.getGender,
            lastId: state.value?.introduceLastId,
          );

      if (introduces.isEmpty) {
        state = AsyncData(prevState.copyWith(introduceLastId: null));
      } else {
        state = AsyncData(
          prevState.copyWith(
            introduceList: [...prevState.introduceList, ...introduces],
            introduceLastId: introduces.last.id,
          ),
        );
      }
    } catch (e, s) {
      // TODO: 에러 처리
      Log.e('셀프 소개 목록 조회 중 오류 발생 : $e');
      state = AsyncError(e, s);
    }
  }

  /// 자신의 셀프 소개 목록 조회
  Future<void> fetchMyIntroduceList() async {
    try {
      final prevState = state.value;

      if (prevState == null) return;

      final introduces = await ref
          .read(fetchIntroduceMyListUseCaseProvider)
          .execute();

      state = AsyncData(
        prevState.copyWith(
          introduceMyList: introduces,
          myIntroduceLastId: introduces.isNotEmpty ? introduces.last.id : null,
        ),
      );
    } catch (e, s) {
      // TODO: 에러 처리
      Log.e('내 셀프 소개 목록 조회 중 오류 발생 : $e');
      state = AsyncError(e, s);
    }
  }

  /// 자신의 셀프 소개 목록 추가 조회
  Future<void> fetchMyIntroduceMore() async {
    try {
      final prevState = state.value;

      if (prevState == null) return;

      if (prevState.myIntroduceLastId == null) return;

      final introduces = await ref
          .read(fetchIntroduceMyListUseCaseProvider)
          .execute(lastId: prevState.myIntroduceLastId);

      if (introduces.isEmpty) {
        state = AsyncData(prevState.copyWith(myIntroduceLastId: null));
      } else {
        state = AsyncData(
          prevState.copyWith(
            introduceMyList: [...prevState.introduceMyList, ...introduces],
            myIntroduceLastId: introduces.last.id,
          ),
        );
      }
    } catch (e, s) {
      // TODO: 에러 처리
      Log.e('내 셀프 소개 목록 조회 중 오류 발생 : $e');
      state = AsyncError(e, s);
    }
  }

  /// 셀프 소개 상세 조회
  Future<IntroduceDetail> fetchIntroduceDetail(int id) async {
    try {
      final introduceDetail = await ref
          .read(fetchIntroduceDetailUseCaseProvider)
          .execute(introduceId: id);

      return introduceDetail;
    } catch (e, s) {
      Log.e('셀프 소개 상세 조회 api 실패 $e');
      state = AsyncError(e, s);
      rethrow;
    }
  }

  /// 셀프 소개 삭제
  Future<void> deleteIntroduce(int id) async {
    try {
      await ref.read(deleteIntroduceUseCaseProvider).execute(id: id);
    } catch (e) {
      Log.e('Failed to delete introduce from server: $e');
      rethrow;
    }
  }
}
