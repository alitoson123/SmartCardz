import 'package:smart_cards/Features/Add_and_show_card_with_AI/Data/Remote_data_source/add_and_show_card_remote_data_source.dart';
import 'package:smart_cards/Features/Add_and_show_card_with_AI/Data/models/card__with_AI_model.dart';
import 'package:smart_cards/Features/Add_and_show_card_with_AI/Domain/Entities/card_with_AI_entity.dart';
import 'package:smart_cards/core/services/app_services/app_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ShowCardRemoteDataSourceImpl extends AddAndShowCardRemoteDataSource {
  final AppServices appServices;

  ShowCardRemoteDataSourceImpl({required this.appServices});
  @override
  Future<CardWithAIEntity> showCard({required String word}) async {
    var result = await appServices.getMethod(
      URL:
          'https://n8n.srv1209874.hstgr.cloud/webhook/smartcardiz?words=$word&lang=%D8%A7%D9%84%D8%B9%D8%B1%D8%A8%D9%8A&age=56&level=%D9%85%D8%A8%D8%AA%D8%AF%D8%A1&style=%D8%B1%D8%B3%D9%85&country=%D9%85%D8%B5%D8%B1',
    );



    // https://smartcardz-ai-eq1y.onrender.com/generate/$word
    // If result is a single Map, convert it directly to CardModel


    final card = CardWithAIModel.fromJson(result);

    return card;
  }

  @override
  Future<void> addCard({
    required String word,
    required String definition,
    required List<dynamic> example,
    required List<dynamic> type,
    String? image_url,
    required String collectionId,
  }) async {
    await appServices.addCard(
      collectionId: collectionId,
      cardId: FirebaseFirestore.instance.collection('cards').doc().id,
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
