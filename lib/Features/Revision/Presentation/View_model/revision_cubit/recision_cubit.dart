// 📁 logic/cubit/revision_cubit.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_cards/Features/Revision/Presentation/View_model/logic/SM2_algorithm.dart';
import 'package:smart_cards/core/Domain/Entities/base_card_entity.dart';
import 'package:smart_cards/Features/Revision/Data/revision_remote_data_source/revision_remote_data_source_impl.dart';
import 'package:smart_cards/Features/Revision/Presentation/View_model/revision_cubit/revision_states.dart';

class RevisionCubit extends Cubit<RevisionState> {
  final RevisionRepo _repo;
  int _totalReviewed = 0;

  RevisionCubit(this._repo) : super(RevisionLoading());

  // ══════════════════════════════════════════════════
  //   تحميل الكروت
  // ══════════════════════════════════════════════════
  Future<void> loadCards(String collectionId, {int limit = 100}) async {
    emit(RevisionLoading());
    try {
      final cards = await _repo.getDueCards(collectionId, limit: limit);

      if (cards.isEmpty) {
        emit(RevisionFinished(totalReviewed: 0));
        return;
      }

      emit(RevisionReady(queue: cards));
    } catch (e) {
      emit(RevisionError(message: e.toString()));
    }
  }

  // ══════════════════════════════════════════════════
  //   إظهار الإجابة
  // ══════════════════════════════════════════════════
  void showAnswer() {
    if (state is! RevisionReady) return;
    final current = state as RevisionReady;
    emit(current.copyWith(showAnswer: true));
  }

  // ══════════════════════════════════════════════════
  //   تقييم الكارت ✅ المحدّث
  // ══════════════════════════════════════════════════
  Future<void> rate(int quality) async {
    if (state is! RevisionReady) return;
    final current = state as RevisionReady;
    final card = current.currentCard;

    // ──────────────────────────
    //   1. احسب SM-2 أولاً
    // ──────────────────────────
    final updatedCard = Sm2Scheduler.schedule(
      card: card,
      quality: quality,
    );

    // ──────────────────────────
    //   2. حدّث الـ Queue
    // ──────────────────────────
    List<BaseCardEntity> newQueue = List.from(current.queue);
    newQueue.removeAt(current.currentIndex);

    // ✅ لو Again ──► حط الكارت في الـ Queue بناءً على الـ due_date
    if (quality == 0) {
      // تحقق متى الكارت هيبقى due
      final now = DateTime.now();
      final dueDate = updatedCard.dueDate;
      
      // لو الكارت due دلوقتي أو قريب (خلال دقيقة) ──► حطه في الـ queue
      if (dueDate.isBefore(now.add(const Duration(minutes: 1)))) {
        // ✅ حط الكارت بعد كروت معينة حسب عددهم
        final insertPosition = _calculateInsertPosition(
          newQueue, 
          updatedCard,
          minCards: 2,  // على الأقل بعد كارتين
        );
        
        newQueue.insert(insertPosition, updatedCard);
      }
      // لو الكارت مش due دلوقتي ──► خليه يظهر في الجلسة الجاية
    }

    _totalReviewed++;

    // ──────────────────────────
    //   3. حدّث الـ State
    // ──────────────────────────
    if (newQueue.isEmpty) {
      emit(RevisionFinished(totalReviewed: _totalReviewed));
    } else {
      emit(current.copyWith(
        queue: newQueue,
        currentIndex: 0,  // ✅ دايماً ابدأ من 0
        showAnswer: false,
      ));
    }

    // ──────────────────────────
    //   4. حفظ في Background
    // ──────────────────────────
    try {
      await _repo.submitRating(card: card, quality: quality);
    } catch (e) {
      // Silent fail
    }
  }

  // ══════════════════════════════════════════════════
  //   حساب مكان الإدراج بذكاء
  // ══════════════════════════════════════════════════
  int _calculateInsertPosition(
    List<BaseCardEntity> queue,
    BaseCardEntity cardToInsert,
    {int minCards = 2}
  ) {
    if (queue.isEmpty) return 0;

    // ✅ عد الكروت اللي قبلها كمان Again
    int againCardsAhead = 0;
    for (var card in queue) {
      if (card.state == CardState.learning || 
          card.state == CardState.relearning) {
        againCardsAhead++;
      } else {
        break;  // أول ما تلاقي كارت مش Again، وقف
      }
    }

    // ✅ حط الكارت بعد كل الـ Again cards + minCards
    final position = againCardsAhead + minCards;
    
    return position.clamp(0, queue.length);
  }

  // ══════════════════════════════════════════════════
  //   حذف كارت
  // ══════════════════════════════════════════════════
  Future<void> deleteCard(String cardId) async {
    if (state is! RevisionReady) return;
    final current = state as RevisionReady;

    try {
     // await _repo.deleteCard(cardId);

      List<BaseCardEntity> newQueue = List.from(current.queue);
      newQueue.removeWhere((c) => c.id == cardId);

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