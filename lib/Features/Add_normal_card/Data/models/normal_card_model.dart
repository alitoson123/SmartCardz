import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smart_cards/Features/Add_normal_card/Domain/Entities/normal_card_entity.dart';

class NormalCardModel extends NormalCardEntity {
  final String id;

  // SM-2 fields
  final int repetition; // number of consecutive successful reviews
  final double easiness; // easiness factor
  final int interval; // days until next review
  final Timestamp? nextReview; // Firestore timestamp for next review
  NormalCardModel({
    required this.id,
    required this.repetition,
    required this.easiness,
    required this.interval,
    required this.nextReview,
    required super.frontSide,
    required super.backSide,
  });


  /// From Firestore DocumentSnapshot
  factory NormalCardModel.fromDoc(DocumentSnapshot doc) {
    final m = doc.data() as Map<String, dynamic>;
    return NormalCardModel(
      id: doc.id,
      frontSide: m['front_side'] ?? '',
      backSide: m['back_side'] ?? '',
      repetition: (m['repetition'] ?? 0) as int,
      easiness: (m['easiness'] ?? 2.5).toDouble(),
      interval: (m['interval'] ?? 0) as int,
      nextReview: m['next_review'] as Timestamp?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'front_side': frontSide,
      'back_side': backSide,
      'repetition': repetition,
      'easiness': easiness,
      'interval': interval,
      'next_review': nextReview,
    };
  }

  Map<String, dynamic> toJson() => toMap();

  NormalCardModel copyWith({
    String? id,
    String? frontSide,
    String? backSide,
    int? repetition,
    double? easiness,
    int? interval,
    Timestamp? nextReview,
  }) {
    return NormalCardModel(
      id: id ?? this.id,
      frontSide: frontSide ?? this.frontSide,
      backSide: backSide ?? this.backSide,
      repetition: repetition ?? this.repetition,
      easiness: easiness ?? this.easiness,
      interval: interval ?? this.interval,
      nextReview: nextReview ?? this.nextReview,
    );
  }
}


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
  /* factory NormalCardModel.fromJson(Map<String, dynamic> json, {String id = ''}) {
    return NormalCardModel(
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
*/