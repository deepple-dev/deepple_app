import 'package:deepple_app/app/constants/enum.dart';
import 'package:deepple_app/app/enum/contact_method.dart';
import 'package:deepple_app/app/provider/global_notifier.dart';
import 'package:deepple_app/app/widget/error/dialogue_error.dart';
import 'package:deepple_app/core/network/network_exception.dart';
import 'package:deepple_app/core/util/log.dart';
import 'package:deepple_app/core/util/toast.dart';
import 'package:deepple_app/features/favorite_list/data/repository/favorite_repository.dart';
import 'package:deepple_app/features/profile/data/repository/profile_repository.dart';
import 'package:deepple_app/features/profile/domain/common/enum.dart';
import 'package:deepple_app/features/profile/domain/common/model.dart';
import 'package:deepple_app/features/profile/domain/usecase/usecase.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:deepple_app/features/profile/domain/provider/profile_state.dart';

part 'profile_notifier.g.dart';

@riverpod
class ProfileNotifier extends _$ProfileNotifier {
  late final ProfileRepository _repository;
  late final String _myName;

  @override
  ProfileState build(int userId) {
    _repository = ref.read(profileRepositoryProvider);
    _myName = ref.read(globalProvider).profile.nickname;

    _initializeProfileState(userId);
    return ProfileState.initial();
  }

  Future<void> _initializeProfileState(int userId) async {
    try {
      final profile = await ProfileFetchUseCase(ref).call(userId);
      final heartPoint = ref
          .read(globalProvider)
          .heartBalance
          .totalHeartBalance;

      state = state.copyWith(
        profile: profile,
        myUserName: _myName,
        heartPoint: heartPoint,
        message: '',
        isLoaded: true,
        error: null,
      );
    } on InvalidUserException {
      Log.e('user id($userId) is invalid user');
      state = state.copyWith(
        error: DialogueErrorType.invalidUser,
        needToExit: true,
      );
    } catch (e, stackTrace) {
      Log.e(stackTrace, errorObject: e);
      state = state.copyWith(
        error: DialogueErrorType.unknown,
        needToExit: true,
      );
    } finally {
      state = state.copyWith(isLoaded: true);
    }
  }

  set message(String message) {
    if (!state.enabledMessageInput) {
      assert(false, 'message couldn\'t be edited after trying match');
      return;
    }
    state = state.copyWith(message: message);
  }

  Future<void> setFavoriteType(FavoriteType type) async {
    try {
      final hasProcessedMission = await ref
          .read(favoriteRepositoryProvider)
          .requestFavorite(state.profile!.id, type: type);

      if (hasProcessedMission) {
        showToastMessage('좋아요 보내기 미션 완료! 하트 2개를 받았어요');
        await ref.read(globalProvider.notifier).fetchHeartBalance();
      }

      state = state.copyWith(
        profile: state.profile?.copyWith(favoriteType: type),
      );
    } on InvalidUserException {
      showToastMessage('비활성화 회원이에요');
    } catch (e) {
      Log.e(e);
      state = state.copyWith(error: DialogueErrorType.network);
    }
  }

  Future<void> requestMatch(ContactMethod method) async {
    if (state.profile == null) return;

    try {
      await ProfileMatchRequestUseCase(
        ref,
      ).call(userId: state.profile!.id, message: state.message, method: method);

      // 하트 사용하여 메시지 요청 후 보유 하트 수 갱신
      await ref.read(globalProvider.notifier).fetchHeartBalance();

      state = state.copyWith(
        profile: state.profile?.copyWith(
          matchStatus: MatchingRequested(
            matchId: state.profile!.matchStatus.matchId,
            sentMessage: state.message,
          ),
        ),
      );
    } on InvalidUserException {
      await showToastMessage('비활성화 회원이에요');
      return;
    } catch (e) {
      Log.e(e);
      state = state.copyWith(error: DialogueErrorType.network);
    }
  }

  Future<void> rejectMatch() async {
    if (state.profile == null) return;

    try {
      await ProfileMatchRejectUseCase(
        ref,
      ).call(state.profile!.matchStatus.matchId);

      state = state.copyWith(
        profile: state.profile?.copyWith(matchStatus: const UnMatched()),
      );
    } catch (e) {
      Log.e(e);
      state = state.copyWith(error: DialogueErrorType.network);
    }
  }

  Future<void> resetMatchStatus() async {
    try {
      await ProfileMatchResetUseCase(
        ref,
      ).call(state.profile!.matchStatus.matchId);

      state = state.copyWith(
        profile: state.profile?.copyWith(matchStatus: const UnMatched()),
      );
    } catch (e) {
      Log.e(e);
      state = state.copyWith(error: DialogueErrorType.network);
    }
  }

  Future<void> approveMatch() async {
    if (state.profile == null) return;

    try {
      await ProfileMatchApproveUseCase(ref).call(
        matchId: state.profile!.matchStatus.matchId,
        message: state.message,
      );

      _initializeProfileState(userId);
    } catch (e) {
      Log.e(e);
      state = state.copyWith(error: DialogueErrorType.network);
    }
  }

  Future<bool> approveProfileExchange() async {
    final profileExchangeId =
        state.profile?.profileExchangeInfo?.profileExchangeId;
    if (profileExchangeId == null) {
      return false;
    }
    final success = await _repository.approveProfileExchange(profileExchangeId);
    if (!success) {
      state = state.copyWith(error: DialogueErrorType.unknown);
      return false;
    }

    state = state.copyWith(
      profile: state.profile!.copyWith(
        profileExchangeInfo: state.profile?.profileExchangeInfo?.copyWith(
          profileExchangeStatus: ProfileExchangeStatus.approve,
        ),
      ),
    );

    return true;
  }

  Future<bool> rejectProfileExchange() async {
    final profileExchangeId =
        state.profile?.profileExchangeInfo?.profileExchangeId;
    if (profileExchangeId == null) {
      return false;
    }

    final success = await _repository.rejectProfileExchange(profileExchangeId);
    if (!success) {
      state = state.copyWith(error: DialogueErrorType.unknown);
      return false;
    }

    state = state.copyWith(
      profile: state.profile!.copyWith(
        profileExchangeInfo: state.profile?.profileExchangeInfo?.copyWith(
          profileExchangeStatus: ProfileExchangeStatus.rejected,
        ),
      ),
    );

    return true;
  }

  void resetError() {
    state = state.copyWith(error: null);
  }
}
