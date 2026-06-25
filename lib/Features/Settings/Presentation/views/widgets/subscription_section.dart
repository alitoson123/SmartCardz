import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:purchases_ui_flutter/purchases_ui_flutter.dart';
import 'package:smart_cards/core/services/purchase_service/purchase_service_logic.dart';
import 'package:smart_cards/core/view_model/app_purchase_cubit/app_purchase_cubit.dart';
import 'package:smart_cards/core/view_model/app_purchase_cubit/app_purchase_states.dart';

class SubscriptionSection extends StatelessWidget {
  const SubscriptionSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SubscriptionCubit, SubscriptionState>(
      builder: (context, state) {
        final isPro = state is SubscriptionSuccess && state.isPro;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                'SUBSCRIPTION',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.2,
                  color: Colors.grey,
                ),
              ),
            ),

            // Status tile
            ListTile(
              leading: Icon(
                isPro ? Icons.star_rounded : Icons.star_border_rounded,
                color: isPro ? Colors.amber : null,
              ),
              title: Text(isPro ? 'Cardify Pro' : 'Free Plan'),
              subtitle: Text(
                isPro
                    ? 'All features unlocked'
                    : 'Upgrade to unlock unlimited flashcards & AI features',
              ),
              trailing: isPro
                  ? null
                  : FilledButton(
                      onPressed: () => _showPaywall(context),
                      child: const Text('Upgrade'),
                    ),
            ),

            // Manage subscription (Pro users only)
            if (isPro)
              ListTile(
                leading: const Icon(Icons.manage_accounts_outlined),
                title: const Text('Manage Subscription'),
                onTap: () => RevenueCatUI.presentCustomerCenter(),
              ),

            // Restore purchases (Free users or after reinstall)
            if (!isPro)
              ListTile(
                leading: const Icon(Icons.restore_rounded),
                title: const Text('Restore Purchases'),
                onTap: () => _restorePurchases(context),
              ),
          ],
        );
      },
    );
  }

  Future<void> _showPaywall(BuildContext context) async {
    final result = await RevenueCatUI.presentPaywallIfNeeded('cardify_pro');
    if (result == PaywallResult.purchased || result == PaywallResult.restored) {
      context.read<SubscriptionCubit>().checkStatus();
    }
  }

  Future<void> _restorePurchases(BuildContext context) async {
    final result = await PurchaseServiceLigic.instance.restorePurchases();

    if (!context.mounted) return;

    if (result.success) {
      context.read<SubscriptionCubit>().checkStatus();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Purchases restored successfully!')),
      );
    } else if (result.restoredWithNoPurchases) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No previous purchases found.')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result.errorMessage ?? 'Restore failed.')),
      );
    }
  }
}
