abstract class BaseCardEntity {
  // Core properties that all cards must have
  String get frontSide => '' ;
  String get backSide => '';

  // AI-specific properties with default implementations
  String get word => '';
  String get type => '';
  String get definition => '';
  String get imageBase64 => '';
  String get example => '';



  // SM-2 algorithm properties
  int get repetition => 0;
  double get easiness => 2.5;
  int get interval => 0;
  // Card identification
  String get cardType => 'unknown';
  // Helper methods
  bool get isAICard => cardType == 'ai';
  bool get isNormalCard => cardType == 'normal';
}
