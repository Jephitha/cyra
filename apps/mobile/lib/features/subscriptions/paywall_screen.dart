import 'package:cyra/core/design/app_colors.dart';
import 'package:cyra/core/design/tokens/app_spacing.dart';
import 'package:cyra/core/design/widgets/app_button.dart';
import 'package:cyra/core/design/widgets/app_card.dart';
import 'package:cyra/features/subscriptions/subscription_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class PaywallScreen extends ConsumerWidget {
  const PaywallScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(subscriptionControllerProvider);
    ref.listen(subscriptionControllerProvider, (previous, next) {
      if (next.isPremium && previous?.isPremium != true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cyra Premium is now active.')),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Cyra Premium')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          Icon(Icons.auto_awesome_rounded, size: 56, color: AppColors.softGold),
          const SizedBox(height: AppSpacing.lg),
          Text(
            state.isPremium ? 'Premium is active' : 'More context, less effort',
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            state.isPremium
                ? 'Thank you for supporting private, ad-free health tracking.'
                : 'Upgrade for automatic wearable sync and advanced multi-cycle analysis.',
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(color: AppColors.slate),
          ),
          const SizedBox(height: AppSpacing.xl),
          const _BenefitRow(
            icon: Icons.watch_outlined,
            text: 'Apple Health and Health Connect synchronization',
          ),
          const _BenefitRow(
            icon: Icons.insights_outlined,
            text: 'Advanced longitudinal trends and correlations',
          ),
          const _BenefitRow(
            icon: Icons.lock_outline,
            text: 'Private, on-device processing with no ads',
          ),
          const SizedBox(height: AppSpacing.xl),
          AppCard.standard(
            child: Text(
              'Core tracking, prediction explanations, privacy controls, and exporting your data always remain free.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          if (state.isLoading)
            const Center(child: CircularProgressIndicator())
          else if (state.isPremium)
            AppButton.primary(
              'Premium active',
              icon: Icons.check_circle_outline,
              onPressed: null,
              width: double.infinity,
            )
          else ...[
            for (final product in state.products) ...[
              _ProductButton(
                product: product,
                isPending: state.isPurchasePending,
                onPressed: () => ref
                    .read(subscriptionControllerProvider.notifier)
                    .purchase(product),
              ),
              const SizedBox(height: AppSpacing.sm),
            ],
            if (state.products.isEmpty)
              Text(
                state.isStoreAvailable
                    ? 'Subscription products are not configured for this store account yet.'
                    : 'Subscriptions are unavailable on this device.',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.slate),
              ),
          ],
          if (state.errorMessage != null) ...[
            const SizedBox(height: AppSpacing.md),
            Text(
              state.errorMessage!,
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.error),
            ),
          ],
          const SizedBox(height: AppSpacing.md),
          TextButton(
            onPressed: state.isStoreAvailable && !state.isPurchasePending
                ? () => ref
                      .read(subscriptionControllerProvider.notifier)
                      .restore()
                : null,
            child: const Text('Restore purchases'),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Payment, renewal, cancellation, and any introductory offer are managed by your app store. Prices shown above come directly from the store.',
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: AppColors.slate),
          ),
        ],
      ),
    );
  }
}

class _ProductButton extends StatelessWidget {
  const _ProductButton({
    required this.product,
    required this.isPending,
    required this.onPressed,
  });

  final ProductDetails product;
  final bool isPending;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final period = product.id == cyraPremiumAnnualProduct ? 'year' : 'month';
    return AppButton.primary(
      '${product.price} / $period',
      isLoading: isPending,
      onPressed: isPending ? null : onPressed,
      width: double.infinity,
    );
  }
}

class _BenefitRow extends StatelessWidget {
  const _BenefitRow({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Row(
        children: [
          Icon(icon, color: AppColors.forestGreen),
          const SizedBox(width: AppSpacing.md),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}
