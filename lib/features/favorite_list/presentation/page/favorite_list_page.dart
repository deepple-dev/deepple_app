import 'package:deepple_app/app/constants/constants.dart';
import 'package:deepple_app/app/widget/view/default_app_bar_action_group.dart';
import 'package:deepple_app/core/extension/extended_context.dart';
import 'package:deepple_app/features/favorite_list/presentation/widget/favorite_list_body.dart';
import 'package:flutter/material.dart';

class FavoriteListPage extends StatelessWidget {
  const FavoriteListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: FavoriteTabType.values.length,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: false,
          title: Text(
            '좋아요',
            style: Fonts.header03().copyWith(
              fontWeight: FontWeight.w700,
              height: 1.2,
            ),
          ),
          actions: [const DefaultAppBarActionGroup()],
          automaticallyImplyLeading: false,
          bottom: TabBar(
            indicatorColor: Colors.black,
            dividerColor: context.colorScheme.outline,
            labelStyle: Fonts.body02Regular(
              Palette.colorGrey400,
            ).copyWith(fontWeight: FontWeight.w600),
            unselectedLabelStyle: Fonts.body02Regular(
              Palette.colorGrey400,
            ).copyWith(fontWeight: FontWeight.w400),
            unselectedLabelColor: context.colorScheme.secondary,
            indicatorSize: TabBarIndicatorSize.tab,
            labelColor: context.colorScheme.onSurface,
            tabs: FavoriteTabType.values
                .map((value) => Tab(child: Text(value.label)))
                .toList(),
          ),
        ),
        body: const FavoriteListBody(),
      ),
    );
  }
}

enum FavoriteTabType {
  received('받은 호감'),
  sent('보낸 호감');

  const FavoriteTabType(this.label);

  final String label;
}
