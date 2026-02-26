// 📁 logic/cubit/revision_cubit.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_cards/Features/Revision/Data/Repos_impl/revision_repo_impl.dart';
import 'package:smart_cards/Features/Revision/Presentation/View_model/logic/SM2_algorithm.dart';
import 'package:smart_cards/core/Domain/Entities/base_card_entity.dart';
import 'package:smart_cards/Features/Revision/Presentation/View_model/revision_cubit/revision_states.dart';

// ════════════════════════════════════════════════════════════════
// RevisionCubit - Anki Queue System
//
// ✅ 3 queues منفصلة زي Anki بالظبط:
//   - _learningQueue  🟡 (learning + relearning) → sorted by dueDate
//   - _reviewQueue    🔵 (review)
//   - _newQueue       🟢 (new cards)
//
// ✅ Priority Order:
//   learningQueue (due only) → reviewQueue → newQueue
//
// ✅ Query Firestore مرة واحدة في بداية الجلسة بس
// ════════════════════════════════════════════════════════════════

class RevisionCubit extends Cubit<RevisionState> {
  final RevisionRepo _repo;

  // ══════════════════════════════════════════════════
  //   ✅ الـ 3 Queues - قلب النظام
  // ══════════════════════════════════════════════════

  /// 🟡 كروت في التعلم أو إعادة التعلم
  /// مرتبة حسب dueDate (Priority Queue)
  /// بيرجعلها الكارت لو Again/Hard
  List<BaseCardEntity> _learningQueue = [];

  /// 🔵 كروت جاهزة للمراجعة
  List<BaseCardEntity> _reviewQueue = [];

  /// 🟢 كروت جديدة (لسه ماتشافتش)
  List<BaseCardEntity> _newQueue = [];

  int _totalReviewed = 0;
  final Map<String, BaseCardEntity> _modifiedCards = {};

  RevisionCubit(this._repo) : super(RevisionLoading());

  // ══════════════════════════════════════════════════
  //   1. تحميل الكروت من Firestore ✅ مرة واحدة بس
  // ══════════════════════════════════════════════════
  Future<void> loadCards(String collectionId, {int limit = 100}) async {
    emit(RevisionLoading());

    try {
      // ✅ Query Firestore مرة واحدة بس
      final cards = await _repo.getDueCards(collectionId, limit: limit);

      if (cards.isEmpty) {
        emit(RevisionFinished(totalReviewed: 0));
        return;
      }

      // ✅ بناء الـ 3 queues
      _buildQueues(cards);

      // ✅ جيب أول كارت وابدأ الجلسة
      _emitNextCard();
    } catch (e) {
      emit(RevisionError(message: e.toString()));
    }
  }

  // ══════════════════════════════════════════════════
  //   2. بناء الـ 3 Queues ✅ الجوهر
  // ══════════════════════════════════════════════════
  void _buildQueues(List<BaseCardEntity> cards) {
    _learningQueue = [];
    _reviewQueue = [];
    _newQueue = [];

    for (final card in cards) {
      switch (card.state) {
        // 🟡 learning + relearning → learningQueue
        case CardState.learning:
        case CardState.relearning:
          _learningQueue.add(card);
          break;

        // 🔵 review → reviewQueue
        case CardState.review:
          _reviewQueue.add(card);
          break;

        // 🟢 new → newQueue
        case CardState.newCard:
          _newQueue.add(card);
          break;
      }
    }

    // ✅ رتب learningQueue حسب dueDate (الأقدم الأول)
    _learningQueue.sort((a, b) => a.dueDate.compareTo(b.dueDate));

    // reviewQueue و newQueue جايين من Firestore مرتبين بالفعل
  }

  // ══════════════════════════════════════════════════
  //   3. getNextCard ✅ Anki Priority بالظبط
  // ══════════════════════════════════════════════════
  //
  //   Priority: learningQueue (due only) → reviewQueue → newQueue
  //
  //   مهم: learningQueue بيتشيل منها الكارت بس لو due دلوقتي
  //   لو مش due → نروح reviewQueue أو newQueue
  //
  BaseCardEntity? _getNextCard() {
    final now = DateTime.now();

    // ──────────────────────────────────────
    // 1️⃣ learningQueue أولاً (لو الكارت due)
    // ──────────────────────────────────────
    if (_learningQueue.isNotEmpty) {
      final card = _learningQueue.first;

      final isDue =
          card.dueDate.isBefore(now) || card.dueDate.isAtSameMomentAs(now);

      if (isDue) {
        // ✅ الكارت due → اشيله من الـ queue واعرضه
        return _learningQueue.removeAt(0);
      }
      // ❌ الكارت مش due بعد → مش هنوقف هنا
      //    هننزل للـ review أو new
    }

    // ──────────────────────────────────────
    // 2️⃣ reviewQueue
    // ──────────────────────────────────────
    if (_reviewQueue.isNotEmpty) {
      return _reviewQueue.removeAt(0);
    }

    // ──────────────────────────────────────
    // 3️⃣ newQueue
    // ──────────────────────────────────────
    if (_newQueue.isNotEmpty) {
      return _newQueue.removeAt(0);
    }

    // مفيش كروت خالص
    return null;
  }

