// 📁 logic/sm2_scheduler.dart

import 'package:smart_cards/core/Domain/Entities/base_card_entity.dart';

class Sm2Scheduler {

  // ══════════════════════════════════════════════════
  //   Config
  // ══════════════════════════════════════════════════
  static const List<int> _learningSteps = [1, 10];   // دقايق
  static const List<int> _relearnSteps  = [10];       // دقايق
  static const int    _graduatingInterval = 1;        // يوم
  static const int    _easyInterval       = 4;        // أيام
  static const double _easyBonus          = 1.3;
  static const double _hardMultiplier     = 1.2;
  static const int    _maxInterval        = 36500;    // يوم (~100 سنة)
  static const double _minEase            = 1.3;

  // ══════════════════════════════════════════════════
  //   الـ Method الرئيسية
  // ══════════════════════════════════════════════════
  static BaseCardEntity schedule({
    required BaseCardEntity card,
    required int quality,   // 0=Again | 1=Hard | 3=Good | 4=Easy
  }) {
    switch (card.state) {
      case CardState.newCard:
        return _handleNew(card, quality);
      case CardState.learning:
        return _handleLearning(card, quality);
      case CardState.review:
        return _handleReview(card, quality);
      case CardState.relearning:
        return _handleRelearning(card, quality);
    }
  }

  // ══════════════════════════════════════════════════
  //   1. NEW CARD
  // ══════════════════════════════════════════════════
  static BaseCardEntity _handleNew(BaseCardEntity card, int quality) {
    if (quality == 4) {
      // Easy ──► تخرج فوراً للـ Review
      return card.copyWith(
        state: CardState.review,
        repetition: 1,
        interval: _easyInterval,
        dueDate: _daysFromNow(_easyInterval),
      );
    }

    if (quality == 0) {
      // Again ──► ابدأ Learning من Step 0
      return card.copyWith(
        state: CardState.learning,
        currentStep: 0,
        dueDate: _minutesFromNow(_learningSteps[0]),
      );
    }

    // ✅ Hard (1) أو Good (3) ──► ابدأ Learning
    // Hard يبدأ من نفس المكان بس بيخفض الـ ease شوية
    if (quality == 1) {
      // Hard ──► ابدأ Learning مع تخفيض الـ ease
      final newEase = (card.ease - 0.15).clamp(_minEase, 2.5);
      return card.copyWith(
        state: CardState.learning,
        currentStep: 0,
        ease: double.parse(newEase.toStringAsFixed(2)),
        dueDate: _minutesFromNow(_learningSteps[0]),
      );
    }

    // Good (3) ──► ابدأ Learning عادي
    return card.copyWith(
      state: CardState.learning,
      currentStep: 0,
      dueDate: _minutesFromNow(_learningSteps[0]),
    );
  }

  // ══════════════════════════════════════════════════
  //   2. LEARNING CARD
  // ══════════════════════════════════════════════════
  static BaseCardEntity _handleLearning(BaseCardEntity card, int quality) {
    if (quality == 0) {
      // Again ──► ارجع لأول Step
      return card.copyWith(
        currentStep: 0,
        dueDate: _minutesFromNow(_learningSteps[0]),
      );
    }

    // ✅ Hard Logic في Learning
    if (quality == 1) {
      // Hard ──► كرر الـ Step الحالي بدل ما تتقدم
      return card.copyWith(
        dueDate: _minutesFromNow(_learningSteps[card.currentStep]),
      );
    }

    // Good (3) أو Easy (4) ──► اتقدم للـ Step الجاي
    final nextStep = card.currentStep + 1;

    // لو خلصت كل الـ Steps ──► GRADUATE
    if (nextStep >= _learningSteps.length) {
      final interval = quality == 4 ? _easyInterval : _graduatingInterval;
      return card.copyWith(
        state: CardState.review,
        repetition: 1,
        interval: interval,
        currentStep: 0,
        dueDate: _daysFromNow(interval),
      );
    }

    // لسه في Steps ──► اتقدم
    return card.copyWith(
      currentStep: nextStep,
      dueDate: _minutesFromNow(_learningSteps[nextStep]),
    );
  }

  // ══════════════════════════════════════════════════
  //   3. REVIEW CARD  ◄── قلب SM-2
  // ══════════════════════════════════════════════════
  static BaseCardEntity _handleReview(BaseCardEntity card, int quality) {

    // ────────────────────────────
    //   Again ──► Relearning
    // ────────────────────────────
    if (quality == 0) {
      final newEase = (card.ease - 0.2).clamp(_minEase, 2.5);
      return card.copyWith(
        state: CardState.relearning,
        ease: double.parse(newEase.toStringAsFixed(2)),
        repetition: 0,
        interval: 0,
        lapses: card.lapses + 1,
        currentStep: 0,
        dueDate: _minutesFromNow(_relearnSteps[0]),
      );
    }

    // ────────────────────────────
    //   احسب الـ Interval الجديد
    // ────────────────────────────
    int newInterval;

    if (card.repetition <= 1) {
      // أول مراجعتين ثابتين
      newInterval = card.repetition == 0 ? 1 : 6;
    } else {
      switch (quality) {
        case 1: // Hard
          newInterval = (card.interval * _hardMultiplier).round();
          break;
        case 4: // Easy
          newInterval = (card.interval * card.ease * _easyBonus).round();
          break;
        default: // Good (3)
          newInterval = (card.interval * card.ease).round();
      }
    }

    // ────────────────────────────
    //   احسب الـ Ease الجديد
    // ────────────────────────────
    final double newEase = (
      card.ease + (0.1 - (5 - quality) * (0.08 + (5 - quality) * 0.02))
    ).clamp(_minEase, 2.5);

    // ────────────────────────────
    //   Cap الـ Interval
    // ────────────────────────────
    newInterval = newInterval.clamp(1, _maxInterval);

    return card.copyWith(
      repetition: card.repetition + 1,
      ease: double.parse(newEase.toStringAsFixed(2)),
      interval: newInterval,
      dueDate: _daysFromNow(newInterval),
    );
  }

  // ══════════════════════════════════════════════════
  //   4. RELEARNING CARD
  // ══════════════════════════════════════════════════
  static BaseCardEntity _handleRelearning(BaseCardEntity card, int quality) {
    if (quality == 0) {
      // Again ──► ابقى في Relearning
      return card.copyWith(
        currentStep: 0,
        dueDate: _minutesFromNow(_relearnSteps[0]),
      );
    }

    // ✅ Hard في Relearning
    if (quality == 1) {
      // Hard ──► كرر الـ step الحالي
      return card.copyWith(
        dueDate: _minutesFromNow(_relearnSteps[card.currentStep.clamp(0, _relearnSteps.length - 1)]),
      );
    }

    // Good (3) / Easy (4) ──► ارجع للـ Review
    final interval = quality == 4 ? _easyInterval : _graduatingInterval;
    return card.copyWith(
      state: CardState.review,
      repetition: 1,
      interval: interval,
      currentStep: 0,
      dueDate: _daysFromNow(interval),
    );
  }

  // ══════════════════════════════════════════════════
  //   Helpers
  // ══════════════════════════════════════════════════
  static DateTime _minutesFromNow(int minutes) =>
      DateTime.now().add(Duration(minutes: minutes));

  static DateTime _daysFromNow(int days) =>
      DateTime.now().add(Duration(days: days));
}