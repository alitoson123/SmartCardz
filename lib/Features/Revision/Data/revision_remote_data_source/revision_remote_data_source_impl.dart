/*

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:smart_cards/Features/Add_and_show_card_with_AI/Data/Algorism/sm2.dart';
import 'package:smart_cards/Features/Add_and_show_card_with_AI/Data/models/card__with_AI_model.dart';
import 'package:smart_cards/Features/Add_normal_card/Data/models/normal_card_model.dart';
import 'package:smart_cards/Features/Revision/Data/revision_remote_data_source/revision_remote_data_saource.dart';
import 'package:smart_cards/constant.dart';
import 'package:smart_cards/core/Domain/Entities/base_card_entity.dart';
import 'package:smart_cards/core/services/Local_service/general_local_service.dart';
import 'package:smart_cards/core/services/app_services/app_services.dart';

class RevisionRemoteDataSourceImpl extends RevisionRemoteDataSaource {
  final AppServices appServices;
  final GeneralLocalService _localService = GeneralLocalService();

  @override
  RevisionRemoteDataSourceImpl({required this.appServices});

  /// Fetches due cards with offline-first capability
  /// When online: syncs pending changes first, then fetches from server (source of truth)
  /// When offline: uses local cache
  @override
  @override
  Future<List<BaseCardEntity>> fetchDueCards({
    required int limit,
    required String collectionId,
  }) async {
    final isOnline = await _isOnline();

    if (isOnline) {
      // Step 1: Sync pending ratings first
      await _syncPendingRatings();

      // Step 2: Fetch from server (already filtered as due cards)
      final serverCards = await appServices.fetchDueCards(
        limit: limit,
        collectionId: collectionId,
      );

      // Step 3: Update local cache
      await _replaceLocalCache(collectionId, serverCards);

      // Step 4: Return directly - no need to filter again!
      return serverCards;
    } else {
      // Offline: get from local and filter
      return await _getLocalDueCards(collectionId);
    }
  }

  /// Submits a rating for a card
  /// Always updates local immediately, then syncs to server (or queues if offline)
  @override
  Future<void> submitRating(BaseCardEntity card, int quality) async {
    // Step 1: Calculate new SM-2 values
    final sm2Result = computeSm2(
      currentRepetition: card.repetition,
      currentEasiness: card.easiness,
      currentInterval: card.interval,
      quality: quality,
    );

    // Step 2: Create updated card with new values
    final updatedCard = _createUpdatedCard(card, sm2Result);
    if (updatedCard == null) return;

    // Step 3: ALWAYS update local storage immediately (instant feedback)
    await _updateLocalCard(updatedCard);

    // Step 4: Try to sync to server or queue for later
    final isOnline = await _isOnline();
    if (isOnline) {
      try {
        await appServices.submitRating(card, sm2Result);
      } catch (e) {
        // Network error - queue for later sync
        await _addToPendingQueue(card.id, sm2Result);
      }
    } else {
      // Offline - queue for sync when online
      await _addToPendingQueue(card.id, sm2Result);
    }
  }

  // ============================================
  // HELPER METHODS
  // ============================================

  /// Checks if device is online
  Future<bool> _isOnline() async {
    final dynamic connectivity = await Connectivity().checkConnectivity();
    if (connectivity is List) {
      return !connectivity.contains(ConnectivityResult.none);
    } else {
      return connectivity != ConnectivityResult.none;
    }
  }

  /// Gets due cards from local cache (offline mode)
  Future<List<BaseCardEntity>> _getLocalDueCards(String collectionId) async {
    final allLocalCards = await _localService.getAll<BaseCardEntity>(
      K_DUE_CARDS_BOX,
    );

    final now = DateTime.now();
    return allLocalCards.where((card) {
      // Must be in correct collection
      final isCorrectCollection = card.collectionId == collectionId;
      if (!isCorrectCollection) return false;

      // Must be due
      final nextReviewDate = card.nextReview?.toDate();
      final isDue =
          nextReviewDate == null ||
          nextReviewDate.isBefore(now) ||
          nextReviewDate.isAtSameMomentAs(now);

      return isDue;
    }).toList();
  }

  /// Replaces local cache for a collection with fresh server data
  Future<void> _replaceLocalCache(
    String collectionId,
    List<BaseCardEntity> serverCards,
  ) async {
    // Delete old cards for this collection
    await _localService.deleteItems<BaseCardEntity>(
      K_DUE_CARDS_BOX,
      (card) => card.collectionId == collectionId,
    );

    // Add fresh cards from server
    for (var card in serverCards) {
      await _localService.add<BaseCardEntity>(K_DUE_CARDS_BOX, card);
    }
  }

  /// Updates a single card in local storage
  Future<void> _updateLocalCard(BaseCardEntity card) async {
    await _localService.updateItem<BaseCardEntity>(
      K_DUE_CARDS_BOX,
      card,
      (c) => c.id == card.id,
    );
  }

  /// Creates an updated card with new SM-2 values
  BaseCardEntity? _createUpdatedCard(BaseCardEntity card, Sm2Result sm2Result) {
    if (card is NormalCardModel) {
      return card.copyWith(
        repetition: sm2Result.repetition,
        easiness: sm2Result.easiness,
        interval: sm2Result.intervalDays,
        nextReview: sm2Result.nextReview,
      );
    } else if (card is CardWithAIModel) {
      return card.copyWith(
        repetition: sm2Result.repetition,
        easiness: sm2Result.easiness,
        interval: sm2Result.intervalDays,
        nextReview: sm2Result.nextReview,
      );
    }
    return null;
  }

  // ============================================
  // PENDING SYNC QUEUE METHODS
  // ============================================

  /// Adds a rating to the pending sync queue
  Future<void> _addToPendingQueue(String cardId, Sm2Result sm2Result) async {
    final pendingRating = {
      'id': cardId,
      'repetition': sm2Result.repetition,
      'easiness': sm2Result.easiness,
      'interval': sm2Result.intervalDays,
      'next_review': sm2Result.nextReview,
      'timestamp': Timestamp.now(),
    };

    await _localService.add<Map>(K_PENDING_RATINGS_BOX, pendingRating);
  }

  /// Syncs all pending ratings to the server
  Future<void> _syncPendingRatings() async {
    try {
      // Get all pending ratings
      final pendingRatings = await _localService.getAll<Map>(
        K_PENDING_RATINGS_BOX,
      );

      if (pendingRatings.isEmpty) return;

      // Get all local cards to find the ones we need to sync
      final allLocalCards = await _localService.getAll<BaseCardEntity>(
        K_DUE_CARDS_BOX,
      );

      // Process each pending rating
      for (var pendingRating in pendingRatings) {
        final cardId = pendingRating['id'];

        // Find the card
        final card = allLocalCards.firstWhere(
          (c) => c.id == cardId,
          orElse: () =>
              throw StateError('Card $cardId not found in local cache'),
        );

        // Recreate SM-2 result
        final sm2Result = Sm2Result(
          repetition: pendingRating['repetition'],
          easiness: pendingRating['easiness'],
          intervalDays: pendingRating['interval'],
          nextReview: pendingRating['next_review'],
        );

        // Sync to server
        await appServices.submitRating(card, sm2Result);
      }

      // Clear all pending ratings after successful sync
      await _localService.deleteItems<Map>(
        K_PENDING_RATINGS_BOX,
        (_) => true, // Delete all
      );
    } catch (e) {
      // If sync fails, ratings stay in queue for next attempt
      print('Failed to sync pending ratings: $e');
      rethrow; // Let caller know sync failed
    }
  }
}
*/

