import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

const cyraPremiumEntitlement = 'cyra_premium';
const cyraPremiumMonthlyProduct = 'cyra_premium_monthly';
const cyraPremiumAnnualProduct = 'cyra_premium_annual';
const cyraPremiumProductIds = <String>{
  cyraPremiumMonthlyProduct,
  cyraPremiumAnnualProduct,
};

class SubscriptionState {
  const SubscriptionState({
    this.isLoading = true,
    this.isStoreAvailable = false,
    this.isPremium = false,
    this.isPurchasePending = false,
    this.products = const [],
    this.errorMessage,
  });

  final bool isLoading;
  final bool isStoreAvailable;
  final bool isPremium;
  final bool isPurchasePending;
  final List<ProductDetails> products;
  final String? errorMessage;

  SubscriptionState copyWith({
    bool? isLoading,
    bool? isStoreAvailable,
    bool? isPremium,
    bool? isPurchasePending,
    List<ProductDetails>? products,
    String? errorMessage,
    bool clearError = false,
  }) {
    return SubscriptionState(
      isLoading: isLoading ?? this.isLoading,
      isStoreAvailable: isStoreAvailable ?? this.isStoreAvailable,
      isPremium: isPremium ?? this.isPremium,
      isPurchasePending: isPurchasePending ?? this.isPurchasePending,
      products: products ?? this.products,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}

abstract class PurchaseGateway {
  Stream<List<PurchaseDetails>> get purchaseStream;

  Future<bool> isAvailable();
  Future<ProductDetailsResponse> queryProducts(Set<String> productIds);
  Future<bool> purchase(ProductDetails product);
  Future<void> restore();
  Future<void> complete(PurchaseDetails purchase);
}

class InAppPurchaseGateway implements PurchaseGateway {
  InAppPurchaseGateway([InAppPurchase? store])
    : _store = store ?? InAppPurchase.instance;

  final InAppPurchase _store;

  @override
  Stream<List<PurchaseDetails>> get purchaseStream => _store.purchaseStream;

  @override
  Future<bool> isAvailable() => _store.isAvailable();

  @override
  Future<ProductDetailsResponse> queryProducts(Set<String> productIds) =>
      _store.queryProductDetails(productIds);

  @override
  Future<bool> purchase(ProductDetails product) => _store.buyNonConsumable(
    purchaseParam: PurchaseParam(productDetails: product),
  );

  @override
  Future<void> restore() => _store.restorePurchases();

  @override
  Future<void> complete(PurchaseDetails purchase) =>
      _store.completePurchase(purchase);
}

abstract class PurchaseVerifier {
  Future<bool> verify(PurchaseDetails purchase);
}

/// Accepts only recognized products accompanied by a store verification payload.
///
/// The platform billing SDK supplies this payload from StoreKit or Google Play.
/// A release backend can replace this verifier with server-side receipt validation
/// without changing the entitlement controller.
class PlatformPurchaseVerifier implements PurchaseVerifier {
  const PlatformPurchaseVerifier();

  @override
  Future<bool> verify(PurchaseDetails purchase) async {
    if (!cyraPremiumProductIds.contains(purchase.productID)) return false;
    final verification = purchase.verificationData;
    return verification.source.trim().isNotEmpty &&
        verification.serverVerificationData.trim().isNotEmpty;
  }
}

class SubscriptionController extends StateNotifier<SubscriptionState> {
  SubscriptionController(this._gateway, this._verifier)
    : super(const SubscriptionState());

  final PurchaseGateway _gateway;
  final PurchaseVerifier _verifier;
  StreamSubscription<List<PurchaseDetails>>? _purchaseSubscription;
  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) return;
    _initialized = true;
    _purchaseSubscription = _gateway.purchaseStream.listen(
      _handlePurchaseUpdates,
      onError: (Object error, StackTrace _) {
        state = state.copyWith(
          isLoading: false,
          isPurchasePending: false,
          errorMessage: 'Could not read purchase updates. Try again later.',
        );
      },
    );

    try {
      final available = await _gateway.isAvailable();
      if (!available) {
        state = state.copyWith(
          isLoading: false,
          isStoreAvailable: false,
          errorMessage: 'Subscriptions are unavailable on this device.',
        );
        return;
      }

      final response = await _gateway.queryProducts(cyraPremiumProductIds);
      final products = [...response.productDetails]
        ..sort((a, b) => a.rawPrice.compareTo(b.rawPrice));
      state = state.copyWith(
        isLoading: false,
        isStoreAvailable: true,
        products: products,
        clearError: response.error == null,
        errorMessage: response.error?.message,
      );
    } catch (_) {
      state = state.copyWith(
        isLoading: false,
        isStoreAvailable: false,
        errorMessage: 'Could not connect to the app store. Try again later.',
      );
    }
  }

