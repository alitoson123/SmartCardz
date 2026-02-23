import 'package:smart_cards/core/Domain/Entities/base_card_entity.dart';

class AICardEntity extends BaseCardEntity {
  // AI card data
  final String image_url;
  final String definition;
  final String word;
  final String type;
  final List<String> example;

  // Firebase data
  final bool is_valid;

  // ══════════════════════════════
  //   SM-2 Fields
  // ══════════════════════════════
  /*final CardState state; // حالة الكارت
  final double ease; // معامل السهولة (يبدأ 2.5)
  final int interval; // الفترة بالأيام (يبدأ 0)
  final int repetition; // عدد المراجعات الناجحة (يبدأ 0)
  final int currentStep; // رقم الـ Step في الـ Learning (يبدأ 0)
  final int lapses; // عدد مرات النسيان (يبدأ 0)
  final DateTime dueDate; // موعد المراجعة الجاية
*/
  const AICardEntity({
    required super.id,
    required super.collectionId,
    required this.word,
    required this.type,
    required this.definition,
    required this.example,
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
      word: word,
      type: type,
      definition: definition,
      example: example,
      image_url: image_url,
      is_valid: is_valid,
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