// 📁 data/repositories/revision_repo.dart
// ════════════════════════════════════════════════════════════════
// الساعي - بيجيب الكروت من Firestore ويحفظها
// بيتعامل مع النوعين: AI Cards و Normal Cards
// ════════════════════════════════════════════════════════════════

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smart_cards/Features/Add_and_show_card_with_AI/Data/models/card__with_AI_model.dart';
import 'package:smart_cards/Features/Add_and_show_card_with_AI/Domain/Entities/card_with_AI_entity.dart';
import 'package:smart_cards/Features/Add_normal_card/Data/models/normal_card_model.dart';
import 'package:smart_cards/Features/Add_normal_card/Domain/Entities/normal_card_entity.dart';
import 'package:smart_cards/Features/Revision/Presentation/View_model/logic/SM2_algorithm.dart';
import 'package:smart_cards/core/Domain/Entities/base_card_entity.dart';

class RevisionRepo {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ══════════════════════════════════════════════════
  //   جيب الكروت المستحقة للمراجعة النهارده
  // ══════════════════════════════════════════════════
  /// بنجيب كل الكروت اللي due_date <= now
  /// مرتبين من الأقدم للأحدث
  Future<List<BaseCardEntity>> getDueCards(
    String collectionId, {
    int limit = 100,  // أقصى عدد كروت (علشان مش نحمل آلاف)
  }) async {
    // الوقت الحالي
    final now = Timestamp.now();

    // ══════════════════════════════════════════════════
    // Query: جيب الكروت المستحقة
    // ══════════════════════════════════════════════════
    final snapshot = await _firestore
        .collection('cards')                          // من collection cards
        .where('collectionId', isEqualTo: collectionId) // للـ collection ده بس
        .where('due_date', isLessThanOrEqualTo: now)  // اللي موعدها النهارده
        .orderBy('due_date')                          // من الأقدم للأحدث
        .limit(limit)                                 // حد أقصى 100 كارت
        .get();

    // ══════════════════════════════════════════════════
    // تحويل Documents لـ Entities
    // ══════════════════════════════════════════════════
    return snapshot.docs.map((doc) {
      final data = doc.data();
      
      // تحقق: النوع AI ولا Normal؟
      // طريقة 1: تحقق من field is_ai_card
      // طريقة 2: تحقق لو فيه field 'word' (خاص بـ AI)
      if (data['is_ai_card'] == true || data.containsKey('word')) {
        // ✅ AI Card
        return AICardModel.fromFirestore(doc);
      } else {
        // ✅ Normal Card
        return NormalCardModel.fromFirestore(doc);
      }
    }).toList();
  }

