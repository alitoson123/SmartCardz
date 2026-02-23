import 'package:cloud_firestore/cloud_firestore.dart';

class Sm2Result {
  final int repetition;
  final double easiness;
  final int intervalDays;
  final Timestamp nextReview;

  Sm2Result({
    required this.repetition,
    required this.easiness,
    required this.intervalDays,
    required this.nextReview,
  });
}

Sm2Result computeSm2({
  required int currentRepetition,
  required double currentEasiness,
  required int currentInterval,
  required int quality,
}) {
  double e = currentEasiness;
  int r = currentRepetition;
  int interval = currentInterval;

  if (quality < 3) {
    // لو الجودة أقل من 3 (يعني غلط):
    r = 0;
    interval = 1;
  } else {
    r = r + 1;
    if (r == 1) {
      interval = 1;
    } else if (r == 2) {
      interval = 6;
    } else {
      interval = (interval * e).round();
      if (interval < 1) interval = 1;
    }
  }

  // Update easiness factor
  e = e + (0.1 - (5 - quality) * (0.08 + (5 - quality) * 0.02));
  if (e < 1.3) e = 1.3;

  final next = DateTime.now().add(Duration(days: interval));
  final nextTs = Timestamp.fromDate(next);

  return Sm2Result(
    repetition: r,
    easiness: double.parse(e.toStringAsFixed(2)),
    intervalDays: interval,
    nextReview: nextTs,
  );
}
