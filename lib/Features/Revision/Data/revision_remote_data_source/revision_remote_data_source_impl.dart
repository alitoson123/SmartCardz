

/*
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:smart_cards/Features/Add_and_show_card_with_AI/Data/Algorism/sm2.dart';
import 'package:smart_cards/Features/Add_and_show_card_with_AI/Data/models/card__with_AI_model.dart';
import 'package:smart_cards/Features/Add_normal_card/Data/models/normal_card_model.dart';
import 'package:smart_cards/Features/Revision/Data/revision_remote_data_source/revision_remote_data_saource.dart';
import 'package:smart_cards/constant.dart';
import 'package:smart_cards/core/Domain/Entities/base_card_entity.dart';
import 'package:smart_cards/core/services/Local_service/general_local_service.dart';
import 'package:smart_cards/core/services/app_services/app_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RevisionRemoteDataSourceImpl extends RevisionRemoteDataSaource {
  final AppServices appServices;
  @override
  RevisionRemoteDataSourceImpl({required this.appServices});
  @override
  Future<List<BaseCardEntity>> fetchDueCards({
    required int limit,
    required String collectionId,
  }) async {
    final dynamic connectivity = await Connectivity().checkConnectivity();
    bool isOnline = false;
    if (connectivity is List) {
      isOnline = !connectivity.contains(ConnectivityResult.none);
    } else {
      isOnline = connectivity != ConnectivityResult.none;
    }

    if (isOnline) {
      // 1. Fetch from Server
      final remoteCards = await appServices.fetchDueCards(
        limit: limit,
        collectionId: collectionId,
      );

      // 2. Fetch all local cards for this collection to compare
      final localService = GeneralLocalService();
      final localCards = await localService.getAll<BaseCardEntity>(
        K_DUE_CARDS_BOX,
      );
      final collectionLocalCards = localCards
          .where((c) => c.collectionId == collectionId)
          .toList();

      final List<BaseCardEntity> finalResults = [];

      for (var remoteCard in remoteCards) {
        // Find local version
        final localCard = collectionLocalCards.firstWhere(
          (c) => c.id == remoteCard.id,
          orElse: () => remoteCard,
        );

        final remoteNext = remoteCard.nextReview?.toDate();
        final localNext = localCard.nextReview?.toDate();

        // 3. Check for unsynced offline ratings
        // If local has a review date and it's AFTER the remote one, local is more recent
        if (localNext != null &&
            (remoteNext == null || localNext.isAfter(remoteNext))) {
          // Sync THIS card back to server
          await appServices.submitRating(
            remoteCard,
            Sm2Result(
              repetition: localCard.repetition,
              easiness: localCard.easiness,
              intervalDays: localCard.interval,
              nextReview: localCard.nextReview!,
            ),
          );
          // Keep local version in our results
          finalResults.add(localCard);
        } else {
          // Server is up to date or has newer data
          finalResults.add(remoteCard);
        }
      }

      // 4. Update local cache for THIS collection
      await localService.deleteItems<BaseCardEntity>(
        K_DUE_CARDS_BOX,
        (card) => card.collectionId == collectionId,
      );
      for (var card in finalResults) {
        await localService.add<BaseCardEntity>(K_DUE_CARDS_BOX, card);
      }

      // 5. Only return cards that are STILL due
      final now = DateTime.now();
      return finalResults.where((card) {
        final nextReviewDate = card.nextReview?.toDate();
        return nextReviewDate == null ||
            nextReviewDate.isBefore(now) ||
            nextReviewDate.isAtSameMomentAs(now);
      }).toList();
    } else {
      // Offline
      final allCards = await GeneralLocalService().getAll<BaseCardEntity>(
        K_DUE_CARDS_BOX,
      );
      final now = DateTime.now();
      return allCards.where((card) {
        final isCorrectCollection = card.collectionId == collectionId;
        final nextReviewDate = card.nextReview?.toDate();
        // Return true if it's the right collection AND it's due (nextReview <= now)
        final isDue =
            nextReviewDate == null ||
            nextReviewDate.isBefore(now) ||
            nextReviewDate.isAtSameMomentAs(now);
        return isCorrectCollection && isDue;
      }).toList();
    }
  }

  @override
  Future<void> submitRating(BaseCardEntity card, int quality) async {
    final bool isOnline = await _isOnline();

    // 1. Compute new SM-2 values
    final res = computeSm2(
      currentRepetition: card.repetition,
      currentEasiness: card.easiness,
      currentInterval: card.interval,
      quality: quality,
    );

    // 2. Create updated card instance
    final updatedCard = _getUpdatedCard(card, res);
    if (updatedCard == null) return;

    // 3. Sync to Remote (if online)
    if (isOnline) {
      await appServices.submitRating(card, res);
    }

    // 4. Sync to Local Cache (ALWAYS)
    await GeneralLocalService().updateItem<BaseCardEntity>(
      K_DUE_CARDS_BOX,
      updatedCard,
      (c) => c.id == card.id,
    );
  }

  // --- Helpers ---

  Future<bool> _isOnline() async {
    final dynamic connectivity = await Connectivity().checkConnectivity();
    if (connectivity is List) {
      return !connectivity.contains(ConnectivityResult.none);
    } else {
      return connectivity != ConnectivityResult.none;
    }
  }

  BaseCardEntity? _getUpdatedCard(BaseCardEntity card, Sm2Result res) {
    if (card is NormalCardModel) {
      return card.copyWith(
        repetition: res.repetition,
        easiness: res.easiness,
        interval: res.intervalDays,
        nextReview: res.nextReview,
      );
    } else if (card is CardWithAIModel) {
      return card.copyWith(
        repetition: res.repetition,
        easiness: res.easiness,
        interval: res.intervalDays,
        nextReview: res.nextReview,
      );
    }
    return null;
  }
}

*/

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
      final isDue = nextReviewDate == null ||
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
      'timestamp':Timestamp.now()
    };

    await _localService.add<Map<String, dynamic>>(
      K_PENDING_RATINGS_BOX,
      pendingRating,
    );
  }

  /// Syncs all pending ratings to the server
  Future<void> _syncPendingRatings() async {
    try {
      // Get all pending ratings
      final pendingRatings = await _localService.getAll<Map<String, dynamic>>(
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
          orElse: () => throw StateError('Card $cardId not found in local cache'),
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
      await _localService.deleteItems<Map<String, dynamic>>(
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