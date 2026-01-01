import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smart_cards/Features/Add_and_show_card_with_AI/Data/Algorism/sm2.dart';
import 'package:smart_cards/Features/Add_and_show_card_with_AI/Data/models/card__with_AI_model.dart';
import 'package:smart_cards/Features/Add_normal_card/Data/models/normal_card_model.dart';
import 'package:smart_cards/Features/Home/Data/Models/collection_model.dart';
import 'package:smart_cards/Features/Home/Domain/Entities/collection_entity.dart';
import 'package:smart_cards/core/Domain/Entities/base_card_entity.dart';

class AppServices {
  final Dio dio;
  static final firestore = FirebaseFirestore.instance;

  AppServices({required this.dio});

  /// 🌐 HTTP GET
  Future<Map<String, dynamic>> getMethod({required String URL}) async {
    var result = await dio.get(URL);
    log(result.statusCode.toString());
    return result.data;
  }

  // ======================================================================
  // 📚 COLLECTIONS
  // ======================================================================

  /// إنشاء Collection جديدة
  Future<CollectionEntity> createNewCollection({
    required String collectionName,
  }) async {
    final ref = firestore.collection('collections').doc();
    await ref.set({
      'id': ref.id,
      'ownerId': FirebaseAuth.instance.currentUser!.uid,
      'collection_name': collectionName,
      'cards_count': 0,
      'created_at': FieldValue.serverTimestamp(),
    });

    final snapshot = await ref.get();
    final model = CollectionModel.fromDoc(snapshot);

    return model; // 👈 نرجع الموديل كامل
  }

  /// جلب كل الكوليكشنز بتاعت المستخدم
  Future<List<CollectionEntity>> fetchUserCollections() async {
    final snap = await firestore
        .collection('collections')
        .where('ownerId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get();

    return snap.docs.map((e) => CollectionModel.fromDoc(e)).toList();
  }

  static Future<void> deleteCollection({required String collectionId}) async {
    final cardsSnap = await firestore
        .collection('cards')
        .where('collectionId', isEqualTo: collectionId)
        .get();

    for (final doc in cardsSnap.docs) {
      await doc.reference.delete();
    }

    await firestore.collection('collections').doc(collectionId).delete();
  }

  static Future<void> renameCollection({
    required String collectionId,
    required String newCollectionName,
  }) async {
    await firestore.collection('collections').doc(collectionId).update({
      'collection_name': newCollectionName,
    });
  }

  // ======================================================================
  // 🃏 CARDS
  // ======================================================================

  /// إضافة كارت جديد إلى كوليكشن معينة
  Future<void> addCard({
    required Map<String, dynamic> cardData,
    required String collectionId,
  }) async {
    final newCard = firestore.collection('cards').doc();

    await newCard.set({
      ...cardData,
      'id': newCard.id,
      'collectionId': collectionId,
      'ownerId': FirebaseAuth.instance.currentUser!.uid,
      'created_at': FieldValue.serverTimestamp(),
    });

    // زيادة عدد الكروت في الكوليكشن
    await firestore.collection('collections').doc(collectionId).update({
      'cards_count': FieldValue.increment(1),
    });
  }

  static Future<void> deleteCard({
    required String cardId,
    required String collectionId,
  }) async {
    await firestore.collection('cards').doc(cardId).delete();

    await firestore.collection('collections').doc(collectionId).update({
      'cards_count': FieldValue.increment(-1),
    });
  }

  static Future<int> countOfDueCards({required String collectionId}) async {
    int count = 0;
    int limit = 100;

    final now = Timestamp.fromDate(DateTime.now());

    final snap = await firestore
        .collection('cards')
        .where('collectionId', isEqualTo: collectionId)
        .where('next_review', isLessThanOrEqualTo: now)
        .limit(limit)
        .count()
        .get();

    count = snap.count ?? 0;
    return count;
  }

  /// جلب الكروت المستحقة الآن (next_review <= today)
  Future<List<BaseCardEntity>> fetchDueCards({
    required int limit,
    required String collectionId,
  }) async {
    final now = Timestamp.fromDate(DateTime.now());
    final snap = await firestore
        .collection('cards')
        .where('collectionId', isEqualTo: collectionId)
        .where('next_review', isLessThanOrEqualTo: now)
        .orderBy('next_review')
        .limit(limit)
        .get();

    return snap.docs.map<BaseCardEntity>((d) {
      final data = d.data();
      final cardType = data['card_type'] as String?;
      if (cardType == 'normal') {
        return NormalCardModel.fromDoc(d);
      } else {
        return CardWithAIModel.fromDoc(d);
      }
    }).toList();
  }

  /// تحديث تقييم الكارت بعد المراجعة (Firestore Only)
  Future<void> submitRating(BaseCardEntity card, Sm2Result res) async {
    await firestore.collection('cards').doc(card.id).update({
      'repetition': res.repetition,
      'easiness': res.easiness,
      'interval': res.intervalDays,
      'next_review': res.nextReview,
      'last_reviewed': FieldValue.serverTimestamp(),
    });
  }

  Future<void> migrateOldCardsAddOwnerId() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final uid = user.uid;
    final firestore = FirebaseFirestore.instance;

    print('Migration started for user: $uid');

    // هات كل collections بتاعة المستخدم
    final collectionsSnap = await firestore
        .collection('collections')
        .where('ownerId', isEqualTo: uid)
        .get();

    if (collectionsSnap.docs.isEmpty) {
      print('No collections found');
      return;
    }

    final collectionIds = collectionsSnap.docs.map((e) => e.id).toList();

    // هات كل cards اللي معندهاش ownerId
    final cardsSnap = await firestore
        .collection('cards')
        .where('collectionId', whereIn: collectionIds)
        .get();

    final batch = firestore.batch();
    int updatedCount = 0;

    for (final doc in cardsSnap.docs) {
      final data = doc.data();

      if (!data.containsKey('ownerId')) {
        batch.update(doc.reference, {'ownerId': uid});
        updatedCount++;
      }
    }

    if (updatedCount > 0) {
      await batch.commit();
    }

    print('Migration finished. Updated cards: $updatedCount');
  }
}
