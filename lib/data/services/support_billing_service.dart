import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../local/preferences_provider.dart';

const _kSupportDeveloperCountKey = 'support_developer_count';

const supportProductTiers = <SupportProductTier>[
  SupportProductTier(productId: 'support_developer_1', fallbackPrice: r'$1'),
  SupportProductTier(productId: 'support_developer_2', fallbackPrice: r'$2'),
  SupportProductTier(productId: 'support_developer_5', fallbackPrice: r'$5'),
  SupportProductTier(productId: 'support_developer_10', fallbackPrice: r'$10'),
];

final supportBillingControllerProvider =
    StateNotifierProvider<SupportBillingController, SupportBillingState>((ref) {
  final controller = SupportBillingController(
    InAppPurchase.instance,
    ref.read(sharedPreferencesProvider),
  );
  unawaited(controller.initialize());
  return controller;
});

class SupportProductTier {
  final String productId;
  final String fallbackPrice;

  const SupportProductTier({
    required this.productId,
    required this.fallbackPrice,
  });
}

class SupportBillingState {
  final bool isLoading;
  final bool isStoreAvailable;
  final Map<String, ProductDetails> productsById;
  final String? activeProductId;
  final bool isStorePending;
  final String? completedProductId;
  final int completedSupportCount;
  final SupportBillingError? error;

  const SupportBillingState({
    this.isLoading = true,
    this.isStoreAvailable = false,
    this.productsById = const {},
    this.activeProductId,
    this.isStorePending = false,
    this.completedProductId,
    this.completedSupportCount = 0,
    this.error,
  });

  bool get isPurchasing => activeProductId != null;

  ProductDetails? productFor(String productId) => productsById[productId];

  SupportBillingState copyWith({
    bool? isLoading,
    bool? isStoreAvailable,
    Map<String, ProductDetails>? productsById,
    String? activeProductId,
    bool clearActiveProductId = false,
    bool? isStorePending,
    String? completedProductId,
    bool clearCompletedProductId = false,
    int? completedSupportCount,
    SupportBillingError? error,
    bool clearError = false,
  }) {
    return SupportBillingState(
      isLoading: isLoading ?? this.isLoading,
      isStoreAvailable: isStoreAvailable ?? this.isStoreAvailable,
      productsById: productsById ?? this.productsById,
      activeProductId:
          clearActiveProductId ? null : activeProductId ?? this.activeProductId,
      isStorePending:
          clearActiveProductId ? false : isStorePending ?? this.isStorePending,
      completedProductId: clearCompletedProductId
          ? null
          : completedProductId ?? this.completedProductId,
      completedSupportCount:
          completedSupportCount ?? this.completedSupportCount,
      error: clearError ? null : error ?? this.error,
    );
  }
}

enum SupportBillingError {
  storeUnavailable,
  productsUnavailable,
  purchaseFailed,
  purchaseCancelled,
}

class SupportBillingController extends StateNotifier<SupportBillingState> {
  final InAppPurchase _iap;
  final SharedPreferences _prefs;
  StreamSubscription<List<PurchaseDetails>>? _purchaseSubscription;
  Timer? _billingSheetRecoveryTimer;
  Timer? _purchaseLaunchTimeout;

  SupportBillingController(this._iap, this._prefs)
      : super(const SupportBillingState());

  Future<void> initialize() async {
    _purchaseSubscription = _iap.purchaseStream.listen(
      _handlePurchases,
      onError: (_) {
        if (!mounted) return;
        state = state.copyWith(
          isLoading: false,
          clearActiveProductId: true,
          error: SupportBillingError.purchaseFailed,
        );
      },
    );

    try {
      final available = await _iap.isAvailable();
      if (!mounted) return;
      if (!available) {
        state = state.copyWith(
          isLoading: false,
          isStoreAvailable: false,
          error: SupportBillingError.storeUnavailable,
        );
        return;
      }

      final response = await _iap.queryProductDetails(_productIds);
      if (!mounted) return;
      final productsById = {
        for (final product in response.productDetails) product.id: product,
      };

      state = state.copyWith(
        isLoading: false,
        isStoreAvailable: true,
        productsById: productsById,
        error: productsById.isEmpty
            ? SupportBillingError.productsUnavailable
            : null,
        clearError: productsById.isNotEmpty,
      );
    } catch (_) {
      if (!mounted) return;
      state = state.copyWith(
        isLoading: false,
        isStoreAvailable: false,
        error: SupportBillingError.storeUnavailable,
      );
    }
  }

