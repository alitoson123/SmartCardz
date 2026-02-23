// 📁 logic/cubit/revision_state.dart

import 'package:smart_cards/core/Domain/Entities/base_card_entity.dart';

abstract class RevisionState {}

// جاري التحميل
class RevisionLoading extends RevisionState {}

// جاهز للمراجعة
class RevisionReady extends RevisionState {
  final List<BaseCardEntity> queue; // كل الكروت المطلوبة
  final int currentIndex; // أنت دلوقتي فين
  final bool showAnswer; // هل الإجابة ظاهرة؟

  RevisionReady({
    required this.queue,
    this.currentIndex = 0,
    this.showAnswer = false,
  });

  // عدد الكروت المتبقية
  int get remaining => queue.length - currentIndex;

  // الكارت الحالي
  BaseCardEntity get currentCard => queue[currentIndex];

  // نسخة معدلة
  RevisionReady copyWith({
    List<BaseCardEntity>? queue,
    int? currentIndex,
    bool? showAnswer,
  }) {
    return RevisionReady(
      queue: queue ?? this.queue,
      currentIndex: currentIndex ?? this.currentIndex,
      showAnswer: showAnswer ?? this.showAnswer,
    );
  }
}

// خلصت المراجعة
class RevisionFinished extends RevisionState {
  final int totalReviewed;
  RevisionFinished({required this.totalReviewed});
}

// حصل Error
class RevisionError extends RevisionState {
  final String message;
  RevisionError({required this.message});
}
