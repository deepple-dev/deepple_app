import 'package:deepple_app/app/router/router.dart';
import 'package:deepple_app/app/widget/view/default_progress_indicator.dart';
import 'package:deepple_app/app/widget/view/default_app_bar.dart';
import 'package:deepple_app/features/store/domain/provider/store_notifier.dart';
import 'package:deepple_app/features/store/domain/model/heart_product.dart';
import 'package:deepple_app/features/store/presentation/widget/default_heart_card.dart';
import 'package:deepple_app/features/store/presentation/widget/event_heart_card.dart';
import 'package:deepple_app/app/widget/text/bullet_text.dart';
import 'package:deepple_app/app/widget/icon/default_icon.dart';
import 'package:flutter/material.dart';
import 'package:deepple_app/app/constants/constants.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

class StorePage extends ConsumerWidget {
  const StorePage({super.key});

  static final List<HeartProduct> _heartItems = [
    HeartProduct.heart45,
    HeartProduct.heart110,
    HeartProduct.heart350,
    HeartProduct.heart550,
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final storeState = ref.watch(storeProvider);

    const double tagSpacing = 16;
    final double screenWidth = MediaQuery.sizeOf(context).width;
    final double horizontalPadding = screenWidth * 0.05;
    final EdgeInsets contentPadding = EdgeInsets.symmetric(
      horizontal: horizontalPadding,
    );

    return Stack(
      children: [
        Scaffold(
          appBar: const DefaultAppBar(title: '스토어'),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: contentPadding,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '보유한 하트',
                          style: Fonts.header03().copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const Gap(8),
                        Text(
                          '하트는 셀프소개, 좋아요, 모의고사 등 \n여러 기능을 사용할 때 필요한 화폐입니다',
                          style: Fonts.body02Regular().copyWith(
                            color: Palette.colorGrey600,
                            height: 1.2,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 32,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          shadowColor: Colors.transparent,
                          backgroundColor: Palette.colorPrimary100,
                          side: const BorderSide(
                            width: 1,
                            color: Palette.colorPrimary500,
                          ),
                        ),
                        onPressed: () {
                          navigate(context, route: AppRoute.heartHistory);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ConstrainedBox(
                              constraints: const BoxConstraints(minWidth: 36),
                              child: IntrinsicWidth(
                                child: Row(
                                  children: [
                                    const DefaultIcon(
                                      IconPath.storeHeart,
                                      size: 16,
                                    ),
                                    const Gap(4),
                                    Text(
                                      storeState.totalHeartBalance.toString(),
                                      style: Fonts.body03Regular(
                                        Palette.colorGrey900,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const DefaultIcon(IconPath.chevronRight2, size: 16),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: contentPadding,
                child: Row(
                  children: [
                    EventHeartCard(
                      code: HeartProduct.heart90.code,
                      onCreate: (code) =>
                          ref.read(storeProvider.notifier).buyProduct(code),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    Padding(
                      padding: contentPadding,
                      child: Wrap(
                        spacing: tagSpacing,
                        runSpacing: tagSpacing - 4,
                        children: _heartItems.map<Widget>((product) {
                          return SizedBox(
                            width:
                                (screenWidth -
                                    horizontalPadding * 2 -
                                    tagSpacing) /
                                2,
                            child: DefaultHeartCard(
                              heart: product.heartAmount.toString(),
                              price: product.price.toString(),
                              code: product.code,
                              onCreate: (code) => ref
                                  .read(storeProvider.notifier)
                                  .buyProduct(code),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    const Gap(12),
                    Padding(
                      padding: contentPadding,
                      child: BulletText(
                        texts: [
                          '청약철회는 구매일로부터 7일 이내 가능합니다',
                          'iOS 회원의 경우 청약철회는 Apple 고객센터로 문의해주세요.',
                          '미션으로 받은 하트는 환불이 불가합니다',
                          '미션으로 받은 하트의 유효기간은 90일간 유효합니다.',
                        ],
                        textStyle: Fonts.body03Regular(
                          const Color.fromRGBO(155, 160, 171, 1),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (storeState.isPurchasePending)
          Positioned.fill(
            child: Container(
              alignment: Alignment.center,
              child: const DefaultCircularProgressIndicator(),
            ),
          ),
      ],
    );
  }
}