  // ══════════════════════════════════════════════════
  //   حفظ تقييم الكارت في Firestore
  // ══════════════════════════════════════════════════
  /// المستخدم قيّم الكارت - نحفظ البيانات الجديدة
  Future<void> submitRating({
    required BaseCardEntity card,
    required int quality,
  }) async {
    // ══════════════════════════════════════════════════
    // خطوة 1: احسب SM-2 (الكارت المحدث)
    // ══════════════════════════════════════════════════
    final updatedCard = Sm2Scheduler.schedule(
      card: card, 
      quality: quality,
    );
    
    // ══════════════════════════════════════════════════
    // خطوة 2: حول الـ Entity لـ Map (Firestore format)
    // ══════════════════════════════════════════════════
    Map<String, dynamic> data;
    
    // تحقق من النوع
    if (updatedCard is AICardEntity) {
      // AI Card ──► استخدم AICardModel
      data = AICardModel.fromEntity(updatedCard).toFirestore();
    } else {
      // Normal Card ──► استخدم NormalCardModel
      data = NormalCardModel.fromEntity(updatedCard as NormalCardEntity).toFirestore();
    }
    
    // ══════════════════════════════════════════════════
    // خطوة 3: احفظ في Firestore
    // ══════════════════════════════════════════════════
    await _firestore
        .collection('cards')
        .doc(card.id)
        .update(data);  // Update البيانات الموجودة
  }
}