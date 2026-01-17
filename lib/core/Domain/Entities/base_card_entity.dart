import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive_flutter/adapters.dart';

abstract class BaseCardEntity extends HiveObject {
  /// 🆔 Unique identifier for the card document in Firestore
  String get id => '';

  /// 🪄 Core properties that all cards must have
  String get frontSide => '';
  String get backSide => '';
  String get frontImageUrl => '';
  String get backImageUrl => '';

  /// 📦 Metadata
  String get collectionId => '';
  Timestamp? get nextReview => null;

  /// 🤖 AI-specific properties (used only for AI cards)
  String get word => '';
  String get type => '';
  String get definition => '';
  String get image_url => '';
  List<String> get example => [];
  String get is_valid => '';

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
