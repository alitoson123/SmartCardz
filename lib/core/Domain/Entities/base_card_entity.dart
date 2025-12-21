import 'package:hive_flutter/adapters.dart';

abstract class BaseCardEntity extends HiveObject {
  /// 🆔 Unique identifier for the card document in Firestore
  String get id => '';

  /// 🪄 Core properties that all cards must have
  String get frontSide => '';
  String get backSide => '';
  String get frontImageUrl => '';
  String get backImageUrl => '';

  /// 🤖 AI-specific properties (used only for AI cards)
  String get word => '';
  String get type => '';
  String get definition => '';
  String get imageBase64 => '';
  String get example => '';

  /// 🧠 SM-2 algorithm properties
  int get repetition => 0;
  double get easiness => 2.5;
  int get interval => 0;

  /// 📦 Card type (ai / normal)
  String get cardType => 'unknown';

  /// ⚙️ Helper getters
  bool get isAICard => cardType == 'ai';
  bool get isNormalCard => cardType == 'normal';
}
