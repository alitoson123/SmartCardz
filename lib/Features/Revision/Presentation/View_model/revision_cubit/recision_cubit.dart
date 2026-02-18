// 📁 logic/cubit/revision_cubit.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_cards/Features/Add_normal_card/Domain/Entities/normal_card_entity.dart';
import 'package:smart_cards/Features/Revision/Data/revision_remote_data_source/revision_remote_data_source_impl.dart';
import 'package:smart_cards/Features/Revision/Presentation/View_model/revision_cubit/revision_states.dart';
import 'package:smart_cards/core/Domain/Entities/base_card_entity.dart';


class RevisionCubit extends Cubit<RevisionState> {
  final RevisionRepo _repo;
  int _totalReviewed = 0;

  RevisionCubit(this._repo) : super(RevisionLoading());

  // ══════════════════════════════════════════════════
  //   1. تحميل الكروت
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
  //   2. إظهار الإجابة
  // ══════════════════════════════════════════════════
  void showAnswer() {
    if (state is! RevisionReady) return;
    final current = state as RevisionReady;
    emit(current.copyWith(showAnswer: true));
  }

  // ══════════════════════════════════════════════════
  //   3. تقييم الكارت
  // ══════════════════════════════════════════════════
  Future<void> rate(int quality) async {
    if (state is! RevisionReady) return;
    final current = state as RevisionReady;
    final card = current.currentCard;

    // ──────────────────────────
    //   UI فورية (Optimistic)
    // ──────────────────────────
    List<BaseCardEntity> newQueue = List.from(current.queue);
    newQueue.removeAt(current.currentIndex);

    // لو Again ──► حط الكارت تاني في الـ Queue بعد 3 كروت
    if (quality == 0) {
      final updatedCard = card.copyWith(
        state: card.state == CardState.review
            ? CardState.relearning
            : CardState.learning,
      );
      final insertAt = (3).clamp(0, newQueue.length);
      newQueue.insert(insertAt, updatedCard);
    }

    // لو الـ Queue خلصت ──► انهي المراجعة
    if (newQueue.isEmpty || 
        (quality != 0 && current.currentIndex >= newQueue.length)) {
      _totalReviewed++;
      emit(RevisionFinished(totalReviewed: _totalReviewed));
    } else {
      _totalReviewed++;
      emit(current.copyWith(
        queue: newQueue,
        currentIndex: quality == 0 ? current.currentIndex : current.currentIndex,
        showAnswer: false,
      ));
    }

    // ──────────────────────────
    //   حفظ في الـ Background
    // ──────────────────────────
    try {
      await _repo.submitRating(card: card, quality: quality);
    } catch (e) {
      // حتى لو fail مش هنوقف الـ UI
      // ممكن تضيف Offline Queue هنا
    }
  }
}