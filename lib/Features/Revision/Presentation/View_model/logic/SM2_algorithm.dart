// 📁 logic/sm2_scheduler.dart

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
  static const double _hardStepMultiplier = 1.2;
  static const double _hardIntervalMultiplier = 1.2;
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
  //   🟢 1. NEW CARD (بدون تغيير)
  // ══════════════════════════════════════════════════
  static BaseCardEntity _handleNew(BaseCardEntity card, int quality) {
    if (quality == 4) {
      return card.copyWith(
        state: CardState.review,
        repetition: 1,
        interval: _easyInterval,
        dueDate: _daysFromNow(_easyInterval),
      );
    }

    if (quality == 0) {
      return card.copyWith(
        state: CardState.learning,
        currentStep: 0,
        dueDate: _minutesFromNow(_learningSteps[0]),
      );
    }

    if (quality == 1) {
      final newEase = (card.ease - 0.15).clamp(_minEase, 2.5);
      final hardStepDuration = (_learningSteps[0] * _hardStepMultiplier).round();
      return card.copyWith(
        state: CardState.learning,
        currentStep: 0,
        ease: double.parse(newEase.toStringAsFixed(2)),
        dueDate: _minutesFromNow(hardStepDuration),
      );
    }

    return card.copyWith(
      state: CardState.learning,
      currentStep: 1,
      dueDate: _minutesFromNow(_learningSteps[1]),
    );
  }

  // ══════════════════════════════════════════════════
  //   🟡 2. LEARNING CARD ✅ التعديل الأول
  // ══════════════════════════════════════════════════
  static BaseCardEntity _handleLearning(BaseCardEntity card, int quality) {
    
    // Again: رجع لأول step
    if (quality == 0) {
      return card.copyWith(
        currentStep: 0,
        dueDate: _minutesFromNow(_learningSteps[0]),
      );
    }

    // ✅ FIX 1: Easy يخرج فوراً في أي step
    // ────────────────────────────────────────
    if (quality == 4) {
      // 🔥 Easy → graduate فوراً حتى لو مش في آخر step
      return card.copyWith(
        state: CardState.review,
        repetition: 1,
        interval: _easyInterval,         // 4 أيام
        currentStep: 0,
        dueDate: _daysFromNow(_easyInterval),
      );
    }

    // Hard: كرر نفس step
    if (quality == 1) {
      return card.copyWith(
        dueDate: _minutesFromNow(_learningSteps[card.currentStep]),
      );
    }

    // Good: اتقدم للـ step الجاي
    final nextStep = card.currentStep + 1;

    if (nextStep >= _learningSteps.length) {
      // خلصت الـ steps → graduate
      return card.copyWith(
        state: CardState.review,
        repetition: 1,
        interval: _graduatingInterval,   // 1 يوم
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
  //   🔵 3. REVIEW CARD ✅ التعديل الثاني
  // ══════════════════════════════════════════════════
  static BaseCardEntity _handleReview(BaseCardEntity card, int quality) {

    // ✅ FIX 3: احفظ الـ interval القديم قبل ما تمسحه
    // ────────────────────────────────────────
    if (quality == 0) {
      final newEase = (card.ease - 0.2).clamp(_minEase, 2.5);
      
      // 🔥 نحفظ interval القديم في metadata
      // علشان نستخدمه لما نرجع من relearning
      return card.copyWith(
        state: CardState.relearning,
        ease: double.parse(newEase.toStringAsFixed(2)),
        repetition: 0,
        interval: card.interval,         // ✅ نحتفظ بيه! (مش 0)
        lapses: card.lapses + 1,
        currentStep: 0,
        dueDate: _minutesFromNow(_relearnSteps[0]),
      );
    }

    // ✅ FIX 2: Hard يتحسب حتى في أول مراجعتين
    // ────────────────────────────────────────
    int newInterval;

    if (card.repetition == 0) {
      // أول مراجعة
      if (quality == 1) {
        // Hard → أقل من Good
        newInterval = 1;
      } else {
        // Good/Easy → 1 يوم
        newInterval = 1;
      }
    } 
    else if (card.repetition == 1) {
      // تاني مراجعة
      if (quality == 1) {
        // Hard → حوالي 3 أيام (أقل من 6)
        newInterval = (card.interval * _hardIntervalMultiplier).round();
        newInterval = newInterval.clamp(2, 5);
      } else if (quality == 4) {
        // Easy → أكتر من 6
        newInterval = (card.interval * card.ease * _easyBonus).round();
      } else {
        // Good → 6 أيام
        newInterval = 6;
      }
    }
    else {
      // بعد المراجعة التانية
      switch (quality) {
        case 1: // Hard
          newInterval = (card.interval * _hardIntervalMultiplier).round();
          break;
        case 4: // Easy
          newInterval = (card.interval * card.ease * _easyBonus).round();
          break;
        default: // Good (3)
          newInterval = (card.interval * card.ease).round();
      }
    }

    // حساب ease
    final double newEase = (
      card.ease + (0.1 - (5 - quality) * (0.08 + (5 - quality) * 0.02))
    ).clamp(_minEase, 2.5);

    newInterval = newInterval.clamp(1, _maxInterval);

    return card.copyWith(
      repetition: card.repetition + 1,
      ease: double.parse(newEase.toStringAsFixed(2)),
      interval: newInterval,
      dueDate: _daysFromNow(newInterval),
    );
  }

  // ══════════════════════════════════════════════════
  //   🔴 4. RELEARNING CARD ✅ التعديل الثالث
  // ══════════════════════════════════════════════════
  static BaseCardEntity _handleRelearning(BaseCardEntity card, int quality) {
    
    if (quality == 0) {
      return card.copyWith(
        currentStep: 0,
        dueDate: _minutesFromNow(_relearnSteps[0]),
      );
    }

    if (quality == 1) {
      return card.copyWith(
        dueDate: _minutesFromNow(
          _relearnSteps[card.currentStep.clamp(0, _relearnSteps.length - 1)]
        ),
      );
    }

    // ✅ FIX 3: استخدم الـ interval القديم المحفوظ
    // ────────────────────────────────────────
    int newInterval;
    
    if (quality == 4) {
      // Easy → 4 أيام
      newInterval = _easyInterval;
    } else {
      // Good → نص الفترة القديمة
      // 🔥 card.interval هنا فيه القيمة القديمة (محفوظة من Review)
      final previousInterval = card.interval;
      
      if (previousInterval > 0) {
        // استخدم نص الفترة القديمة
        newInterval = (previousInterval * _lapseMultiplier).round();
      } else {
        // fallback لو مفيش interval
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


/*// 📁 logic/sm2_scheduler.dart
// ════════════════════════════════════════════════════════════════
// هذا الملف هو قلب النظام - بيحسب متى كل كارت يتراجع تاني
// بيستخدم خوارزمية SM-2 (SuperMemo 2) الشهيرة
// ════════════════════════════════════════════════════════════════

import 'package:smart_cards/core/Domain/Entities/base_card_entity.dart';

class Sm2Scheduler {

  // ══════════════════════════════════════════════════
  //   الإعدادات - ممكن تعدلها حسب احتياجك
  // ══════════════════════════════════════════════════
  
  // خطوات التعلم للكروت الجديدة (بالدقائق)
  // [1, 10] = أول مرة بعد دقيقة، تاني مرة بعد 10 دقايق
  static const List<int> _learningSteps = [1, 10];
  
  // خطوات إعادة التعلم للكروت المنسية (بالدقائق)
  // [10] = بعد 10 دقايق
  static const List<int> _relearnSteps = [10];
  
  // الفترة عند التخرج من التعلم (بالأيام)
  static const int _graduatingInterval = 1; // يوم واحد
  
  // علي كارت جديد (بالايام) easy  الفترة لما تضغط 
  static const int _easyInterval = 4; // 4 أيام
  
  // مضاعف Easy (بيزود الفترة)
  static const double _easyBonus = 1.3; // 130%
  
  // مضاعف Hard (بيزود الفترة بس ببطء)
  static const double _hardMultiplier = 1.2; // 120%
  
  // أقصى فترة بين المراجعات (بالأيام)
  static const int _maxInterval = 36500; // حوالي 100 سنة
  
  // أقل معامل سهولة ممكن
  static const double _minEase = 1.3;

  // ══════════════════════════════════════════════════
  //   الـ Method الرئيسية - نقطة الدخول الوحيدة
  // ══════════════════════════════════════════════════
  /// بتاخد كارت + تقييم المستخدم ──► بترجع الكارت بعد التحديث
  /// 
  /// [card]: الكارت الحالي بكل بياناته
  /// [quality]: تقييم المستخدم
  ///   - 0 = Again (نسيت خالص)
  ///   - 1 = Hard (صعب)
  ///   - 3 = Good (كويس)
  ///   - 4 = Easy (سهل جداً)
  static BaseCardEntity schedule({
    required BaseCardEntity card,
    required int quality,
  }) {
    // بناءً على حالة الكارت، نختار الطريقة المناسبة
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
  //   1. معالجة الكروت الجديدة (NEW CARD)
  // ══════════════════════════════════════════════════
  /// الكارت بيتشاف أول مرة - بندخله في نظام التعلم
  static BaseCardEntity _handleNew(BaseCardEntity card, int quality) {
    
    // ────────────────────────────
    // Easy: الكارت سهل جداً ──► تخرج فوراً للمراجعة
    // ────────────────────────────
    if (quality == 4) {
      return card.copyWith(
        state: CardState.review,        // بقى في المراجعة
        repetition: 1,                   // عددت مراجعة وحدة
        interval: _easyInterval,         // هيرجع بعد 4 أيام
        dueDate: _daysFromNow(_easyInterval),
      );
    }

    // ────────────────────────────
    // Again: نسيت الكارت ──► ابدأ التعلم من الصفر
    // ────────────────────────────
    if (quality == 0) {
      return card.copyWith(
        state: CardState.learning,       // ادخل في التعلم
        currentStep: 0,                  // من أول step
        dueDate: _minutesFromNow(_learningSteps[0]), // بعد دقيقة
      );
    }

    // ────────────────────────────
    // Hard: صعب ──► ابدأ التعلم + خفض معامل السهولة
    // ────────────────────────────
    if (quality == 1) {
      // بنخفض الـ ease علشان الكارت ده صعب
      final newEase = (card.ease - 0.15).clamp(_minEase, 2.5);
      return card.copyWith(
        state: CardState.learning,
        currentStep: 0,
        ease: double.parse(newEase.toStringAsFixed(2)),
        dueDate: _minutesFromNow(_learningSteps[0]),
      );
    }

    // ────────────────────────────
    // Good: كويس ──► ابدأ التعلم العادي
    // ────────────────────────────
    return card.copyWith(
      state: CardState.learning,
      currentStep: 0,
      dueDate: _minutesFromNow(_learningSteps[0]),
    );
  }

  // ══════════════════════════════════════════════════
  //   2. معالجة الكروت في التعلم (LEARNING)
  // ══════════════════════════════════════════════════
  /// الكارت في مرحلة التعلم - بنتقدم في الخطوات [1min, 10min]
  static BaseCardEntity _handleLearning(BaseCardEntity card, int quality) {
    
    // ────────────────────────────
    // Again: ارجع لأول خطوة
    // ────────────────────────────
    if (quality == 0) {
      return card.copyWith(
        currentStep: 0,                  // رجع لـ Step 0
        dueDate: _minutesFromNow(_learningSteps[0]), // بعد دقيقة
      );
    }

    // ────────────────────────────
    // Hard: كرر نفس الخطوة (مش تتقدم)
    // ────────────────────────────
    if (quality == 1) {
      // لو في Step 0 ──► كرر بعد دقيقة
      // لو في Step 1 ──► كرر بعد 10 دقايق
      return card.copyWith(
        dueDate: _minutesFromNow(_learningSteps[card.currentStep]),
      );
    }

    // ────────────────────────────
    // Good أو Easy: اتقدم للخطوة الجاية
    // ────────────────────────────
    final nextStep = card.currentStep + 1;

    // تحقق: خلصت كل الخطوات؟
    if (nextStep >= _learningSteps.length) {
      // ✅ نعم ──► التخرج للمراجعة!
      final interval = quality == 4 ? _easyInterval : _graduatingInterval;
      return card.copyWith(
        state: CardState.review,       // بقى في المراجعة
        repetition: 1,                 // أول مراجعة
        interval: interval,            // 1 يوم (أو 4 لو Easy)
        currentStep: 0,
        dueDate: _daysFromNow(interval),
      );
    }

    // ❌ لأ ──► كمل في التعلم
    return card.copyWith(
      currentStep: nextStep,           // اتقدم للـ Step الجاي
      dueDate: _minutesFromNow(_learningSteps[nextStep]),
    );
  }

  // ══════════════════════════════════════════════════
  //   3. معالجة الكروت في المراجعة (REVIEW) 
  //      ◄── قلب خوارزمية SM-2
  // ══════════════════════════════════════════════════
  /// الكارت اتعلم وبنراجع عليه على فترات متباعدة
  static BaseCardEntity _handleReview(BaseCardEntity card, int quality) {

    // ────────────────────────────
    // Again: نسيت الكارت ──► إعادة تعلم
    // ────────────────────────────
    if (quality == 0) {
      // بنخفض الـ ease لأن الكارت صعب
      final newEase = (card.ease - 0.2).clamp(_minEase, 2.5);
      return card.copyWith(
        state: CardState.relearning,   // ادخل في إعادة التعلم
        ease: double.parse(newEase.toStringAsFixed(2)),
        repetition: 0,                 // ابدأ العد من الصفر
        interval: 0,
        lapses: card.lapses + 1,       // زود عداد النسيان
        currentStep: 0,
        dueDate: _minutesFromNow(_relearnSteps[0]), // بعد 10 دقايق
      );
    }

    // ────────────────────────────
    // حساب الفترة الجديدة (Interval)
    // ────────────────────────────
    int newInterval;

    // أول مراجعتين ثابتين (1 يوم، 6 أيام)
    if (card.repetition <= 1) {
      newInterval = card.repetition == 0 ? 1 : 6;
    } 
    // بعد كده بنستخدم المعادلة
    else {
      switch (quality) {
        case 1: // Hard
          // الفترة تزيد بس ببطء
          newInterval = (card.interval * _hardMultiplier).round();
          break;
          
        case 4: // Easy
          // الفترة تزيد بسرعة
          newInterval = (card.interval * card.ease * _easyBonus).round();
          break;
          
        default: // Good (3)
          // الفترة تزيد عادي
          newInterval = (card.interval * card.ease).round();
      }
    }

    // ────────────────────────────
    // حساب معامل السهولة الجديد (Ease Factor)
    // ────────────────────────────
    // المعادلة الأصلية من SM-2:
    // ease_new = ease_old + (0.1 - (5-q) × (0.08 + (5-q) × 0.02))
    final double newEase = (
      card.ease + (0.1 - (5 - quality) * (0.08 + (5 - quality) * 0.02))
    ).clamp(_minEase, 2.5);

    // بنحط حد أقصى للفترة
    newInterval = newInterval.clamp(1, _maxInterval);

    return card.copyWith(
      repetition: card.repetition + 1, // زود عداد المراجعات
      ease: double.parse(newEase.toStringAsFixed(2)),
      interval: newInterval,
      dueDate: _daysFromNow(newInterval),
    );
  }

  // ══════════════════════════════════════════════════
  //   4. معالجة الكروت في إعادة التعلم (RELEARNING)
  // ══════════════════════════════════════════════════
  /// الكارت كان في المراجعة بس اتنسي - بنعيد تعليمه
  static BaseCardEntity _handleRelearning(BaseCardEntity card, int quality) {
    
    // ────────────────────────────
    // Again: ابقى في إعادة التعلم
    // ────────────────────────────
    if (quality == 0) {
      return card.copyWith(
        currentStep: 0,
        dueDate: _minutesFromNow(_relearnSteps[0]),
      );
    }

    // ────────────────────────────
    // Hard: كرر الخطوة الحالية
    // ────────────────────────────
    if (quality == 1) {
      return card.copyWith(
        dueDate: _minutesFromNow(
          _relearnSteps[card.currentStep.clamp(0, _relearnSteps.length - 1)]
        ),
      );
    }

    // ────────────────────────────
    // Good أو Easy: ارجع للمراجعة
    // ────────────────────────────
    final interval = quality == 4 ? _easyInterval : _graduatingInterval;
    return card.copyWith(
      state: CardState.review,         // رجع للمراجعة
      repetition: 1,                   // ابدأ من أول مراجعة
      interval: interval,
      currentStep: 0,
      dueDate: _daysFromNow(interval),
    );
  }

  // ══════════════════════════════════════════════════
  //   Helper Methods - حساب التواريخ
  // ══════════════════════════════════════════════════
  
  /// حساب الوقت بعد عدد معين من الدقائق
  static DateTime _minutesFromNow(int minutes) =>
      DateTime.now().add(Duration(minutes: minutes));

  /// حساب الوقت بعد عدد معين من الأيام
  static DateTime _daysFromNow(int days) =>
      DateTime.now().add(Duration(days: days));
}
*/