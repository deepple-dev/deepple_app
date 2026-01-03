import 'package:deepple_app/core/util/log.dart';
import 'package:deepple_app/features/favorite_list/data/repository/favorite_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:deepple_app/features/favorite_list/domain/provider/favorite_list_state.dart';

part 'favorite_list_notifier.g.dart';

@riverpod
class FavoriteListNotifier extends _$FavoriteListNotifier {
  @override
  FavoriteListState build() {
    _initializeFavoriteLists();
    return FavoriteListState.initial();
  }

  Future<void> _initializeFavoriteLists() async {
    try {
      final repository = ref.read(favoriteRepositoryProvider);
      final (myFavorites, favoriteMe) = await (
        repository.getMyFavoriteUserList(),
        repository.getUserListFavoriteMe(),
      ).wait;

      state = state.copyWith(
        myFavoriteUsers: myFavorites,
        favoriteMeUsers: favoriteMe,
        isLoaded: true,
        error: null,
      );
    } catch (e) {
      Log.e(e);
      state = state.copyWith(
        isLoaded: true,
        error: FavoriteListErrorType.network,
      );
    }
  }

  Future<void> loadMoreMyFavorites() async {
    if (!state.myFavoriteUsers.hasMore) {
      return;
    }

    try {
      final lastId = state.myFavoriteUsers.users.last.userId;
      final favoriteListData = await ref
          .read(favoriteRepositoryProvider)
          .getMyFavoriteUserList(lastId);

      state = state.copyWith(
        myFavoriteUsers: state.myFavoriteUsers.copyWith(
          users: [...state.myFavoriteUsers.users, ...favoriteListData.users],
          hasMore: favoriteListData.hasMore,
        ),
      );
    } catch (e) {
      Log.e(e);
      state = state.copyWith(error: FavoriteListErrorType.network);
    }
  }

  Future<void> loadMoreFavoriteMe() async {
    if (!state.favoriteMeUsers.hasMore) {
      return;
    }

    try {
      final lastId = state.favoriteMeUsers.users.last.userId;
      final favoriteListData = await ref
          .read(favoriteRepositoryProvider)
          .getUserListFavoriteMe(lastId);

      state = state.copyWith(
        favoriteMeUsers: state.favoriteMeUsers.copyWith(
          users: [...state.favoriteMeUsers.users, ...favoriteListData.users],
          hasMore: favoriteListData.hasMore,
        ),
      );
    } catch (e) {
      Log.e(e);
      state = state.copyWith(error: FavoriteListErrorType.network);
    }
  }

  void resetError() {
    state = state.copyWith(error: null);
  }
}
