// 📁 domain/entities/base_card_entity.dart

import 'package:smart_cards/Features/Add_and_show_card_with_AI/Domain/Entities/card_with_AI_entity.dart';
import 'package:smart_cards/Features/Add_normal_card/Domain/Entities/normal_card_entity.dart';

enum CardState { newCard, learning, review, relearning }

/// Base class for all card types
abstract class BaseCardEntity {
  final String id;
  final String collectionId;

  // ══════════════════════════════
  //   SM-2 Fields (مشتركة)
  // ══════════════════════════════
  final CardState state;
  final double ease;
  final int interval;
  final int repetition;
  final int currentStep;
  final int lapses;
  final DateTime dueDate;

  const BaseCardEntity({
    required this.id,
    required this.collectionId,
    this.state = CardState.newCard,
    this.ease = 2.5,
    this.interval = 0,
    this.repetition = 0,
    this.currentStep = 0,
    this.lapses = 0,
    required this.dueDate,
  });

  // ✅ كل نوع يعرّف الـ copyWith بتاعه
  BaseCardEntity copyWith({
    CardState? state,
    double? ease,
    int? interval,
    int? repetition,
    int? currentStep,
    int? lapses,
    DateTime? dueDate,
  });

  // ✅ Helper methods
  bool get isDue => dueDate.isBefore(DateTime.now());
  bool get isNew => state == CardState.newCard;
  bool get isLearning => state == CardState.learning;
  bool get isReview => state == CardState.review;

  // ✅ للتمييز بين الأنواع
  bool get isAICard => this is AICardEntity;
  bool get isNormalCard => this is NormalCardEntity;
}