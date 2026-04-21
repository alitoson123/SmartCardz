import 'package:smart_cards/core/Domain/Entities/base_card_entity.dart';

class Sm2Scheduler {
  // ══════════════════════════════════════════════════
  //   الإعدادات
  // ══════════════════════════════════════════════════
  static const List<int> _learningSteps = [1, 10];
  static const List<int> _relearnSteps = [10];
  static const int _graduatingInterval = 1;
  static const int _easyInterval = 4;
  static const double _easyBonus = 1.3;
  static const double _lapseMultiplier = 0.5;
  static const int _maxInterval = 36500;
  static const double _minEase = 1.3;

  static BaseCardEntity schedule({
    required BaseCardEntity card,
    required int quality,
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
  //   🟢 1. NEW CARD
  // ══════════════════════════════════════════════════
  static BaseCardEntity _handleNew(BaseCardEntity card, int quality) {
    if (quality == 4) { // Easy
      return card.copyWith(
        state: CardState.review,
        repetition: 1,
        interval: _easyInterval,
        dueDate: _daysFromNow(_easyInterval),
      );
    }

    if (quality == 0) { // Again
      return card.copyWith(
        state: CardState.learning,
        currentStep: 0,
        dueDate: _minutesFromNow(_learningSteps[0]),
      );
    }

    // Medium (3)
    return card.copyWith(
      state: CardState.learning,
      currentStep: 1,
      dueDate: _minutesFromNow(_learningSteps[1]),
    );
  }

  // ══════════════════════════════════════════════════
  //   🟡 2. LEARNING CARD
  // ══════════════════════════════════════════════════
  static BaseCardEntity _handleLearning(BaseCardEntity card, int quality) {
    if (quality == 0) { // Again: رجع لأول step
      return card.copyWith(
        currentStep: 0,
        dueDate: _minutesFromNow(_learningSteps[0]),
      );
    }

    if (quality == 4) { // Easy → graduate فوراً
      return card.copyWith(
        state: CardState.review,
        repetition: 1,
        interval: _easyInterval, // 4 أيام
        currentStep: 0,
        dueDate: _daysFromNow(_easyInterval),
      );
    }

    // Medium (3): اتقدم للـ step الجاي
    final nextStep = card.currentStep + 1;

    if (nextStep >= _learningSteps.length) {
      // خلصت الـ steps → graduate
      return card.copyWith(
        state: CardState.review,
        repetition: 1,
        interval: _graduatingInterval, // 1 يوم
        currentStep: 0,
        dueDate: _daysFromNow(_graduatingInterval),
      );
    }

    return card.copyWith(
      currentStep: nextStep,
      dueDate: _minutesFromNow(_learningSteps[nextStep]),
    );
  }

  // ══════════════════════════════════════════════════
  //   🔵 3. REVIEW CARD
  // ══════════════════════════════════════════════════
  static BaseCardEntity _handleReview(BaseCardEntity card, int quality) {
    if (quality == 0) { // Again
      final newEase = (card.ease - 0.2).clamp(_minEase, 2.5);

      return card.copyWith(
        state: CardState.relearning,
        ease: double.parse(newEase.toStringAsFixed(2)),
        repetition: 0,
        interval: card.interval, // نحتفظ بيه
        lapses: card.lapses + 1,
        currentStep: 0,
        dueDate: _minutesFromNow(_relearnSteps[0]),
      );
    }

    int newInterval;

    if (card.repetition == 0) { // أول مراجعة
      newInterval = (quality == 4) ? _easyInterval : 1;
    } else if (card.repetition == 1) { // تاني مراجعة
      if (quality == 4) { // Easy
        newInterval = (card.interval * card.ease * _easyBonus).round();
      } else { // Medium (3)
        newInterval = 6;
      }
    } else { // بعد المراجعة التانية
      if (quality == 4) { // Easy
        newInterval = (card.interval * card.ease * _easyBonus).round();
      } else { // Medium (3)
        newInterval = (card.interval * card.ease).round();
      }
    }

    // حساب ease: Medium يحافظ عليه، Easy يزوده، Again ينقصه
    double newEase = card.ease;
    if (quality == 4) {
      newEase += 0.15;
    } 
    // Medium (3) ease stays the same 
    newEase = newEase.clamp(_minEase, 2.5);

    newInterval = newInterval.clamp(1, _maxInterval);

    return card.copyWith(
      repetition: card.repetition + 1,
      ease: double.parse(newEase.toStringAsFixed(2)),
      interval: newInterval,
      dueDate: _daysFromNow(newInterval),
    );
  }

  // ══════════════════════════════════════════════════
  //   🔴 4. RELEARNING CARD
  // ══════════════════════════════════════════════════
  static BaseCardEntity _handleRelearning(BaseCardEntity card, int quality) {
    if (quality == 0) { // Again
      return card.copyWith(
        currentStep: 0,
        dueDate: _minutesFromNow(_relearnSteps[0]),
      );
    }

    int newInterval;

    if (quality == 4) { // Easy
      newInterval = _easyInterval;
    } else { // Medium (3)
      final previousInterval = card.interval;

      if (previousInterval > 0) {
        newInterval = (previousInterval * _lapseMultiplier).round();
      } else {
        newInterval = _graduatingInterval;
      }

      newInterval = newInterval.clamp(1, _maxInterval);
    }

    return card.copyWith(
      state: CardState.review,
      repetition: 1,
      interval: newInterval,
      currentStep: 0,
      dueDate: _daysFromNow(newInterval),
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

