import 'dart:developer';

import 'package:smart_cards/Features/Add_and_show_card_with_AI/Data/Remote_data_source/add_and_show_card_remote_data_source.dart';
import 'package:smart_cards/Features/Add_and_show_card_with_AI/Data/models/card__with_AI_model.dart';
import 'package:smart_cards/Features/Add_and_show_card_with_AI/Domain/Entities/card_with_AI_entity.dart';
import 'package:smart_cards/core/services/app_services/app_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smart_cards/core/services/remote_config/remote_config.dart';

class ShowCardRemoteDataSourceImpl extends AddAndShowCardRemoteDataSource {
  final AppServices appServices;
  final String BASE_URL = RemoteConfigService.getBaseUrl();

  ShowCardRemoteDataSourceImpl({required this.appServices});

  @override
  Future<List<AICardEntity>> showCard({
    required String word,
    required String inputLanguage,
    required String outputLanguage,
  }) async {
    log(BASE_URL);
    var result = await appServices.getMethod(
      URL:
          '$BASE_URL?words=$word&lang=$inputLanguage&output_lang=$outputLanguage&age=25&level=مبتدء&style=واقعي',
    );

    // https://smartcardz-ai-eq1y.onrender.com/generate/$word
    // If result is a single Map, convert it directly to CardModel
    //https://smartcardz-ai-3.onrender.com/?words=play&lang=English&output_lang=العربيه&age=25&level=مبتدء&style=واقعي    for (var item in result) {

    List<AICardEntity> cards = [];
    for (var item in result) {
      cards.add(AICardModel.fromJson(item));
    }

    return cards;
  }

  @override
  Future<void> addCard({
    required String word,
    required String definition,
    required List<String> example,
    required String type,
    String? image_url,
    required String collectionId,
  }) async {
    await appServices.addCard(
      collectionId: collectionId,
      cardData: {
        //     'card_type': 'ai',
        'word': word,
        'definition': definition,
        'example': example,
        'type': type,
        'image_url': image_url,
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
