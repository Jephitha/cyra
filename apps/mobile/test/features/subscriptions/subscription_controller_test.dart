import 'dart:async';

import 'package:cyra/features/subscriptions/subscription_controller.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

void main() {
  late _FakeGateway gateway;
  late SubscriptionController controller;

  setUp(() {
    gateway = _FakeGateway();
    controller = SubscriptionController(
      gateway,
      const PlatformPurchaseVerifier(),
    );
  });

  tearDown(() async {
    controller.dispose();
    await gateway.dispose();
  });

  test('loads store products and preserves store-provided pricing', () async {
    await controller.initialize();

    expect(controller.state.isStoreAvailable, isTrue);
    expect(controller.state.products.map((p) => p.price), [
      'KES 299',
      'KES 2999',
    ]);
  });

  test(
    'verified store purchase grants premium and completes transaction',
    () async {
      await controller.initialize();
      final purchase = _purchase(
        productId: cyraPremiumMonthlyProduct,
        receipt: 'signed-store-receipt',
      )..pendingCompletePurchase = true;

      gateway.updates.add([purchase]);
      await Future<void>.delayed(Duration.zero);

      expect(controller.state.isPremium, isTrue);
      expect(gateway.completed, [purchase]);
    },
  );

  test('missing verification payload fails closed', () async {
    await controller.initialize();

    gateway.updates.add([
      _purchase(productId: cyraPremiumAnnualProduct, receipt: ''),
    ]);
    await Future<void>.delayed(Duration.zero);

    expect(controller.state.isPremium, isFalse);
    expect(controller.state.errorMessage, contains('could not be verified'));
  });

  test('restore delegates to the platform store', () async {
    await controller.initialize();

    await controller.restore();

    expect(gateway.restoreCalls, 1);
  });
}

PurchaseDetails _purchase({
  required String productId,
  required String receipt,
}) {
  return PurchaseDetails(
    purchaseID: 'purchase-1',
    productID: productId,
    verificationData: PurchaseVerificationData(
      localVerificationData: receipt,
      serverVerificationData: receipt,
      source: 'test_store',
    ),
    transactionDate: DateTime.now().millisecondsSinceEpoch.toString(),
    status: PurchaseStatus.purchased,
  );
}

class _FakeGateway implements PurchaseGateway {
  final updates = StreamController<List<PurchaseDetails>>.broadcast();
  final completed = <PurchaseDetails>[];
  var restoreCalls = 0;

  final products = [
    ProductDetails(
      id: cyraPremiumMonthlyProduct,
      title: 'Monthly',
      description: 'Monthly subscription',
      price: 'KES 299',
      rawPrice: 299,
      currencyCode: 'KES',
    ),
    ProductDetails(
      id: cyraPremiumAnnualProduct,
      title: 'Annual',
      description: 'Annual subscription',
      price: 'KES 2999',
      rawPrice: 2999,
      currencyCode: 'KES',
    ),
  ];

  @override
  Stream<List<PurchaseDetails>> get purchaseStream => updates.stream;

  @override
  Future<bool> isAvailable() async => true;

  @override
  Future<ProductDetailsResponse> queryProducts(Set<String> productIds) async {
    return ProductDetailsResponse(
      productDetails: products,
      notFoundIDs: const [],
    );
  }

  @override
  Future<bool> purchase(ProductDetails product) async => true;

  @override
  Future<void> restore() async {
    restoreCalls++;
  }

  @override
  Future<void> complete(PurchaseDetails purchase) async {
    completed.add(purchase);
  }

  Future<void> dispose() => updates.close();
}
