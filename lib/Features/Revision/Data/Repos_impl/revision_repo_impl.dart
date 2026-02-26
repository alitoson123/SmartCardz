import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smart_cards/Features/Add_and_show_card_with_AI/Data/models/card__with_AI_model.dart';
import 'package:smart_cards/Features/Add_and_show_card_with_AI/Domain/Entities/card_with_AI_entity.dart';
import 'package:smart_cards/Features/Add_normal_card/Data/models/normal_card_model.dart';
import 'package:smart_cards/Features/Add_normal_card/Domain/Entities/normal_card_entity.dart';
import 'package:smart_cards/core/Domain/Entities/base_card_entity.dart';

class RevisionRepo {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ══════════════════════════════════════════════════
  //   جيب الكروت المستحقة للمراجعة
  // ══════════════════════════════════════════════════
  /// بيتنفذ مرة واحدة بس في بداية الجلسة ✅
  /// بيجيب كل الكروت اللي due_date <= now
  Future<List<BaseCardEntity>> getDueCards(
    String collectionId, {
    int limit = 100,
  }) async {
    final now = Timestamp.now();

    final snapshot = await _firestore
        .collection('cards')
        .where('collectionId', isEqualTo: collectionId)
        .where('due_date', isLessThanOrEqualTo: now)
        .orderBy('due_date')
        .limit(limit)
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data();

      if (data['is_ai_card'] == true || data.containsKey('word')) {
        return AICardModel.fromFirestore(doc);
      } else {
        return NormalCardModel.fromFirestore(doc);
      }
    }).toList();
  }

  // ══════════════════════════════════════════════════
  //   تحديث كارت واحد
  // ══════════════════════════════════════════════════
  /// بيستخدم لحفظ الكروت المعدلة
  Future<void> updateCard(BaseCardEntity card) async {
    Map<String, dynamic> data;

    if (card is AICardEntity) {
      data = AICardModel.fromEntity(card).toFirestore();
    } else {
      data = NormalCardModel.fromEntity(card as NormalCardEntity).toFirestore();
    }

    await _firestore.collection('cards').doc(card.id).update(data);
  }

  // ══════════════════════════════════════════════════
  //   تحديث كروت متعددة (Batch) - أسرع ✅
  // ══════════════════════════════════════════════════
  /// بيحفظ كذا كارت في مرة واحدة - أحسن للـ performance
  Future<void> updateCardsBatch(List<BaseCardEntity> cards) async {
    if (cards.isEmpty) return;

    // Firestore Batch - بيخلي كل الـ updates تحصل مع بعض
    final batch = _firestore.batch();

    for (final card in cards) {
      Map<String, dynamic> data;

      if (card is AICardEntity) {
        data = AICardModel.fromEntity(card).toFirestore();
      } else {
        data = NormalCardModel.fromEntity(
          card as NormalCardEntity,
        ).toFirestore();
      }

      final docRef = _firestore.collection('cards').doc(card.id);
      batch.update(docRef, data);
    }

    // Execute all updates at once
    await batch.commit();
  }

  // ══════════════════════════════════════════════════
  //   حذف كارت
  // ══════════════════════════════════════════════════
  Future<void> deleteCard(String cardId) async {
    await _firestore.collection('cards').doc(cardId).delete();
  }
}
