import 'package:deepple_app/app/constants/fonts.dart';
import 'package:deepple_app/app/constants/palette.dart';
import 'package:deepple_app/app/provider/global_notifier.dart';
import 'package:deepple_app/app/router/route_arguments.dart';
import 'package:deepple_app/app/router/router.dart';
import 'package:deepple_app/app/widget/dialogue/custom_dialogue.dart';
import 'package:deepple_app/core/extension/extension.dart';
import 'package:deepple_app/core/util/toast.dart';
import 'package:deepple_app/core/util/util.dart';
import 'package:deepple_app/features/introduce/domain/model/introduce_info.dart';
import 'package:deepple_app/features/introduce/domain/provider/introduce_notifier.dart';
import 'package:deepple_app/features/introduce/presentation/widget/empty_my_introduce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class IntroduceMyList extends ConsumerStatefulWidget {
  const IntroduceMyList({super.key});

  @override
  ConsumerState<IntroduceMyList> createState() => _IntroduceMyListState();
}

class _IntroduceMyListState extends ConsumerState<IntroduceMyList> {
  final _scrollController = ScrollController();
  String nickname = '';
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();

    nickname = ref.read(globalProvider).profile.nickname;
    _scrollController.addListener(_onScrollIntroduce);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScrollIntroduce);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScrollIntroduce() {
    if (_isLoadingMore ||
        _scrollController.offset <
            _scrollController.position.maxScrollExtent - 200) {
      return;
    }

    _isLoadingMore = true;
    try {
      ref.read(introduceProvider.notifier).fetchMyIntroduceMore();
    } catch (e) {
      // TODO: 에러 처리
      Log.e('내 셀프소개 추가 조회 시 오류 발생 : $e');
    } finally {
      _isLoadingMore = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final stateAsync = ref.watch(introduceProvider);

    return stateAsync.when(
      data: (data) {
        final introduces = data.introduceMyList;
        final introducesCount = introduces.length;

        if (introducesCount == 0) {
          return const EmptyMyIntroduce();
        }

        return ListView.builder(
          padding: EdgeInsets.zero,
          controller: _scrollController,
          itemCount: introducesCount,
          itemBuilder: (context, index) {
            final introduce = introduces[index];
            bool isLastItem = index == introducesCount - 1;
            return IntroduceHistoryListItem(
              item: introduce,
              isLastItem: isLastItem,
              nickname: nickname,
            );
          },
        );
      },
      error: (error, stackTrace) =>
          const Center(child: Text('내가 쓴 글 조회 중 오류 발생')),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }
}

class IntroduceHistoryListItem extends ConsumerWidget {
  final IntroduceInfo item;
  final bool isLastItem;
  final String nickname;

  const IntroduceHistoryListItem({
    super.key,
    required this.item,
    required this.isLastItem,
    required this.nickname,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () async {
        await navigate(
          context,
          route: AppRoute.introduceEdit,
          extra: IntroduceEditArguments(introduce: item),
        );
        ref.read(introduceProvider.notifier).fetchMyIntroduceList();
      },
      onLongPress: () {
        CustomDialogue.showTwoChoiceDialogue(
          context: context,
          content: '삭제 버튼을 누르면\n내 셀프소개 글이 삭제됩니다.',
          elevatedButtonText: '삭제',
          onElevatedButtonPressed: () async {
            try {
              await ref
                  .read(introduceProvider.notifier)
                  .deleteIntroduce(item.id);
              ref.read(introduceProvider.notifier).fetchMyIntroduceList();
              if (context.mounted) {
                Navigator.of(context).pop();
              }
            } catch (e) {
              // TODO: 에러 문구
              showToastMessage('삭제하는데 실패했습니다.');
            }
          },
        );
      },
      child: Container(
        decoration: BoxDecoration(
          border: isLastItem
              ? null
              : Border(
                  bottom: BorderSide(width: 1.w, color: Palette.colorGrey50),
                ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 16.h),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: Fonts.semibold(
                        fontSize: 16.sp,
                        color: const Color(0xFF1F1E23),
                        lineHeight: 1.4.h,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Gap(4),
                    Text(
                      item.content,
                      style: Fonts.regular(
                        fontSize: 14.sp,
                        color: Palette.colorGrey600,
                        lineHeight: 1.4.h,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Gap(4),
                    Text(
                      item.createdAt.toDateString,
                      style: Fonts.regular(
                        fontSize: 12.sp,
                        color: Palette.colorGrey300,
                        lineHeight: 1.4.h,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
