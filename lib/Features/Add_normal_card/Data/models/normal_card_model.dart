import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smart_cards/Features/Add_normal_card/Domain/Entities/normal_card_entity.dart';
import 'package:smart_cards/core/Domain/Entities/base_card_entity.dart';

class NormalCardModel extends NormalCardEntity {

  const NormalCardModel({
    required super.id,
    required super.collectionId,
    required super.frontSide,
    required super.backSide,
    super.frontImageUrl,
    super.backImageUrl,
    super.frontImagePath,
    super.backImagePath,
    super.state,
    super.ease,
    super.interval,
    super.repetition,
    super.currentStep,
    super.lapses,
    required super.dueDate,
  });

  // From Firestore
  factory NormalCardModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return NormalCardModel(
      id: doc.id,
      frontSide: data['front_side'] ?? '',
      backSide: data['back_side'] ?? '',
      collectionId: data['collectionId'] ?? '',
      state: _stateFromString(data['state'] ?? 'newCard'),
      ease: (data['ease'] ?? 2.5).toDouble(),
      interval: data['interval'] ?? 0,
      repetition: data['repetition'] ?? 0,
      currentStep: data['current_step'] ?? 0,
      lapses: data['lapses'] ?? 0,
      dueDate: (data['due_date'] as Timestamp?)?.toDate() ?? DateTime.now(),
      frontImageUrl: data['front_image_url'] ?? '',
      backImageUrl: data['back_image_url'] ?? '',
      frontImagePath: data['front_image_path'] ?? '',
      backImagePath: data['back_image_path'] ?? '',
    );
  }

  // to firestore
  Map<String, dynamic> toFirestore() {
    return {
      'front_side': frontSide,
      'back_side': backSide,
      'front_image_url': frontImageUrl,
      'back_image_url': backImageUrl,
      'front_image_path': frontImagePath,
      'back_image_path': backImagePath,
      'collectionId': collectionId,
      'state': state.name, 
      'ease': ease,
      'interval': interval,
      'repetition': repetition,
      'current_step': currentStep,
      'lapses': lapses,
      'due_date': Timestamp.fromDate(dueDate),
      'last_reviewed': FieldValue.serverTimestamp(),
    };
  }

  // helper methods

  // from string to CardState
  static CardState _stateFromString(String s) {
    return CardState.values.firstWhere(
      (e) => e.name == s,
      orElse: () => CardState.newCard,
    );
  }

  // from Entity to Model (for update after SM-2)
  factory NormalCardModel.fromEntity(NormalCardEntity entity) {
    return NormalCardModel(
      id: entity.id,
      frontSide: entity.frontSide,
      backSide: entity.backSide,
      frontImageUrl: entity.frontImageUrl,
      backImageUrl: entity.backImageUrl,
      frontImagePath: entity.frontImagePath,
      backImagePath: entity.backImagePath,
      collectionId: entity.collectionId,
      state: entity.state,
      ease: entity.ease,
      interval: entity.interval,
      repetition: entity.repetition,
      currentStep: entity.currentStep,
      lapses: entity.lapses,
      dueDate: entity.dueDate,
    );
  }
}
