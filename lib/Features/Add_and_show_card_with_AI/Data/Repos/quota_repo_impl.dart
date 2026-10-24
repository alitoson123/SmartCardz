import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:smart_cards/Features/Add_and_show_card_with_AI/Data/Models/quota_model.dart';
import 'package:smart_cards/Features/Add_and_show_card_with_AI/Domain/Entities/quota_entity.dart';
import 'package:smart_cards/Features/Add_and_show_card_with_AI/Domain/Repos/quota_repo.dart';
import 'package:smart_cards/core/errors/failure.dart';
import 'package:smart_cards/core/services/promo_code_service/promo_code_service.dart';
import 'package:smart_cards/core/services/purchase_service/purchase_service_logic.dart';

class QuotaRepoImpl implements QuotaRepo {
  final FirebaseFirestore firestore;
  final PurchaseServiceLigic purchaseService;

  QuotaRepoImpl({required this.firestore, required this.purchaseService});

  DocumentReference<Map<String, dynamic>> _quotaRef(String userId) {
    return firestore
        .collection('users')
        .doc(userId)
        .collection('ai_quota')
        .doc('usage');
  }

  // this function to get the user quota and reset it if needed
  // and check the  pro user quota and reset it if needed
  @override
  Future<Either<Failure, QuotaModel>> getQuota(String userId) async {
    try {
      final docRef = _quotaRef(userId);
      final docSnap = await docRef.get();
      bool needsUpdate = false;

      QuotaModel quota;
      if (!docSnap.exists) {
        quota = QuotaModel.empty();
        needsUpdate = true; // Add this line!
      } else {
        quota = QuotaModel.fromJson(docSnap.data()!);
      }

      // Check resets

      // 1. Daily text reset
      final now = DateTime.now();
      final lastResetDate = DateTime(
        quota.lastFreeTextReset.year,
        quota.lastFreeTextReset.month,
        quota.lastFreeTextReset.day,
      );
      final todayDate = DateTime(now.year, now.month, now.day);

      if (todayDate.isAfter(lastResetDate)) {
        quota = quota.copyWith(freeTextUsedToday: 0, lastFreeTextReset: now);
        needsUpdate = true;
      }

      // 2. Premium reset checking RevenueCat & Promo Code
      final isPro = await purchaseService.isProUser();
      if (isPro) {
        DateTime? activePeriodEnd;

        // Check RevenueCat first
        final customerInfo = await purchaseService.getCustomerInfo();
        final entitlement = customerInfo?.entitlements.active['cardify_pro'];
        if (entitlement != null && entitlement.expirationDate != null) {
          activePeriodEnd = DateTime.tryParse(entitlement.expirationDate!);
        }

        // If not from RevenueCat, check Promo Code pro_until
        activePeriodEnd ??= await PromoCodeService.instance.getProUntil(userId);

        // If we haven't stored a period end, or the new period end is newer than what we stored
        if (quota.premiumPeriodEnd == null ||
            (activePeriodEnd != null &&
                activePeriodEnd.isAfter(quota.premiumPeriodEnd!))) {
          quota = quota.copyWith(
            premiumImageCardsUsed: 0,
            premiumTextCardsUsed: 0,
            premiumPeriodEnd: activePeriodEnd,
          );
          needsUpdate = true;
        }
      } else {
        // Not a pro user anymore
        if (quota.premiumPeriodEnd != null) {
          quota = quota.copyWith(premiumPeriodEnd: null);
          needsUpdate = true;
        }
      }

      if (needsUpdate) {
        await docRef.set(quota.toJson());
      }

      return Right(quota);
    } catch (e) {
      if (e is FirebaseException) {
        return Left(ServerFailure.fromFirebaseError(e));
      }
      return Left(ServerFailure(errorMessage: e.toString()));
    }
  }

  //  this function to check if the user can generate cards
  //  and it will reture the allowed count  based on the user role
  @override
  Future<Either<Failure, int>> canGenerateCards({
    required String userId,
    required int requestedCount,
    required bool withImage,
  }) async {
    try {
      final quotaResult = await getQuota(userId);
      return quotaResult.fold((failure) => Left(failure), (quota) async {
        final isPro = await purchaseService.isProUser();
        int allowedCount = 0;
        //  Pro
        if (isPro) {
          if (withImage) {
            // Pro Image tier (120 per month)
            final remaining =
                QuotaEntity.premiumImageLimit - quota.premiumImageCardsUsed;
            allowedCount = remaining > requestedCount
                ? requestedCount
                : remaining;
          } else {
            // Pro Text tier (500 per month)
            final remaining =
                QuotaEntity.premiumTextLimit - quota.premiumTextCardsUsed;
            allowedCount = remaining > requestedCount
                ? requestedCount
                : remaining;
          }
        }
        // Free
        else {
          if (withImage) {
            // Free Image tier (3 lifetime)
            final remaining = quota.remainingFreeImage;
            allowedCount = remaining > requestedCount
                ? requestedCount
                : remaining;
          } else {
            // Free Text tier (10 daily)
            final remaining = quota.remainingFreeText;
            allowedCount = remaining > requestedCount
                ? requestedCount
                : remaining;
          }
        }

        // Ensure we don't return negative
        if (allowedCount < 0) allowedCount = 0;
        return Right(allowedCount);
      });
    } catch (e) {
      return Left(ServerFailure(errorMessage: e.toString()));
    }
  }

  // this function to deduct the quota after generation
  @override
  Future<Either<Failure, void>> deductQuota({
    required String userId,
    required int generatedCount,
    required bool withImage,
  }) async {
    try {
      final docRef = _quotaRef(userId);
      final isPro = await purchaseService.isProUser();

      return await firestore.runTransaction((transaction) async {
        final docSnap = await transaction.get(docRef);
        if (!docSnap.exists) {
          throw Exception(
            "Quota document does not exist, but it should have been created by canGenerateCards",
          );
        }

        QuotaModel quota = QuotaModel.fromJson(docSnap.data()!);

        if (isPro) {
          if (withImage) {
            quota = quota.copyWith(
              premiumImageCardsUsed:
                  quota.premiumImageCardsUsed + generatedCount,
            );
          } else {
            quota = quota.copyWith(
              premiumTextCardsUsed: quota.premiumTextCardsUsed + generatedCount,
            );
          }
        } else {
          if (withImage) {
            quota = quota.copyWith(
              freeImageCardsUsed: quota.freeImageCardsUsed + generatedCount,
            );
          } else {
            quota = quota.copyWith(
              freeTextUsedToday: quota.freeTextUsedToday + generatedCount,
            );
          }
        }

        transaction.update(docRef, quota.toJson());
        return const Right(null);
      });
    } catch (e) {
      if (e is FirebaseException) {
        return Left(ServerFailure.fromFirebaseError(e));
      }
      return Left(ServerFailure(errorMessage: e.toString()));
    }
  }
}
