class QuotaEntity {
  final int freeTextUsedToday;
  final int freeImageCardsUsed;
  final DateTime lastFreeTextReset;
  final int premiumTextCardsUsed;
  final int premiumImageCardsUsed;
  final DateTime? premiumPeriodEnd;

  QuotaEntity({
    required this.freeTextUsedToday,
    required this.lastFreeTextReset,
    required this.freeImageCardsUsed,
    required this.premiumImageCardsUsed,
    required this.premiumTextCardsUsed,
    this.premiumPeriodEnd,
  });

  // Limits
  static const int dailyFreeTextLimit = 10;
  static const int lifetimeFreeImageLimit = 3;
  static const int premiumTextLimit = 500;
  static const int premiumImageLimit = 120;

  int get remainingFreeText => dailyFreeTextLimit - freeTextUsedToday;
  int get remainingFreeImage => lifetimeFreeImageLimit - freeImageCardsUsed;
}
