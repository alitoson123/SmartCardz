import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class PromoCodeResult {
  final bool success;
  final String? errorMessageKey;
  final int durationDays;

  const PromoCodeResult({
    required this.success,
    this.errorMessageKey,
    this.durationDays = 0,
  });
}

class PromoCodeService {
  PromoCodeService._();
  static final PromoCodeService instance = PromoCodeService._();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  DateTime? _cachedProUntil;
  String? _cachedUserId;

  /// Validates and redeems a promo code for the authenticated user.
  Future<PromoCodeResult> redeemCode(String rawCode) async {
    final user = _auth.currentUser;
    if (user == null) {
      return const PromoCodeResult(
        success: false,
        errorMessageKey: 'mustBeLoggedInToRedeem',
      );
    }

    final code = rawCode.trim().toUpperCase();
    if (code.isEmpty) {
      return const PromoCodeResult(
        success: false,
        errorMessageKey: 'invalidCode',
      );
    }

    try {
      final docRef = await _findCodeDocument(code);
      if (docRef == null) {
        return const PromoCodeResult(
          success: false,
          errorMessageKey: 'invalidCode',
        );
      }

      return await _executeRedemptionTransaction(docRef, user.uid, code);
    } catch (e) {
      debugPrint('[PromoCodeService] Error redeeming code: $e');
      return const PromoCodeResult(
        success: false,
        errorMessageKey: 'invalidCode',
      );
    }
  }

  /// Finds the document reference by ID
  Future<DocumentReference<Map<String, dynamic>>?> _findCodeDocument(
    String code,
  ) async {
    final directDoc = _firestore.collection('promo_codes').doc(code);
    final directSnap = await directDoc.get();
    if (directSnap.exists) return directDoc;

    return null;
  }

  /// Atomically validates, burns the code, and grants Pro status to the user.
  Future<PromoCodeResult> _executeRedemptionTransaction(
    DocumentReference<Map<String, dynamic>> codeRef,
    String uid,
    String code,
  ) async {
    final userRef = _firestore.collection('users').doc(uid);

    return await _firestore.runTransaction<PromoCodeResult>((tx) async {
      final codeSnap = await tx.get(codeRef);
      final codeData = codeSnap.data();

      final validationKey = _validateCodeData(codeData);
      if (validationKey != null) {
        return PromoCodeResult(success: false, errorMessageKey: validationKey);
      }

      final int duration = (codeData?['duration_days'] as num?)?.toInt() ?? 30;

      final userSnap = await tx.get(userRef);
      final newProUntil = _calculateNewProUntil(userSnap.data(), duration);
      final quotaRef = _firestore
          .collection('users')
          .doc(uid)
          .collection('ai_quota')
          .doc('usage');

      tx.update(codeRef, {
        'is_used': true,
        'used_by': uid,
        'used_at': FieldValue.serverTimestamp(),
      });

      tx.set(userRef, {
        'pro_until': Timestamp.fromDate(newProUntil),
        'is_pro': true,
        'last_redeemed_code': code,
      }, SetOptions(merge: true));

      // Reset AI quota usage to 0 for the fresh subscription period
      tx.set(quotaRef, {
        'premiumImageCardsUsed': 0,
        'premiumTextCardsUsed': 0,
        'premiumPeriodEnd': Timestamp.fromDate(newProUntil),
      }, SetOptions(merge: true));

      _cachedProUntil = newProUntil;
      _cachedUserId = uid;

      return PromoCodeResult(success: true, durationDays: duration);
    });
  }

  /// Checks if code is already used or expired.
  String? _validateCodeData(Map<String, dynamic>? data) {
    if (data == null) return 'invalidCode';
    if (data['is_used'] == true) return 'codeAlreadyUsed';

    final expiresAt = data['expires_at'] as Timestamp?;
    if (expiresAt != null && expiresAt.toDate().isBefore(DateTime.now())) {
      return 'codeExpired';
    }
    return null;
  }

  /// Calculates new expiration date, stacking duration if user is already Pro.
  DateTime _calculateNewProUntil(Map<String, dynamic>? userData, int days) {
    final currentUntil = (userData?['pro_until'] as Timestamp?)?.toDate();
    final now = DateTime.now();
    final baseDate = (currentUntil != null && currentUntil.isAfter(now))
        ? currentUntil
        : now;
    return baseDate.add(Duration(days: days));
  }

  /// Checks if current user has an active, unexpired promo Pro entitlement.
  Future<bool> isPromoProActive() async {
    final user = _auth.currentUser;
    if (user == null) return false;

    if (_cachedUserId == user.uid && _cachedProUntil != null) {
      if (_cachedProUntil!.isAfter(DateTime.now())) return true;
    }

    try {
      final snap = await _firestore.collection('users').doc(user.uid).get();
      if (!snap.exists) return false;

      final proUntil = (snap.data()?['pro_until'] as Timestamp?)?.toDate();
      if (proUntil != null && proUntil.isAfter(DateTime.now())) {
        _cachedProUntil = proUntil;
        _cachedUserId = user.uid;
        return true;
      }
    } catch (e) {
      debugPrint('[PromoCodeService] isPromoProActive error: $e');
    }

    _cachedProUntil = null;
    return false;
  }

  /// Synchronous check using cached Pro expiration.
  bool isPromoProActiveSync() {
    final user = _auth.currentUser;
    if (user == null || _cachedUserId != user.uid || _cachedProUntil == null) {
      return false;
    }
    return _cachedProUntil!.isAfter(DateTime.now());
  }

  /// Returns the pro_until DateTime if active, checking cache first then Firestore.
  Future<DateTime?> getProUntil(String uid) async {
    if (_cachedUserId == uid && _cachedProUntil != null) {
      return _cachedProUntil;
    }
    try {
      final snap = await _firestore.collection('users').doc(uid).get();
      final proUntil = (snap.data()?['pro_until'] as Timestamp?)?.toDate();
      if (proUntil != null) {
        _cachedProUntil = proUntil;
        _cachedUserId = uid;
      }
      return proUntil;
    } catch (e) {
      debugPrint('[PromoCodeService] getProUntil error: $e');
      return null;
    }
  }

  /// Clears cache on user sign-out.
  void clearCache() {
    _cachedProUntil = null;
    _cachedUserId = null;
  }
}
