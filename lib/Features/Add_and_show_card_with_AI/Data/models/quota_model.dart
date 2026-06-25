import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smart_cards/Features/Add_and_show_card_with_AI/Domain/Entities/quota_entity.dart';

class QuotaModel extends QuotaEntity {
  QuotaModel({
    required super.freeTextUsedToday,
    required super.lastFreeTextReset,
    required super.freeImageCardsUsed,
    required super.premiumImageCardsUsed,
    required super.premiumTextCardsUsed,
    super.premiumPeriodEnd,
  });

  factory QuotaModel.fromJson(Map<String, dynamic> json) {
    return QuotaModel(
      freeTextUsedToday: json['freeTextUsedToday'] as int? ?? 0,
      freeImageCardsUsed: json['freeImageCardsUsed'] as int? ?? 0,
      lastFreeTextReset:
          (json['lastFreeTextReset'] as Timestamp?)?.toDate() ?? DateTime.now(),
      premiumTextCardsUsed: json['premiumTextCardsUsed'] as int? ?? 0,
      premiumImageCardsUsed: json['premiumImageCardsUsed'] as int? ?? 0,
      premiumPeriodEnd: (json['premiumPeriodEnd'] as Timestamp?)?.toDate(),
    );
  }

  factory QuotaModel.empty() {
    return QuotaModel(
      freeTextUsedToday: 0,
      freeImageCardsUsed: 0,
      lastFreeTextReset: DateTime.now(),
      premiumTextCardsUsed: 0,
      premiumImageCardsUsed: 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'freeTextUsedToday': freeTextUsedToday,
      'lastFreeTextReset': Timestamp.fromDate(lastFreeTextReset),
      'freeImageCardsUsed': freeImageCardsUsed,
      'premiumImageCardsUsed': premiumImageCardsUsed,
      'premiumTextCardsUsed': premiumTextCardsUsed,
      if (premiumPeriodEnd != null)
        'premiumPeriodEnd': Timestamp.fromDate(premiumPeriodEnd!),
    };
  }

  QuotaModel copyWith({
    int? freeTextUsedToday,
    DateTime? lastFreeTextReset,
    int? freeImageCardsUsed,
    int? premiumImageCardsUsed,
    int? premiumTextCardsUsed,
    DateTime? premiumPeriodEnd,
  }) {
    return QuotaModel(
      freeTextUsedToday: freeTextUsedToday ?? this.freeTextUsedToday,
      lastFreeTextReset: lastFreeTextReset ?? this.lastFreeTextReset,
      freeImageCardsUsed: freeImageCardsUsed ?? this.freeImageCardsUsed,
      premiumImageCardsUsed:
          premiumImageCardsUsed ?? this.premiumImageCardsUsed,
      premiumTextCardsUsed: premiumTextCardsUsed ?? this.premiumTextCardsUsed,
      premiumPeriodEnd: premiumPeriodEnd ?? this.premiumPeriodEnd,
    );
  }
}
