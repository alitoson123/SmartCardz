import 'package:smart_cards/Features/Add_normal_card/Data/normal_card_remote_data_source/normal_card_remote_data_source.dart';
import 'package:smart_cards/core/services/app_services/app_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NormalCardRemoteDataSourceImpl extends NormalCardRemoteDataSource {
  final AppServices appServices;

  NormalCardRemoteDataSourceImpl({required this.appServices});

  @override
  Future<void> addNormalCard({
    required String frontSide,
    required String backSide,
    required String frontImageUrl,
    required String backImageUrl,
    required String frontImagePath,
    required String backImagePath,
    required String collectionId,
    String? cardId,
  }) async {
    await appServices.addCard(
      collectionId: collectionId,
      cardId: cardId,
      cardData: {
        // 1. البيانات الأساسية
        //   'card_type': 'normal',
        'front_side': frontSide,
        'back_side': backSide,
        'front_image_url': frontImageUrl,
        'back_image_url': backImageUrl,
        'front_image_path': frontImagePath,
        'back_image_path': backImagePath,

        // ── SM-2 Default Values ──
        'state': 'newCard',
        'ease': 2.5,
        'interval': 0,
        'repetition': 0,
        'current_step': 0,
        'lapses': 0,
        'due_date': Timestamp.now(), // متاح فوراً للمراجعة
      },
    );
  }
}

/*Future<String> addCard({
  required String deckId,
  required String question,
  required String answer,
  String? questionImageUrl,
  String? answerImageUrl,
  String? questionImagePath,
  String? answerImagePath,
}) async {
  try {
    // 1. إنشاء Document جديد
    final docRef = _firestore.collection('cards').doc();

    // 2. البيانات الأساسية
    final cardData = {
      'collectionId': deckId,
      'question': question,
      'answer': answer,

      // Images (اختياري)
      'question_image_url': questionImageUrl ?? '',
      'answer_image_url': answerImageUrl ?? '',
      'question_image_path': questionImagePath ?? '',
      'answer_image_path': answerImagePath ?? '',

      // ── SM-2 Default Values ──
      'state': 'newCard',
      'ease': 2.5,
      'interval': 0,
      'repetition': 0,
      'current_step': 0,
      'lapses': 0,
      'due_date': Timestamp.now(), // متاح فوراً للمراجعة
      // Metadata
      'created_at': FieldValue.serverTimestamp(),
      'user_id': FirebaseAuth.instance.currentUser?.uid ?? '',
    };

    // 3. حفظ
    await docRef.set(cardData);

    return docRef.id; // ✅ ارجع الـ ID
  } catch (e) {
    throw Exception('فشل إضافة الكارت: $e');
  }
}*/
