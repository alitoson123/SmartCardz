import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smart_cards/Features/Add_and_show_card_with_AI/Data/models/card__with_AI_model.dart';
import 'package:smart_cards/Features/Add_and_show_card_with_AI/Domain/Entities/card_with_AI_entity.dart';
import 'package:smart_cards/Features/Add_normal_card/Data/models/normal_card_model.dart';
import 'package:smart_cards/Features/Add_normal_card/Domain/Entities/normal_card_entity.dart';
import 'package:smart_cards/core/Domain/Entities/base_card_entity.dart';

class CardService {
  static final firestore = FirebaseFirestore.instance;

  // add card
  /// [cardId] - Optional: if provided, uses this ID; otherwise generates a new one
  Future<void> addCard({
    required Map<String, dynamic> cardData,
    required String collectionId,
    String? cardId,
  }) async {
    // Use provided cardId or generate a new one (normal card which give it id not AI card)
    final newCard = firestore.collection('cards').doc(cardId);

    await newCard.set({
      ...cardData, //(معني ... ) "هات كل الـ key/value  اللي جوه cardData وحطهم هنا جوه الـ Map"
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

  // delete card
   Future<void> deleteCard({
    required String cardId,
    required String collectionId,
  }) async {
    await firestore.collection('cards').doc(cardId).delete();

    await firestore.collection('collections').doc(collectionId).update({
      'cards_count': FieldValue.increment(-1),
    });
  }

  //   جيب الكروت المستحقة للمراجعة

  /// بيتنفذ مرة واحدة بس في بداية الجلسة
  /// بيجيب كل الكروت اللي due_date <= now
   Future<List<BaseCardEntity>> getDueCards(String collectionId) async {
    final now = Timestamp.now();

    // 1️⃣ الكروت المستحقة (Review & New) وأي كروت due حالياً
    final dueSnapshot = await firestore
        .collection('cards')
        .where('collectionId', isEqualTo: collectionId)
        .where('due_date', isLessThanOrEqualTo: now)
        .orderBy('due_date')
        .limit(70)
        .get();

    // 2️⃣ كل الكروت اللي لسه في مرحلة التعلم (learning / relearning)
    // عشان لو المستخدم عمل Again وخرج ورجع الكارت ميكونش ضاع
    final learningSnapshot = await firestore
        .collection('cards')
        .where('collectionId', isEqualTo: collectionId)
        .where(
          'state',
          whereIn: [CardState.learning.name, CardState.relearning.name],
        )
        .limit(30)
        .get();

    // بنجمع الكروت المستحقة في map واحده
    final Map<String, QueryDocumentSnapshot> uniqueDocs = {};

    for (var doc in dueSnapshot.docs) {
      uniqueDocs[doc.id] = doc;
    }
    for (var doc in learningSnapshot.docs) {
      uniqueDocs[doc.id] = doc;
    }

    return uniqueDocs.values.map((doc) {
      final data = doc.data() as Map<String, dynamic>;

      if (data['is_ai_card'] == true || data.containsKey('word')) {
        return AICardModel.fromFirestore(doc);
      } else {
        return NormalCardModel.fromFirestore(doc);
      }
    }).toList();
  }

  //   تحديث كارت واحد
  /// بيستخدم لحفظ الكروت المعدلة
   Future<void> updateCard(BaseCardEntity card) async {
    Map<String, dynamic> data;

    if (card is AICardEntity) {
      data = AICardModel.fromEntity(card).toFirestore();
    } else {
      data = NormalCardModel.fromEntity(card as NormalCardEntity).toFirestore();
    }

    await firestore.collection('cards').doc(card.id).update(data);
  }

  //   تحديث كروت متعددة (Batch) - أسرع ✅
  /// بيحفظ كذا كارت في مرة واحدة - أحسن للـ performance
   Future<void> updateMultipleCards(List<BaseCardEntity> cards) async {
    if (cards.isEmpty) return;

    // Firestore Batch - بيخلي كل الـ updates تحصل مع بعض
    final batch = firestore.batch();

    for (final card in cards) {
      Map<String, dynamic> data;

      if (card is AICardEntity) {
        data = AICardModel.fromEntity(card).toFirestore();
      } else {
        data = NormalCardModel.fromEntity(
          card as NormalCardEntity,
        ).toFirestore();
      }

      final docRef = firestore.collection('cards').doc(card.id);
      batch.update(docRef, data);
    }

    // Execute all updates at once
    await batch.commit();
  }
}
