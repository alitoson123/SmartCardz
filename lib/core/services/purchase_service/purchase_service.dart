import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class PurchaseService {
  Future<void> identifyUserWithRevenueCat(String firebaseUid) async {
    try {
      final LogInResult result = await Purchases.logIn(firebaseUid);
      debugPrint('[RC] User identified. Created: ${result.created}');
    } on PlatformException catch (e) {
      debugPrint('[RC] Login error: ${e.message}');
    }
  }

  // Call on sign-out:
  Future<void> logOutFromRevenueCat() async {
    try {
      await Purchases.logOut();
    } on PlatformException catch (e) {
      debugPrint('[RC] Logout error: ${e.message}');
    }
  }
}

