import 'package:smart_cards/Features/Add_normal_card/Data/normal_card_remote_data_source/normal_card_remote_data_source.dart';
import 'package:smart_cards/core/services/app_services/card_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NormalCardRemoteDataSourceImpl extends NormalCardRemoteDataSource {
  final CardService cardService;

  NormalCardRemoteDataSourceImpl({required this.cardService});

  // add normal card
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
    await cardService.addCard(
      collectionId: collectionId,
      cardId: cardId,
      cardData: {
        //  البيانات الأساسية
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
