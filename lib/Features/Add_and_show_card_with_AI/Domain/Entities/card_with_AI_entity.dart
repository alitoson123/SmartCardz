import 'package:smart_cards/core/Domain/Entities/base_card_entity.dart';

class AICardEntity extends BaseCardEntity {
  // AI card data
  final String image_url;
  final String definition;
  final String word;
  final String type;
  final List<String> example;
  final String aiImagePath;

  // Firebase data
  final bool is_valid;

  const AICardEntity({
    required super.id,
    required super.collectionId,
    required this.word,
    required this.type,
    required this.definition,
    required this.example,
    this.aiImagePath = '',
    this.image_url = '',
    this.is_valid = true,
    super.state,
    super.ease,
    super.interval,
    super.repetition,
    super.currentStep,
    super.lapses,
    required super.dueDate,
  });

  @override
  AICardEntity copyWith({
    String? image_url,
    String? aiImagePath,
    String? definition,
    String? word,
    String? type,
    List<String>? example,
    bool? is_valid,
    CardState? state,
    double? ease,
    int? interval,
    int? repetition,
    int? currentStep,
    int? lapses,
    DateTime? dueDate,
  }) {
    return AICardEntity(
      id: id,
      collectionId: collectionId,
      word: word ?? this.word,
      type: type ?? this.type,
      definition: definition ?? this.definition,
      example: example ?? this.example,
      image_url: image_url ?? this.image_url,
      aiImagePath: aiImagePath ?? this.aiImagePath,
      is_valid: is_valid ?? this.is_valid,
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
