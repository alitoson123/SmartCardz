import 'package:smart_cards/core/Domain/Entities/base_card_entity.dart';

class NormalCardEntity extends BaseCardEntity {
  final String frontSide;
  final String backSide;
  final String frontImageUrl;
  final String backImageUrl;
  final String frontImagePath;
  final String backImagePath;
  

  const NormalCardEntity({
    required super.id,
    required super.collectionId,
    required this.frontSide,
    required this.backSide,
    this.frontImageUrl = '',
    this.backImageUrl = '',
    this.frontImagePath = '',
    this.backImagePath = '',
    super.state,
    super.ease,
    super.interval,
    super.repetition,
    super.currentStep,
    super.lapses,
    required super.dueDate,
  });

  // copy with method
  @override
  NormalCardEntity copyWith({
    String? frontSide,
    String? backSide,
    String? frontImageUrl,
    String? backImageUrl,
    String? frontImagePath,
    String? backImagePath,
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
      frontSide: frontSide ?? this.frontSide,
      backSide: backSide ?? this.backSide,
      frontImageUrl: frontImageUrl ?? this.frontImageUrl,
      backImageUrl: backImageUrl ?? this.backImageUrl,
      frontImagePath: frontImagePath ?? this.frontImagePath,
      backImagePath: backImagePath ?? this.backImagePath,
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
