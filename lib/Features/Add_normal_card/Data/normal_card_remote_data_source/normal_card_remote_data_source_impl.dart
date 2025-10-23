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
    required String collectionName
  }) async {
    await appServices.addCard(
      collectionName: collectionName,
      card: {
        'card_type': 'normal',
        'front_side ': frontSide,
        'back_side': backSide,
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
