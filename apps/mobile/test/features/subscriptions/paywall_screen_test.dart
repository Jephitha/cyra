import 'dart:async';

import 'package:cyra/features/subscriptions/paywall_screen.dart';
import 'package:cyra/features/subscriptions/subscription_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

void main() {
  testWidgets('shows store pricing and explains what remains free', (
    tester,
  ) async {
    final gateway = _PaywallGateway();
    final controller = SubscriptionController(
      gateway,
      const PlatformPurchaseVerifier(),
    );
    await controller.initialize();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          subscriptionControllerProvider.overrideWith((_) => controller),
        ],
        child: const MaterialApp(home: PaywallScreen()),
      ),
    );

    expect(find.text('Cyra Premium'), findsOneWidget);
    expect(find.text('KES 299 / month', skipOffstage: false), findsOneWidget);
    expect(
      find.textContaining(
        'privacy controls, data deletion, and a basic export always remain free',
      ),
      findsOneWidget,
    );
    expect(find.text('Restore purchases', skipOffstage: false), findsOneWidget);

    await tester.pumpWidget(const SizedBox.shrink());
    await gateway.dispose();
  });
}

class _PaywallGateway implements PurchaseGateway {
  final updates = StreamController<List<PurchaseDetails>>.broadcast();

  @override
  Stream<List<PurchaseDetails>> get purchaseStream => updates.stream;

  @override
  Future<bool> isAvailable() async => true;

  @override
  Future<ProductDetailsResponse> queryProducts(Set<String> productIds) async {
    return ProductDetailsResponse(
      productDetails: [
        ProductDetails(
          id: cyraPremiumMonthlyProduct,
          title: 'Monthly',
          description: 'Monthly subscription',
          price: 'KES 299',
          rawPrice: 299,
          currencyCode: 'KES',
        ),
      ],
      notFoundIDs: const [],
    );
  }

  @override
  Future<bool> purchase(ProductDetails product) async => true;

  @override
  Future<void> restore() async {}

  @override
  Future<void> complete(PurchaseDetails purchase) async {}

  Future<void> dispose() => updates.close();
}
