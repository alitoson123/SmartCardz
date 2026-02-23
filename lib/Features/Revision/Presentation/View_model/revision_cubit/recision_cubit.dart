// 📁 logic/cubit/revision_cubit.dart
// ════════════════════════════════════════════════════════════════
// المايسترو - بينظم عرض الكروت والتنقل بينهم
// بيستخدم SM-2 لحساب المواعيد ويدير الـ queue بذكاء
// ════════════════════════════════════════════════════════════════

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_cards/Features/Revision/Presentation/View_model/logic/SM2_algorithm.dart';
import 'package:smart_cards/core/Domain/Entities/base_card_entity.dart';
import 'package:smart_cards/Features/Revision/Data/revision_remote_data_source/revision_remote_data_source_impl.dart';
import 'package:smart_cards/Features/Revision/Presentation/View_model/revision_cubit/revision_states.dart';

class RevisionCubit extends Cubit<RevisionState> {
  final RevisionRepo _repo;           // المسؤول عن الكلام مع Firestore
  int _totalReviewed = 0;             // عداد الكروت اللي اتراجعت

  RevisionCubit(this._repo) : super(RevisionLoading());

  // ══════════════════════════════════════════════════
  //   1. تحميل الكروت المستحقة للمراجعة
  // ══════════════════════════════════════════════════
  /// بنجيب كل الكروت اللي موعدها النهارده (due_date <= now)
  Future<void> loadCards(String collectionId, {int limit = 100}) async {
    // أول حاجة: نعرض Loading
    emit(RevisionLoading());
    
    try {
      // جيب الكروت من Firestore
      final cards = await _repo.getDueCards(collectionId, limit: limit);

      // تحقق: في كروت؟
      if (cards.isEmpty) {
        // مفيش حاجة تتراجع ──► خلصنا!
        emit(RevisionFinished(totalReviewed: 0));
        return;
      }

      // في كروت ──► ابدأ المراجعة
      emit(RevisionReady(queue: cards));
    } catch (e) {
      // حصل error ──► اعرضه للمستخدم
      emit(RevisionError(message: e.toString()));
    }
  }

  // ══════════════════════════════════════════════════
  //   2. إظهار الإجابة
  // ══════════════════════════════════════════════════
  /// المستخدم يضغط "Show Answer" - نعرض الإجابة
  void showAnswer() {
    // تحقق: أنا في حالة Ready؟
    if (state is! RevisionReady) return;
    
    final current = state as RevisionReady;
    
    // غير showAnswer لـ true
    emit(current.copyWith(showAnswer: true));
  }

  // ══════════════════════════════════════════════════
  //   3. تقييم الكارت ◄── القلب النابض
  // ══════════════════════════════════════════════════
  /// المستخدم يضغط على زر التقييم (Again/Hard/Good/Easy)
  Future<void> rate(int quality) async {
    // تحقق: أنا في حالة Ready؟
    if (state is! RevisionReady) return;
    
    final current = state as RevisionReady;
    final card = current.currentCard;

    // ══════════════════════════════════════════════════
    // خطوة 1: احسب الكارت الجديد بعد SM-2
    // ══════════════════════════════════════════════════
    final updatedCard = Sm2Scheduler.schedule(
      card: card,
      quality: quality,
    );
    // دلوقتي updatedCard عنده:
    // - due_date جديد
    // - state جديد
    // - ease محدث
    // - interval محدث

    // ══════════════════════════════════════════════════
    // خطوة 2: حدّث الـ Queue (اشمعنى نشيل الكارت الحالي)
    // ══════════════════════════════════════════════════
    List<BaseCardEntity> newQueue = List.from(current.queue);
    newQueue.removeAt(current.currentIndex); // شيل الكارت الحالي

    // ══════════════════════════════════════════════════
    // خطوة 3: لو Again - حط الكارت تاني في الـ Queue
    // ══════════════════════════════════════════════════
    if (quality == 0) {
      final now = DateTime.now();
      final dueDate = updatedCard.dueDate;
      
      // تحقق: الكارت due دلوقتي؟
      // (خلال دقيقة = margin of safety)
      if (dueDate.isBefore(now.add(const Duration(minutes: 1)))) {
        // ✅ آه، الكارت due دلوقتي
        
        // احسب فين نحطه بذكاء
        final insertPosition = _calculateInsertPosition(
          newQueue, 
          updatedCard,
          minCards: 2,  // على الأقل بعد كارتين
        );
        
        // حط الكارت في المكان المناسب
        newQueue.insert(insertPosition, updatedCard);
      }
      // لو الكارت مش due دلوقتي:
      // - مش هنحطه في الـ queue
      // - هيظهر في الجلسة الجاية لما يبقى due
    }

    // زود عداد الكروت المراجعة
    _totalReviewed++;

    // ══════════════════════════════════════════════════
    // خطوة 4: حدّث الـ State
    // ══════════════════════════════════════════════════
    
    // تحقق: الـ Queue خلص؟
    if (newQueue.isEmpty) {
      // ✅ آه ──► خلصنا المراجعة!
      emit(RevisionFinished(totalReviewed: _totalReviewed));
    } else {
      // ❌ لأ ──► كمل المراجعة
      emit(current.copyWith(
        queue: newQueue,
        currentIndex: 0,        // دايماً ابدأ من أول كارت
        showAnswer: false,      // اخفي الإجابة
      ));
    }

    // ══════════════════════════════════════════════════
    // خطوة 5: احفظ في Firestore (في الـ Background)
    // ══════════════════════════════════════════════════
    try {
      await _repo.submitRating(card: card, quality: quality);
      // ✅ تم الحفظ
    } catch (e) {
      // ❌ فشل الحفظ
      // مش مشكلة - الـ UI شغال
      // ممكن نضيف Offline Queue هنا
    }
  }

