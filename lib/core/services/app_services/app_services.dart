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
  final firestore = FirebaseFirestore.instance;
  final userId = FirebaseAuth.instance.currentUser!.uid;

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
      'ownerId': userId,
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
        .where('ownerId', isEqualTo: userId)
        .get();

    return snap.docs.map((e) => CollectionModel.fromDoc(e)).toList();
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
      'created_at': FieldValue.serverTimestamp(),
    });

    // زيادة عدد الكروت في الكوليكشن
    await firestore.collection('collections').doc(collectionId).update({
      'cards_count': FieldValue.increment(1),
    });
  }

  /// جلب الكروت المستحقة الآن (next_review <= today)
  Future<List<BaseCardEntity>> fetchDueCards({
    int limit = 50,
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

  /// تحديث تقييم الكارت بعد المراجعة (SM-2)
  Future<void> submitRating(BaseCardEntity card, int quality) async {
    final res = computeSm2(
      currentRepetition: card.repetition,
      currentEasiness: card.easiness,
      currentInterval: card.interval,
      quality: quality,
    );

    await firestore.collection('cards').doc(card.id).update({
      'repetition': res.repetition,
      'easiness': res.easiness,
      'interval': res.intervalDays,
      'next_review': res.nextReview,
      'last_reviewed': FieldValue.serverTimestamp(),
    });
  }
}
