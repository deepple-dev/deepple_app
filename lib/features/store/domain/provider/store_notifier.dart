import 'dart:async';
import 'package:deepple_app/core/network/network_exception.dart';
import 'package:deepple_app/app/provider/global_notifier.dart';
import 'package:deepple_app/core/util/log.dart';
import 'package:deepple_app/features/store/domain/provider/usecase_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:flutter/material.dart';

import 'package:deepple_app/features/store/domain/provider/store_state.dart';

part 'store_notifier.g.dart';

@riverpod
class StoreNotifier extends _$StoreNotifier {
  static const List<String> _productIds = [
    'APP_ITEM_HEART_45',
    'APP_ITEM_HEART_90',
    'APP_ITEM_HEART_110',
    'APP_ITEM_HEART_350',
    'APP_ITEM_HEART_550',
  ];

  StreamSubscription<List<PurchaseDetails>>? _subscription;

  @override
  StoreState build() {
    _initialize();

    ref.onDispose(() {
      _subscription?.cancel();
    });
    return StoreState.initial();
  }

  Future<void> _initialize() async {
    await Future.wait([
      _initializeAppPurchase(),
      _initializeHeartBalanceItem(),
    ]);
    _subscribeToPurchaseUpdates();
  }

  /// 결제 스트림 리스너 등록
  void _subscribeToPurchaseUpdates() {
    _subscription?.cancel(); // 중복 방지
    _subscription = InAppPurchase.instance.purchaseStream.listen(
      onPurchaseUpdated,
      onError: (error) {
        Log.e('Purchase stream error: $error');
      },
    );
  }

  // 스토어의 상품ID를 저장
  Future<void> _initializeAppPurchase() async {
    final inAppPurchase = InAppPurchase.instance;
    final isAvailable = await inAppPurchase.isAvailable();

    if (!isAvailable) return;

    final response = await inAppPurchase.queryProductDetails(
      _productIds.toSet(),
    );

    state = state.copyWith(products: response.productDetails, isLoaded: true);
  }

  // 하트상품 구입
  void buyProduct(String productId) {
    final inAppPurchase = InAppPurchase.instance;
    final product = state.products.firstWhere((p) => p.id == productId);
    final param = PurchaseParam(productDetails: product);

    inAppPurchase.buyConsumable(purchaseParam: param, autoConsume: true);

    state = state.copyWith(isPurchasePending: true);
  }

  // 앱 내 구매상태 변경 시 콜백
  void onPurchaseUpdated(List<PurchaseDetails> purchases) async {
    state = state.copyWith(isPurchasePending: true);
    bool hasPending = false;

    try {
      for (final purchase in purchases) {
        if (purchase.status == PurchaseStatus.pending) {
          hasPending = true;
          continue;
        }
        if (purchase.status == PurchaseStatus.purchased || purchase.status == PurchaseStatus.restored) {
          final String jwsToken = purchase.verificationData.serverVerificationData;

          try {  
            await verifyReceipt(jwsToken);
            
            if (purchase.pendingCompletePurchase) {
              await InAppPurchase.instance.completePurchase(purchase);
            }
          } catch (e) {
            if (e is NetworkException && e.status == 400) {
              await InAppPurchase.instance.completePurchase(purchase);
            } else {
              Log.e('Receipt verification failed: $e');
            }
          }
        } else if (purchase.status == PurchaseStatus.error || purchase.status == PurchaseStatus.canceled) {
          if (purchase.pendingCompletePurchase) {
            await InAppPurchase.instance.completePurchase(purchase);
          }
          state = state.copyWith(isPurchasePending: false);
          Log.e('Purchase failed or canceled: ${purchase.error}');
        }
      }
    } catch (e) {
      Log.e('Purchase stream error: $e');
    } finally {
      state = state.copyWith(isPurchasePending: hasPending);
      await fetchHeartBalance();
    }
  }

  // 보유하트 조회
  Future<void> _initializeHeartBalanceItem() async {
    try {
      final heartBalance = ref.read(globalProvider).heartBalance;

      state = state.copyWith(
        heartBalance: heartBalance,
        isLoaded: true,
        error: null,
      );
    } catch (e) {
      Log.e(e);
      state = state.copyWith(
        isLoaded: true,
        error: HeartBalanceErrorType.network,
      );
    }
  }

  // 보유하트 수 재조회
  Future<void> fetchHeartBalance() async {
    try {
      await ref.read(globalProvider.notifier).fetchHeartBalance();
    } catch (e) {
      Log.e('Failed to fetch heart balance: $e');
      return;
    } finally {
      if (ref.mounted) {
        state = state.copyWith(
          heartBalance: ref.watch(globalProvider).heartBalance,
          isLoaded: true,
          error: null,
        );
      }
    }
  }

  Future<void> verifyReceipt(String appReceipt) async {
    final useCase = ref.read(verifyReceiptUseCaseProvider);

    await useCase.call(appReceipt: appReceipt);
  }
}
