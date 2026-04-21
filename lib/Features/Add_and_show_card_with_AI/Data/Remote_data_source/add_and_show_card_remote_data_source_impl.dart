import 'package:smart_cards/Features/Add_and_show_card_with_AI/Data/Remote_data_source/add_and_show_card_remote_data_source.dart';
import 'package:smart_cards/Features/Add_and_show_card_with_AI/Data/models/card__with_AI_model.dart';
import 'package:smart_cards/Features/Add_and_show_card_with_AI/Domain/Entities/card_with_AI_entity.dart';
import 'package:smart_cards/core/services/app_services/card_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smart_cards/core/services/app_services/dio_service.dart';
import 'package:smart_cards/core/services/remote_config/remote_config.dart';

class ShowCardRemoteDataSourceImpl extends AddAndShowCardRemoteDataSource {
  final CardService cardService;
  final DioService dioService;
  final String BASE_URL = RemoteConfigService.getBaseUrl();

  ShowCardRemoteDataSourceImpl({
    required this.cardService,
    required this.dioService,
  });

  // show card
  @override
  Future<List<AICardEntity>> showCard({
    required String word,
    required String inputLanguage,
    required String outputLanguage,
    required String userId,
    required String cardId,
  }) async {
    // log(BASE_URL);
    var result = await dioService.getMethod(
      url:
          '$BASE_URL?words=$word&lang=$inputLanguage&output_lang=$outputLanguage&age=5&level=beginner&style=Photorealistic&userid=$userId&card_id=$cardId',
    );

    // log(result.toString());
    List<AICardEntity> cards = result
        .map((e) => AICardModel.fromJson(e))
        .toList();

    return cards;

    // https://smartcardz-ai-eq1y.onrender.com/generate/$word
    // https://smartcardz-ai-3.onrender.com/?words=play&lang=English&output_lang=العربيه&age=25&level=مبتدء&style=واقعي
  
  }

  // add ai card
  @override
  Future<void> addCard({
    required String word,
    required String definition,
    required List<String> example,
    required String type,
    String? image_url,
    String? aiImagePath,
    required String collectionId,
  }) async {
    await cardService.addCard(
      collectionId: collectionId,
      cardData: {
        //  البيانات الأساسية
        'word': word,
        'definition': definition,
        'example': example,
        'type': type,
        'image_url': image_url,
        'ai_image_path': aiImagePath,
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