  Future<void> purchase(ProductDetails product) async {
    if (!state.isStoreAvailable ||
        !cyraPremiumProductIds.contains(product.id)) {
      state = state.copyWith(errorMessage: 'This subscription is unavailable.');
      return;
    }
    state = state.copyWith(isPurchasePending: true, clearError: true);
    try {
      final started = await _gateway.purchase(product);
      if (!started) {
        state = state.copyWith(
          isPurchasePending: false,
          errorMessage: 'The purchase could not be started.',
        );
      }
    } catch (_) {
      state = state.copyWith(
        isPurchasePending: false,
        errorMessage: 'The purchase could not be started.',
      );
    }
  }

  Future<void> restore() async {
    if (!state.isStoreAvailable) return;
    state = state.copyWith(isPurchasePending: true, clearError: true);
    try {
      await _gateway.restore();
      state = state.copyWith(isPurchasePending: false);
    } catch (_) {
      state = state.copyWith(
        isPurchasePending: false,
        errorMessage: 'Purchases could not be restored. Try again later.',
      );
    }
  }

  Future<void> _handlePurchaseUpdates(List<PurchaseDetails> purchases) async {
    for (final purchase in purchases) {
      switch (purchase.status) {
        case PurchaseStatus.pending:
          state = state.copyWith(isPurchasePending: true, clearError: true);
          break;
        case PurchaseStatus.purchased:
        case PurchaseStatus.restored:
          final verified = await _verifier.verify(purchase);
          state = state.copyWith(
            isPremium: verified,
            isPurchasePending: false,
            clearError: verified,
            errorMessage: verified
                ? null
                : 'The store receipt could not be verified.',
          );
          if (verified && purchase.pendingCompletePurchase) {
            await _gateway.complete(purchase);
          }
          break;
        case PurchaseStatus.error:
          state = state.copyWith(
            isPurchasePending: false,
            errorMessage: purchase.error?.message ?? 'The purchase failed.',
          );
          break;
        case PurchaseStatus.canceled:
          state = state.copyWith(
            isPurchasePending: false,
            errorMessage: 'Purchase canceled.',
          );
          break;
      }
    }
  }

  @override
  void dispose() {
    _purchaseSubscription?.cancel();
    super.dispose();
  }
}

final purchaseGatewayProvider = Provider<PurchaseGateway>(
  (_) => InAppPurchaseGateway(),
);

final purchaseVerifierProvider = Provider<PurchaseVerifier>(
  (_) => const PlatformPurchaseVerifier(),
);

final subscriptionControllerProvider =
    StateNotifierProvider<SubscriptionController, SubscriptionState>((ref) {
      final controller = SubscriptionController(
        ref.watch(purchaseGatewayProvider),
        ref.watch(purchaseVerifierProvider),
      );
      unawaited(controller.initialize());
      return controller;
    });

final isPremiumProvider = Provider<bool>(
  (ref) => ref.watch(subscriptionControllerProvider).isPremium,
);
