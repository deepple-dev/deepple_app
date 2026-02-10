import 'dart:async';
import 'package:deepple_app/core/network/network_exception.dart';
import 'package:deepple_app/app/provider/global_notifier.dart';
import 'package:deepple_app/core/util/log.dart';
import 'package:deepple_app/features/store/domain/provider/usecase_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:collection/collection.dart';
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

  static const String _errorCodeAlreadyInProgress = '400102';

  StreamSubscription<List<PurchaseDetails>>? _subscription;

  @override
  StoreState build() {
    ref.onDispose(() {
      _subscription?.cancel();
    });

    _initialize();

    return StoreState.initial();
  }

  Future<void> _initialize() async {
    await _initializeAppPurchase();
    _initializeHeartBalanceItem();
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
    final product = state.products.firstWhereOrNull((p) => p.id == productId);

    if (product == null) return;

    final param = PurchaseParam(productDetails: product);

    state = state.copyWith(isPurchasePending: true);

    InAppPurchase.instance.buyConsumable(purchaseParam: param);
  }

  // 앱 내 구매상태 변경 시 콜백
  void onPurchaseUpdated(List<PurchaseDetails> purchases) async {
    try {
      for (final purchase in purchases) {
        switch (purchase.status) {
          case PurchaseStatus.pending:
            state = state.copyWith(isPurchasePending: true);

          case PurchaseStatus.purchased || PurchaseStatus.restored:
            await _handleSuccessfulPurchase(purchase);

          case PurchaseStatus.error || PurchaseStatus.canceled:
            await _handleFailedPurchase(purchase);
        }
      }
    } catch (e) {
      Log.e('Unexpected error in purchase update: $e');
      state = state.copyWith(isPurchasePending: false);
    }
  }

  // 성공한 결제 처리 (영수증 검증 포함)
  Future<void> _handleSuccessfulPurchase(PurchaseDetails purchase) async {
    try {
      final String jwsToken = purchase.verificationData.serverVerificationData;

      await verifyReceipt(jwsToken);

      if (purchase.pendingCompletePurchase) {
        await InAppPurchase.instance.completePurchase(purchase);
      }
    } on NetworkException catch (e) {
      if (e.code.toString() == _errorCodeAlreadyInProgress) {
        await InAppPurchase.instance.completePurchase(purchase);
        return;
      }
      Log.e('Receipt verification failed: $e');
    } finally {
      await fetchHeartBalance();
      state = state.copyWith(isPurchasePending: false);
    }
  }

  /// 실패한 결제 처리
  Future<void> _handleFailedPurchase(PurchaseDetails purchase) async {
    Log.e('Purchase failed: ${purchase.error?.message}');

    if (purchase.pendingCompletePurchase) {
      await InAppPurchase.instance.completePurchase(purchase);
    }

    state = state.copyWith(isPurchasePending: false);
  }

  // 보유하트 조회
  void _initializeHeartBalanceItem() {
    try {
      final heartBalance = ref.read(globalProvider).heartBalance;
      state = state.copyWith(heartBalance: heartBalance);
    } catch (e) {
      Log.e('Heart balance init error: $e');
    }
  }

  // 보유하트 수 재조회
  Future<void> fetchHeartBalance() async {
    try {
      await ref.read(globalProvider.notifier).fetchHeartBalance();
      state = state.copyWith(
        heartBalance: ref.read(globalProvider).heartBalance,
      );
    } catch (e) {
      Log.e('Failed to fetch heart balance: $e');
    }
  }

  Future<void> verifyReceipt(String appReceipt) async {
    final useCase = ref.read(verifyReceiptUseCaseProvider);

    await useCase.call(appReceipt: appReceipt);
  }
}
