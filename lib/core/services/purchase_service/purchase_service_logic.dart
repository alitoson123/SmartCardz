import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:smart_cards/constant.dart';


/// Wraps RevenueCat SDK calls and surfaces typed results.
class PurchaseServiceLigic {
  // ─── Singleton ────────────────────────────────────────────────────────────

  PurchaseServiceLigic._internal() {
    Purchases.addCustomerInfoUpdateListener((info) {
      _customerInfoController.add(info);
    });
  }
  static final PurchaseServiceLigic instance = PurchaseServiceLigic._internal();

  final StreamController<CustomerInfo> _customerInfoController =
      StreamController<CustomerInfo>.broadcast();

  // ─── Customer Info ────────────────────────────────────────────────────────

  /// Fetches the latest CustomerInfo (cached by SDK, very fast).
  Future<CustomerInfo?> getCustomerInfo() async {
    try {
      return await Purchases.getCustomerInfo();
    } on PlatformException catch (e) {
      debugPrint('[RC] getCustomerInfo error: ${e.message}');
      return null;
    }
  }

  /// Stream of CustomerInfo updates.
  /// Listen to this in your root widget/BLoC to react immediately to changes.
  Stream<CustomerInfo> get customerInfoStream => _customerInfoController.stream;

  // ─── Entitlement Check ────────────────────────────────────────────────────

  /// Returns true if the user has an active "cardify_pro" entitlement.
  Future<bool> isProUser() async {
    final info = await getCustomerInfo();
    return info?.entitlements.active
            .containsKey(AppConstants.proEntitlementId) ??
        false;
  }

  /// Synchronous check using a cached CustomerInfo object.
  bool isProUserFromInfo(CustomerInfo info) {
    return info.entitlements.active
        .containsKey(AppConstants.proEntitlementId);
  }

  // ─── Offerings ────────────────────────────────────────────────────────────

  /// Fetches available offerings from RevenueCat.
  Future<Offerings?> getOfferings() async {
    try {
      return await Purchases.getOfferings();
    } on PlatformException catch (e) {
      debugPrint('[RC] getOfferings error: ${e.message}');
      return null;
    }
  }

  /// Returns the current (default) offering, or null if unavailable.
  Future<Offering?> getCurrentOffering() async {
    final offerings = await getOfferings();
    return offerings?.current;
  }

  /// Returns a specific offering by identifier.
  Future<Offering?> getOffering(String identifier) async {
    final offerings = await getOfferings();
    return offerings?.all[identifier];
  }

  // ─── Purchase ─────────────────────────────────────────────────────────────

  /// Purchases a [Package] directly (e.g. from a custom paywall).
  Future<AppPurchaseResult> purchase(Package package) async {
    try {
      final rcResult = await Purchases.purchasePackage(package);
      final CustomerInfo info = rcResult.customerInfo;
      final bool isPro = isProUserFromInfo(info);
      return AppPurchaseResult(
        success: isPro,
        customerInfo: info,
      );
    } on PlatformException catch (e) {
      final bool userCancelled =
          PurchasesErrorHelper.getErrorCode(e) ==
              PurchasesErrorCode.purchaseCancelledError;
      return AppPurchaseResult(
        success: false,
        cancelled: userCancelled,
        errorMessage: userCancelled ? null : e.message,
      );
    }
  }

  // ─── Restore ──────────────────────────────────────────────────────────────

  /// Restores previous purchases (required by Apple guidelines).
  Future<AppPurchaseResult> restorePurchases() async {
    try {
      final CustomerInfo info = await Purchases.restorePurchases();
      final bool isPro = isProUserFromInfo(info);
      return AppPurchaseResult(
        success: isPro,
        customerInfo: info,
        restoredWithNoPurchases: !isPro,
      );
    } on PlatformException catch (e) {
      return AppPurchaseResult(
        success: false,
        errorMessage: e.message,
      );
    }
  }
}

// ─── Result Model ─────────────────────────────────────────────────────────────

class AppPurchaseResult {
  final bool success;
  final bool cancelled;
  final bool restoredWithNoPurchases;
  final CustomerInfo? customerInfo;
  final String? errorMessage;

  const AppPurchaseResult({
    required this.success,
    this.cancelled = false,
    this.restoredWithNoPurchases = false,
    this.customerInfo,
    this.errorMessage,
  });
}