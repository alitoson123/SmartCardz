// 📁 domain/entities/normal_card_entity.dart

import 'package:smart_cards/core/Domain/Entities/base_card_entity.dart';

class NormalCardEntity extends BaseCardEntity {
  final String frontSide;
  final String backSide;
  final String frontImageUrl;
  final String backImageUrl;

  const NormalCardEntity({
    required super.id,
    required super.collectionId,
    required this.frontSide,
    required this.backSide,
    this.frontImageUrl = '',
    this.backImageUrl = '',
    super.state,
    super.ease,
    super.interval,
    super.repetition,
    super.currentStep,
    super.lapses,
    required super.dueDate,
  });

  @override
  NormalCardEntity copyWith({
    CardState? state,
    double? ease,
    int? interval,
    int? repetition,
    int? currentStep,
    int? lapses,
    DateTime? dueDate,
  }) {
    return NormalCardEntity(
      id: id,
      collectionId: collectionId,
      frontSide: frontSide,
      backSide: backSide,
      frontImageUrl: frontImageUrl,
      backImageUrl: backImageUrl,
      state: state ?? this.state,
      ease: ease ?? this.ease,
      interval: interval ?? this.interval,
      repetition: repetition ?? this.repetition,
      currentStep: currentStep ?? this.currentStep,
      lapses: lapses ?? this.lapses,
      dueDate: dueDate ?? this.dueDate,
    );
  }
}
