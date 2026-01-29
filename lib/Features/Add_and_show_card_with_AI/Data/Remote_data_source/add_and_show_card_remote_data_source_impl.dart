import 'package:smart_cards/Features/Add_and_show_card_with_AI/Data/Remote_data_source/add_and_show_card_remote_data_source.dart';
import 'package:smart_cards/Features/Add_and_show_card_with_AI/Data/models/card__with_AI_model.dart';
import 'package:smart_cards/Features/Add_and_show_card_with_AI/Domain/Entities/card_with_AI_entity.dart';
import 'package:smart_cards/core/services/app_services/app_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ShowCardRemoteDataSourceImpl extends AddAndShowCardRemoteDataSource {
  final AppServices appServices;

  ShowCardRemoteDataSourceImpl({required this.appServices});
  final baseUrlHOSTINGER = 'https://n8n.srv1209874.hstgr.cloud/webhook/smartcardiz';
  final baseUrlRENDER = 'https://smartcardz-ai-3.onrender.com/';
  @override
  Future<void> requestAI({required String word}) async {
    await appServices.requestAICard(word: word);
  }

  @override
  Future<List<CardWithAIEntity>> showCard({
    required String word,
    required String language,
  }) async {
    var result = await appServices.getMethod(
      URL:
          '$baseUrlRENDER?words=$word&lang=$language&age=25&level=مبتدء&style=واقعي&country=مصر',
    );

    // https://smartcardz-ai-eq1y.onrender.com/generate/$word
    // If result is a single Map, convert it directly to CardModel
    List<CardWithAIEntity> cards = [];

    for (var item in result) {
      cards.add(CardWithAIModel.fromJson(item));
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
        'card_type': 'ai',
        'word': word,
        'definition': definition,
        'example': example,
        'type': type,
        'image_url': image_url,
        // قيم SM-2 المبدئية
        'repetition': 0,
        'easiness': 2.5,
        'interval': 0,
        'next_review': Timestamp.fromDate(DateTime.now()),
        'created_at': FieldValue.serverTimestamp(),
      },
    );
  }
}

// https://api.dictionaryapi.dev/api/v2/entries/en/apple
