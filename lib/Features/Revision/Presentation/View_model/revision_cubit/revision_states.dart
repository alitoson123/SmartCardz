// 📁 logic/cubit/revision_state.dart
// ════════════════════════════════════════════════════════════════
// تعريف كل الحالات الممكنة في جلسة المراجعة
// ════════════════════════════════════════════════════════════════

import 'package:smart_cards/core/Domain/Entities/base_card_entity.dart';

// الـ Base Class - كل الحالات بترث منها
abstract class RevisionState {}

// ══════════════════════════════════════════════════
//   حالة 1: جاري التحميل
// ══════════════════════════════════════════════════
/// أول ما نفتح الشاشة - بنجيب الكروت من Firestore
class RevisionLoading extends RevisionState {}

// ══════════════════════════════════════════════════
//   حالة 2: جاهز للمراجعة
// ══════════════════════════════════════════════════
/// الكروت جاهزة - المستخدم بيراجع دلوقتي
class RevisionReady extends RevisionState {
  final List<BaseCardEntity> queue;   // كل الكروت المطلوب مراجعتها
  final int currentIndex;             // أنت واقف على أنهي كارت (0-based)
  final bool showAnswer;              // هل الإجابة ظاهرة؟

  RevisionReady({
    required this.queue,
    this.currentIndex = 0,            // default: أول كارت
    this.showAnswer = false,          // default: الإجابة مخفية
  });

  // ══════════════════════════════════════════════════
  //   Getters مفيدة
  // ══════════════════════════════════════════════════
  
  /// كم كارت متبقي؟
  /// مثال: لو عندك 10 كروت وأنت في index 3 ──► remaining = 7
  int get remaining => queue.length - currentIndex;

  /// الكارت الحالي اللي بتشوفه دلوقتي
  BaseCardEntity get currentCard => queue[currentIndex];

  // ══════════════════════════════════════════════════
  //   copyWith - علشان نعمل نسخة معدلة
  // ══════════════════════════════════════════════════
  /// بدل ما نعمل state جديد من الصفر، نعدل حاجات معينة بس
  RevisionReady copyWith({
    List<BaseCardEntity>? queue,
    int? currentIndex,
    bool? showAnswer,
  }) {
    return RevisionReady(
      queue: queue ?? this.queue,                  // لو مفيش جديد ──► استخدم القديم
      currentIndex: currentIndex ?? this.currentIndex,
      showAnswer: showAnswer ?? this.showAnswer,
    );
  }
}

// ══════════════════════════════════════════════════
//   حالة 3: خلصت المراجعة
// ══════════════════════════════════════════════════
/// الـ queue خلص - مفيش كروت تانية
class RevisionFinished extends RevisionState {
  final int totalReviewed;  // كم كارت راجعت النهارده

  RevisionFinished({required this.totalReviewed});
}

// ══════════════════════════════════════════════════
//   حالة 4: حصل خطأ
// ══════════════════════════════════════════════════
/// مثلاً: مفيش إنترنت، أو Firestore error
class RevisionError extends RevisionState {
  final String message;  // رسالة الخطأ

  RevisionError({required this.message});
}