  // ══════════════════════════════════════════════════
  //   4. حساب مكان إدراج الكارت بذكاء
  // ══════════════════════════════════════════════════
  /// بنحط الكارت في مكان مناسب - مش في أول الـ queue علطول
  /// ده علشان نتجنب "Again clusters" (كروت Again ورا بعض)
  int _calculateInsertPosition(
    List<BaseCardEntity> queue,
    BaseCardEntity cardToInsert,
    {int minCards = 2}  // على الأقل بعد كارتين
  ) {
    // لو الـ queue فاضي ──► حط في أول مكان
    if (queue.isEmpty) return 0;

    // ══════════════════════════════════════════════════
    // عد: كم كارت Again قبله في الـ queue؟
    // ══════════════════════════════════════════════════
    int againCardsAhead = 0;
    for (var card in queue) {
      // لو الكارت ده Again (learning أو relearning)
      if (card.state == CardState.learning || 
          card.state == CardState.relearning) {
        againCardsAhead++;  // زود العداد
      } else {
        break;  // أول ما تلاقي كارت عادي، وقف
      }
    }

    // ══════════════════════════════════════════════════
    // احسب المكان المناسب
    // ══════════════════════════════════════════════════
    // القاعدة: حط الكارت بعد كل الـ Again + minCards
    final position = againCardsAhead + minCards;
    
    // تأكد إن المكان مش برة الـ queue
    return position.clamp(0, queue.length);
  }
  
  // مثال:
  // Queue = [Again1, Again2, Normal1, Normal2, Normal3]
  //           ↑       ↑
  //          againCardsAhead = 2
  // 
  // position = 2 + 2 = 4
  // Queue = [Again1, Again2, Normal1, Normal2, NewAgain, Normal3]
  //                                             ↑ هنا

  // ══════════════════════════════════════════════════
  //   5. حذف كارت
  // ══════════════════════════════════════════════════
  /// المستخدم يحذف كارت من الـ collection
  Future<void> deleteCard(String cardId) async {
    if (state is! RevisionReady) return;
    
    final current = state as RevisionReady;

    try {
      // احذف من الـ queue المحلي
      List<BaseCardEntity> newQueue = List.from(current.queue);
      newQueue.removeWhere((c) => c.id == cardId);

      // تحقق: الـ queue خلص؟
      if (newQueue.isEmpty) {
        emit(RevisionFinished(totalReviewed: _totalReviewed));
      } else {
        emit(current.copyWith(
          queue: newQueue,
          currentIndex: current.currentIndex.clamp(0, newQueue.length - 1),
          showAnswer: false,
        ));
      }
    } catch (e) {
      emit(RevisionError(message: e.toString()));
    }
  }
}