  // ══════════════════════════════════════════════════
  //   4. إظهار الإجابة
  // ══════════════════════════════════════════════════
  void showAnswer() {
    if (state is! RevisionReady) return;
    emit((state as RevisionReady).copyWith(showAnswer: true));
  }

  // ══════════════════════════════════════════════════
  //   5. تقييم الكارت ✅ القلب النابض
  // ══════════════════════════════════════════════════
  Future<void> rate(int quality) async {
    if (state is! RevisionReady) return;

    final card = (state as RevisionReady).currentCard;

    // ════════════════════════
    // خطوة 1: حساب SM-2
    // ════════════════════════
    final updatedCard = Sm2Scheduler.schedule(card: card, quality: quality);

    // ✅ احفظ في modified map (مش في Firestore بعد)
    _modifiedCards[updatedCard.id] = updatedCard;

    // ════════════════════════
    // خطوة 2: لو الكارت لسه learning/relearning → رجعه في learningQueue
    // ════════════════════════
    if (updatedCard.state == CardState.learning ||
        updatedCard.state == CardState.relearning) {
      // ✅ ضيف في learningQueue مرتب حسب dueDate
      _learningQueue.add(updatedCard);
      _learningQueue.sort((a, b) => a.dueDate.compareTo(b.dueDate));
      // مثال: Again على كارت → dueDate = now + 1min
      // هيرجع في learningQueue في مكانه الصح
    }
    // لو graduated (review) → مش هيرجع في الجلسة دي ✅

    _totalReviewed++;

    // ════════════════════════
    // خطوة 3: جيب الكارت الجاي
    // ════════════════════════
    _emitNextCard();

    // ════════════════════════
    // خطوة 4: Background save كل 5 كروت
    // ════════════════════════
    if (_totalReviewed % 5 == 0) {
      _saveModifiedCards(); // fire and forget
    }
  }

  // ══════════════════════════════════════════════════
  //   6. emit الحالة الجاية ✅ المنطق الذكي
  // ══════════════════════════════════════════════════
  void _emitNextCard() {
    // جرب تجيب الكارت الجاي
    final nextCard = _getNextCard();

    if (nextCard != null) {
      // ✅ في كارت → اعرضه
      emit(
        RevisionReady(
          currentCard: nextCard,
          learningCount: _learningQueue.length,
          reviewCount: _reviewQueue.length,
          newCount: _newQueue.length,
        ),
      );
      return;
    }

    // مفيش كارت من getNextCard
    // ممكن يكون في كروت في learningQueue بس مش due بعد
    if (_learningQueue.isNotEmpty) {
      // ✅ في انتظار → اعرض Waiting screen
      emit(
        RevisionWaiting(
          nextDueDate: _learningQueue.first.dueDate,
          totalReviewed: _totalReviewed,
          remainingLearning: _learningQueue.length,
        ),
      );
      return;
    }

    // مفيش أي كروت خالص → الجلسة خلصت
    _saveModifiedCards();
    emit(RevisionFinished(totalReviewed: _totalReviewed));
  }

  // ══════════════════════════════════════════════════
  //   7. skipToNextAvailable
  // ══════════════════════════════════════════════════
  // المستخدم مش عايز يستنى → اعرضه الكارت بردو حتى لو مش due
  void skipToNextAvailable() {
    if (state is! RevisionWaiting) return;

    if (_learningQueue.isEmpty) return;

    // اجبر إظهار أول كارت في learningQueue
    final card = _learningQueue.removeAt(0);

    emit(
      RevisionReady(
        currentCard: card,
        learningCount: _learningQueue.length,
        reviewCount: _reviewQueue.length,
        newCount: _newQueue.length,
      ),
    );
  }

  // ══════════════════════════════════════════════════
  //   8. حذف كارت
  // ══════════════════════════════════════════════════
  Future<void> deleteCard(String cardId) async {
    if (state is! RevisionReady) return;

    try {
      await _repo.deleteCard(cardId);

      // احذف من الـ 3 queues لو موجود فيهم
      _learningQueue.removeWhere((c) => c.id == cardId);
      _reviewQueue.removeWhere((c) => c.id == cardId);
      _newQueue.removeWhere((c) => c.id == cardId);
      _modifiedCards.remove(cardId);

      // جيب الكارت الجاي
      _emitNextCard();
    } catch (e) {
      emit(RevisionError(message: e.toString()));
    }
  }

  // ══════════════════════════════════════════════════
  //   9. حفظ الكروت في Firestore
  // ══════════════════════════════════════════════════
  Future<void> _saveModifiedCards() async {
    if (_modifiedCards.isEmpty) return;

    try {
      await _repo.updateCardsBatch(_modifiedCards.values.toList());
      _modifiedCards.clear();
    } catch (e) {
      // Silent fail - هنحاول في close()
      print('❌ Failed to save: $e');
    }
  }

  // ══════════════════════════════════════════════════
  //   10. Cleanup
  // ══════════════════════════════════════════════════
  @override
  Future<void> close() async {
    await _saveModifiedCards();
    return super.close();
  }
}
