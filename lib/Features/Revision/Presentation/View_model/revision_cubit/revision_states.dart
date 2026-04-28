import 'package:smart_cards/core/Domain/Entities/base_card_entity.dart';

abstract class RevisionState {}

class RevisionLoading extends RevisionState {}

//   2. جاهز للمراجعة
class RevisionReady extends RevisionState {
  final BaseCardEntity currentCard;
  final bool showAnswer;

  // ✅ عدد الكروت في كل queue (زي Anki بالظبط)
  final int learningCount; // 🟡 learning + relearning
  final int reviewCount; // 🔵 review
  final int newCount; // 🟢 new

  RevisionReady({
    required this.currentCard,
    this.showAnswer = false,
    this.learningCount = 0,
    this.reviewCount = 0,
    this.newCount = 0,
  });

  // إجمالي الكروت المتبقية (مش بيشمل الكارت الحالي)
  int get totalRemaining => learningCount + reviewCount + newCount;

  RevisionReady copyWith({
    BaseCardEntity? currentCard,
    bool? showAnswer,
    int? learningCount,
    int? reviewCount,
    int? newCount,
  }) {
    return RevisionReady(
      currentCard: currentCard ?? this.currentCard,
      showAnswer: showAnswer ?? this.showAnswer,
      learningCount: learningCount ?? this.learningCount,
      reviewCount: reviewCount ?? this.reviewCount,
      newCount: newCount ?? this.newCount,
    );
  }
}

//   3. في انتظار كارت due ✅ اتغيرت
// ده بيحصل لما في كروت في learningQueue بس مش due بعد
// مثلاً: ضغطت Again والكارت due بعد 45 ثانية
class RevisionWaiting extends RevisionState {
  final DateTime nextDueDate; // موعد أقرب كارت
  final int totalReviewed; // كم كارت راجعت
  final int remainingLearning; // كروت لسه في learningQueue

  RevisionWaiting({
    required this.nextDueDate,
    required this.totalReviewed,
    this.remainingLearning = 0,
  });

  /// كم ثانية متبقية؟
  Duration get timeUntilNext {
    final now = DateTime.now();
    if (nextDueDate.isBefore(now)) return Duration.zero;
    return nextDueDate.difference(now);
  }
}

//   4. خلصت المراجعة
class RevisionFinished extends RevisionState {
  final int totalReviewed;
  RevisionFinished({required this.totalReviewed});
}

class RevisionEditCard extends RevisionState {
  final BaseCardEntity card;
  RevisionEditCard({required this.card});
}

//   5. حصل خطأ
class RevisionError extends RevisionState {
  final String message;
  RevisionError({required this.message});
}