  Future<void> buy(String productId) async {
    if (state.isPurchasing) return;

    final product = state.productFor(productId);
    if (product == null) {
      state = state.copyWith(error: SupportBillingError.productsUnavailable);
      return;
    }

    state = state.copyWith(
      activeProductId: productId,
      isStorePending: false,
      clearCompletedProductId: true,
      clearError: true,
    );
    _startPurchaseLaunchTimeout(productId);

    try {
      final started = await _iap.buyConsumable(
        purchaseParam: PurchaseParam(productDetails: product),
      );
      if (!mounted) return;
      if (!started) {
        state = state.copyWith(
          clearActiveProductId: true,
          error: SupportBillingError.purchaseFailed,
        );
        _clearPurchaseTimers();
      }
    } catch (_) {
      if (!mounted) return;
      state = state.copyWith(
        clearActiveProductId: true,
        error: SupportBillingError.purchaseFailed,
      );
      _clearPurchaseTimers();
    }
  }

  void recoverFromClosedBillingSheet() {
    final activeProductId = state.activeProductId;
    if (activeProductId == null || state.isStorePending) return;

    _billingSheetRecoveryTimer?.cancel();
    _billingSheetRecoveryTimer = Timer(const Duration(seconds: 2), () {
      if (!mounted) return;
      if (state.activeProductId != activeProductId || state.isStorePending) {
        return;
      }
      state = state.copyWith(
        clearActiveProductId: true,
        error: SupportBillingError.purchaseCancelled,
      );
      _clearPurchaseTimers();
    });
  }

  Future<void> _handlePurchases(List<PurchaseDetails> purchases) async {
    for (final purchase in purchases) {
      if (!mounted) return;
      if (!_productIds.contains(purchase.productID)) continue;

      switch (purchase.status) {
        case PurchaseStatus.pending:
          _billingSheetRecoveryTimer?.cancel();
          state = state.copyWith(
            activeProductId: purchase.productID,
            isStorePending: true,
            clearError: true,
          );
          break;
        case PurchaseStatus.error:
        case PurchaseStatus.canceled:
          state = state.copyWith(
            clearActiveProductId: true,
            error: purchase.status == PurchaseStatus.canceled
                ? SupportBillingError.purchaseCancelled
                : SupportBillingError.purchaseFailed,
          );
          _clearPurchaseTimers();
          break;
        case PurchaseStatus.purchased:
        case PurchaseStatus.restored:
          await _completePurchase(purchase);
          break;
      }
    }
  }

  Future<void> _completePurchase(PurchaseDetails purchase) async {
    try {
      _clearPurchaseTimers();
      if (purchase.pendingCompletePurchase) {
        await _iap.completePurchase(purchase);
      }
      if (!mounted) return;
      final supportCount = _incrementSupportCount();
      state = state.copyWith(
        clearActiveProductId: true,
        completedProductId: purchase.productID,
        completedSupportCount: supportCount,
        clearError: true,
      );
    } catch (_) {
      if (!mounted) return;
      state = state.copyWith(
        clearActiveProductId: true,
        error: SupportBillingError.purchaseFailed,
      );
    }
  }

  @override
  void dispose() {
    _clearPurchaseTimers();
    unawaited(_purchaseSubscription?.cancel());
    super.dispose();
  }

  static final _productIds =
      supportProductTiers.map((tier) => tier.productId).toSet();

  int _incrementSupportCount() {
    final next = (_prefs.getInt(_kSupportDeveloperCountKey) ?? 0) + 1;
    unawaited(_prefs.setInt(_kSupportDeveloperCountKey, next));
    return next;
  }

  void _startPurchaseLaunchTimeout(String productId) {
    _purchaseLaunchTimeout?.cancel();
    _purchaseLaunchTimeout = Timer(const Duration(minutes: 2), () {
      if (!mounted) return;
      if (state.activeProductId != productId || state.isStorePending) return;
      state = state.copyWith(
        clearActiveProductId: true,
        error: SupportBillingError.purchaseCancelled,
      );
    });
  }

  void _clearPurchaseTimers() {
    _billingSheetRecoveryTimer?.cancel();
    _billingSheetRecoveryTimer = null;
    _purchaseLaunchTimeout?.cancel();
    _purchaseLaunchTimeout = null;
  }
}
