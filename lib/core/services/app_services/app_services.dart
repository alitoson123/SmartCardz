import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smart_cards/Features/Add_and_show_card_with_AI/Data/Algorism/sm2.dart';
import 'package:smart_cards/Features/Add_and_show_card_with_AI/Data/models/card__with_AI_model.dart';
import 'package:smart_cards/Features/Add_normal_card/Data/models/normal_card_model.dart';
import 'package:smart_cards/core/Entities/base_card_entity.dart';

class AppServices {
  final Dio dio;
  //final FirebaseFirestore firebaseStoreOb = FirebaseFirestore.instance;
  // final String collectionUserName = 'users';
  final DocumentReference collectionFlashCardsPath = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('user_collections')
      .doc('user_collections_id');
  AppServices({required this.dio});

  Future<Map<String, dynamic>> getMethod({required String URL}) async {
    var result = await dio.get(URL);
    log(result.statusCode.toString());
    return result.data;
  }

  Future<void> createNewCollection({required String collectionName}) async {
    await collectionFlashCardsPath.collection(collectionName).add({
      'created_at': FieldValue.serverTimestamp(),
    });
  }

  /// 🪄 إضافة كارت جديد إلى Firestore (القيم الابتدائية)
  Future<void> addCard({
    required Map<String, dynamic> card,
    required String collectionName,
  }) async {
    await collectionFlashCardsPath.collection(collectionName).add(card);
  }

  /// 🧠 جلب الكروت المستحقة الآن (next_review <= today)
  /// بيجيب أول n كارت حسب التاريخ
  Future<List<BaseCardEntity>> fetchDueCards({
    int limit = 50,
    required String collectionName,
  }) async {
    final now = Timestamp.fromDate(DateTime.now());
    final snap = await collectionFlashCardsPath
        .collection(collectionName)
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
        // Default to AI card if no type specified or type is 'ai'
        return CardWithAIModel.fromDoc(d);
      }
    }).toList();
  }

  /// 🔁 تحديث تقييم الكارت بعد المراجعة بناءً على تقييم المستخدم
  /// quality = 5 (سهل), 3 (متوسط), 1 (صعب)

  Future<void> submitRating(
    BaseCardEntity card,
    int quality,
    String collectionName,
  ) async {
    if (card is CardWithAIModel) {
      final res = computeSm2(
        currentRepetition: card.repetition,
        currentEasiness: card.easiness,
        currentInterval: card.interval,
        quality: quality,
      );

      await collectionFlashCardsPath
          .collection(collectionName)
          .doc(card.id)
          .update({
            'repetition': res.repetition,
            'easiness': res.easiness,
            'interval': res.intervalDays,
            'next_review': res.nextReview,
            'last_reviewed': FieldValue.serverTimestamp(),
          });
    }
    // ✅ الحالة الثانية: كارت عادي Normal
    else if (card is NormalCardModel) {
      final res2 = computeSm2(
        currentRepetition: card.repetition,
        currentEasiness: card.easiness,
        currentInterval: card.interval,
        quality: quality,
      );
      await collectionFlashCardsPath
          .collection(collectionName)
          .doc(card.id)
          .update({
            'repetition': res2.repetition,
            'easiness': res2.easiness,
            'interval': res2.intervalDays,
            'next_review': res2.nextReview,
            'last_reviewed': FieldValue.serverTimestamp(),
          });
    }
  }
}
