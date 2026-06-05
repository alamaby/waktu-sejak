import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

const supportProductTiers = <SupportProductTier>[
  SupportProductTier(productId: 'support_developer_1', fallbackPrice: r'$1'),
  SupportProductTier(productId: 'support_developer_2', fallbackPrice: r'$2'),
  SupportProductTier(productId: 'support_developer_5', fallbackPrice: r'$5'),
  SupportProductTier(productId: 'support_developer_10', fallbackPrice: r'$10'),
];

final supportBillingControllerProvider =
    StateNotifierProvider<SupportBillingController, SupportBillingState>((ref) {
  final controller = SupportBillingController(InAppPurchase.instance);
  ref.onDispose(controller.dispose);
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
  final String? completedProductId;
  final SupportBillingError? error;

  const SupportBillingState({
    this.isLoading = true,
    this.isStoreAvailable = false,
    this.productsById = const {},
    this.activeProductId,
    this.completedProductId,
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
    String? completedProductId,
    bool clearCompletedProductId = false,
    SupportBillingError? error,
    bool clearError = false,
  }) {
    return SupportBillingState(
      isLoading: isLoading ?? this.isLoading,
      isStoreAvailable: isStoreAvailable ?? this.isStoreAvailable,
      productsById: productsById ?? this.productsById,
      activeProductId:
          clearActiveProductId ? null : activeProductId ?? this.activeProductId,
      completedProductId: clearCompletedProductId
          ? null
          : completedProductId ?? this.completedProductId,
      error: clearError ? null : error ?? this.error,
    );
  }
}

enum SupportBillingError {
  storeUnavailable,
  productsUnavailable,
  purchaseFailed,
}

class SupportBillingController extends StateNotifier<SupportBillingState> {
  final InAppPurchase _iap;
  StreamSubscription<List<PurchaseDetails>>? _purchaseSubscription;

  SupportBillingController(this._iap) : super(const SupportBillingState());

  Future<void> initialize() async {
    _purchaseSubscription = _iap.purchaseStream.listen(
      _handlePurchases,
      onError: (_) => state = state.copyWith(
        isLoading: false,
        clearActiveProductId: true,
        error: SupportBillingError.purchaseFailed,
      ),
    );

    try {
      final available = await _iap.isAvailable();
      if (!available) {
        state = state.copyWith(
          isLoading: false,
          isStoreAvailable: false,
          error: SupportBillingError.storeUnavailable,
        );
        return;
      }

      final response = await _iap.queryProductDetails(_productIds);
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
      clearCompletedProductId: true,
      clearError: true,
    );

    try {
      final started = await _iap.buyConsumable(
        purchaseParam: PurchaseParam(productDetails: product),
      );
      if (!started) {
        state = state.copyWith(
          clearActiveProductId: true,
          error: SupportBillingError.purchaseFailed,
        );
      }
    } catch (_) {
      state = state.copyWith(
        clearActiveProductId: true,
        error: SupportBillingError.purchaseFailed,
      );
    }
  }

  Future<void> _handlePurchases(List<PurchaseDetails> purchases) async {
    for (final purchase in purchases) {
      if (!_productIds.contains(purchase.productID)) continue;

      switch (purchase.status) {
        case PurchaseStatus.pending:
          state = state.copyWith(
            activeProductId: purchase.productID,
            clearError: true,
          );
          break;
        case PurchaseStatus.error:
        case PurchaseStatus.canceled:
          state = state.copyWith(
            clearActiveProductId: true,
            error: SupportBillingError.purchaseFailed,
          );
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
      if (purchase.pendingCompletePurchase) {
        await _iap.completePurchase(purchase);
      }
      state = state.copyWith(
        clearActiveProductId: true,
        completedProductId: purchase.productID,
        clearError: true,
      );
    } catch (_) {
      state = state.copyWith(
        clearActiveProductId: true,
        error: SupportBillingError.purchaseFailed,
      );
    }
  }

  @override
  void dispose() {
    unawaited(_purchaseSubscription?.cancel());
    super.dispose();
  }

  static final _productIds =
      supportProductTiers.map((tier) => tier.productId).toSet();
}
