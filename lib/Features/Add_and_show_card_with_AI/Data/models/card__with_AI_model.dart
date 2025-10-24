import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smart_cards/Features/Add_and_show_card_with_AI/Domain/Entities/card_with_AI_entity.dart';

class CardWithAIModel extends CardWithAIEntity {
  final String id;

  // SM-2 fields
  @override
  final int repetition; // number of consecutive successful reviews
  @override
  final double easiness; // easiness factor
  @override
  final int interval; // days until next review
  final Timestamp? nextReview; // Firestore timestamp for next review

  CardWithAIModel({
    required this.id,
    required super.word,
    required super.type,
    required super.definition,
    required super.example,
    required super.imageBase64,
    required this.repetition,
    required this.easiness,
    required this.interval,
    required this.nextReview,
  });
  /*factory CardModel.fromJson(List<dynamic> json, {String id = ''}) {
    return CardModel(
      id: id,
      word: json[0]['word'] ?? '',
      type: json[0]["meanings"][0]["partOfSpeech"] ?? '',
      definition: json[0]["meanings"][0]["definitions"][0]["definition"] ?? '',
      example: json[0]["meanings"][0]["definitions"][0]["example"] ?? '',
      imageUrl: json[0]['word']  ?? '',
      repetition: (1 ?? 0) as int,
      easiness: (5.5 ?? 2.5).toDouble(),
      interval: (1 ?? 0) as int,
      nextReview: Timestamp.now() is Timestamp
          ? Timestamp.now() as Timestamp
          : (Timestamp.now() != null
              ? Timestamp.fromDate(DateTime.parse(Timestamp.now().toString()))
              : null),
    );
  }
*/

  /// From a simple JSON (e.g., from AI/mock). Sets sane SM-2 defaults.
  factory CardWithAIModel.fromJson(
    Map<String, dynamic> json, {
    String id = '',
  }) {
    return CardWithAIModel(
      id: id,
      word: json['word'] ?? '',
      type: json['type'] ?? '',
      definition: json['definition'] ?? '',
      example: json['example'] ?? '',
      imageBase64: json['image_base64'] ?? '',
      repetition: (json['repetition'] ?? 0) as int,
      easiness: (json['easiness'] ?? 2.5).toDouble(),
      interval: (json['interval'] ?? 0) as int,
      nextReview: json['next_review'] is Timestamp
          ? json['next_review'] as Timestamp
          : (json['next_review'] != null
                ? Timestamp.fromDate(DateTime.parse(json['next_review']))
                : null),
    );
  }

  /// From Firestore DocumentSnapshot
  factory CardWithAIModel.fromDoc(DocumentSnapshot doc) {
    final m = doc.data() as Map<String, dynamic>;
    return CardWithAIModel(
      id: doc.id,
      word: m['word'] ?? '',
      type: m['type'] ?? '',
      definition: m['definition'] ?? '',
      example: m['example'] ?? '',
      imageBase64: m['image_base64'] ?? '',
      repetition: (m['repetition'] ?? 0) as int,
      easiness: (m['easiness'] ?? 2.5).toDouble(),
      interval: (m['interval'] ?? 0) as int,
      nextReview: m['next_review'] as Timestamp?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'word': word,
      'type': type,
      'definition': definition,
      'example': example,
      'image_base64': imageBase64,
      'repetition': repetition,
      'easiness': easiness,
      'interval': interval,
      'next_review': nextReview,
    };
  }
}
