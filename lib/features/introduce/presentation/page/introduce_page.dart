import 'package:deepple_app/app/widget/view/default_app_bar_action_group.dart';
import 'package:deepple_app/core/extension/extended_context.dart';
import 'package:deepple_app/features/introduce/introduce.dart';
import 'package:deepple_app/features/introduce/presentation/widget/introduce_content_list.dart';
import 'package:deepple_app/features/introduce/presentation/widget/introduce_my_list.dart';
import 'package:flutter/material.dart';
import 'package:deepple_app/app/router/router.dart';
import 'package:deepple_app/app/constants/constants.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum IntroduceTabType {
  all('소개'),
  my('내가 쓴 글');

  final String label;

  const IntroduceTabType(this.label);
}

class IntroducePage extends ConsumerStatefulWidget {
  const IntroducePage({super.key});

  @override
  ConsumerState<IntroducePage> createState() => IntroducePageState();
}

class IntroducePageState extends ConsumerState<IntroducePage>
    with SingleTickerProviderStateMixin {
  IntroducePageState();

  late final TabController _tabController;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(
      length: SelfIntroduceTabType.values.length,
      vsync: this,
    );

    _tabController.addListener(() {
      if (_tabController.indexIsChanging) return;

      _refreshIntroduceList(_tabController.index);
    });

    // 최초 진입 시 첫 탭 데이터 로드
    _refreshIntroduceList(0);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double horizontalPadding = context.screenWidth * 0.05;
    final EdgeInsets contentPadding = EdgeInsets.symmetric(
      horizontal: horizontalPadding,
    );

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          '셀프소개',
          style: Fonts.header03().copyWith(
            fontWeight: FontWeight.w700,
            height: 1.2,
          ),
        ),
        actions: [const DefaultAppBarActionGroup(showFilter: true)],
        actionsPadding: const EdgeInsets.symmetric(horizontal: 10),
        automaticallyImplyLeading: false,
        bottom: TabBar(
          controller: _tabController,
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
          tabs: SelfIntroduceTabType.values
              .map((value) => Tab(child: Text(value.label)))
              .toList(),
        ),
      ),
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Padding(
                    padding: contentPadding,
                    child: TabBarView(
                      controller: _tabController,
                      children: const [
                        IntroduceContentList(),
                        IntroduceMyList(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          PostButton(
            onTap: () async {
              await navigate(context, route: AppRoute.introduceRegister);

              // 등록한 셀프소개가 적용되는 딜레이 필요
              // await Future.delayed(const Duration(milliseconds: 500));
              _refreshIntroduceList(_tabController.index);
            },
          ),
        ],
      ),
    );
  }

  Future<void> _refreshIntroduceList(int currentTabIndex) async {
    if (currentTabIndex == 0) {
      ref.read(introduceProvider.notifier).fetchIntroduceList();
    } else if (currentTabIndex == 1) {
      ref.read(introduceProvider.notifier).fetchMyIntroduceList();
    }
  }
}

enum SelfIntroduceTabType {
  introduced('소개'),
  self('내가 쓴 글');

  const SelfIntroduceTabType(this.label);

  final String label;
}
