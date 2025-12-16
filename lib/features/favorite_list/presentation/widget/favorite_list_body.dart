import 'package:deepple_app/app/router/route_arguments.dart';
import 'package:deepple_app/app/router/router.dart';
import 'package:deepple_app/features/favorite_list/domain/provider/domain.dart';
import 'package:deepple_app/features/favorite_list/presentation/page/favorite_list_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:deepple_app/features/favorite_list/presentation/widget/empty_favorite.dart';
import 'package:deepple_app/features/favorite_list/presentation/widget/favorite_grid_item.dart';

class FavoriteListBody extends ConsumerStatefulWidget {
  const FavoriteListBody({super.key});

  @override
  ConsumerState<FavoriteListBody> createState() => _FavoriteListBodyState();
}

class _FavoriteListBodyState extends ConsumerState<FavoriteListBody> {
  late final ScrollController _controller;
  late final List<int> _unBlurIdList;

  @override
  void initState() {
    _controller = ScrollController()..addListener(_onScroll);
    _unBlurIdList = [];
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final notifier = ref.watch(favoriteListProvider);

    return SafeArea(
      child: TabBarView(
        children: FavoriteTabType.values.map((type) {
          final data = switch (type) {
            FavoriteTabType.received => notifier.favoriteMeUsers,
            FavoriteTabType.sent => notifier.myFavoriteUsers,
          };

          if (data.users.isEmpty) {
            return EmptyFavorite(type: type);
          }

          return CustomScrollView(
            controller: _controller,
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                sliver: SliverGrid(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final profile = data.users[index];
                    return FavoriteGridItem(
                      profile: profile,
                      isBlurred:
                          !(index < _previewProfileCount &&
                              _unBlurIdList.contains(profile.userId)),
                      onProfileTab: () => navigate(
                        context,
                        route: AppRoute.profile,
                        extra: ProfileDetailArguments(userId: profile.userId),
                      ),
                      onBlurTap: () =>
                          setState(() => _unBlurIdList.add(profile.userId)),
                    );
                  }, childCount: data.users.length),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: _gridColumnCount,
                    mainAxisSpacing: 8.0,
                    crossAxisSpacing: 16.0,
                    childAspectRatio: _gridItemSize.aspectRatio,
                  ),
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  static const _gridItemSize = Size(104.0, 152.0);

  static const _gridColumnCount = 3;

  static const _previewProfileCount = 6;

  void _onScroll() {
    final pixel = _controller.position.pixels;
    const threshold = 300;
    if (_controller.position.maxScrollExtent >= pixel + threshold) return;

    final notifier = ref.read(favoriteListProvider.notifier);

    final currentSelectedTab =
        FavoriteTabType.values[DefaultTabController.of(context).index];

    switch (currentSelectedTab) {
      case FavoriteTabType.sent:
        notifier.loadMoreMyFavorites();
      case FavoriteTabType.received:
        notifier.loadMoreFavoriteMe();
    }
  }
}
