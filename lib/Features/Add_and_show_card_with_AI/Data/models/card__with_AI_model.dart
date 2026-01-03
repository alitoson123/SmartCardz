import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smart_cards/Features/Add_and_show_card_with_AI/Domain/Entities/card_with_AI_entity.dart';
import 'package:hive/hive.dart';
part 'card__with_AI_model.g.dart';

@HiveType(typeId: 2)
class CardWithAIModel extends CardWithAIEntity {
  @HiveField(0)
  @override
  final String id;

  // SM-2 fields
  @HiveField(1)
  @override
  final int repetition; // number of consecutive successful reviews
  @HiveField(2)
  @override
  final double easiness; // easiness factor
  @HiveField(3)
  @override
  final int interval; // days until next review
  @HiveField(4)
  @override
  final Timestamp? nextReview; // Firestore timestamp for next review
  @HiveField(10)
  @override
  final String collectionId;
  @HiveField(5)
  @override
  final String word;
  @HiveField(6)
  @override
  final List<dynamic> type;
  @HiveField(7)
  @override
  final String definition;
  @HiveField(8)
  @override
  final List<dynamic> example;
  @HiveField(9)
  @override
  final String image_url;

  CardWithAIModel({
    required this.id,
    required this.word,
    required this.type,
    required this.definition,
    required this.example,
    required this.image_url,
    required this.repetition,
    required this.easiness,
    required this.interval,
    required this.nextReview,
    required this.collectionId,
  }) : super(
         word: word,
         type: type,
         definition: definition,
         example: example,
         image_url: image_url,
       );
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
      type:  (json['type/s'] ?? [] )as List<dynamic>,
      definition: json['description'] ?? '' ,
      example: (json['examples'] ?? []) as List<dynamic>,
      image_url: json['image_url'] ?? '',
      repetition: (json['repetition'] ?? 0) as int,
      easiness: (json['easiness'] ?? 2.5).toDouble(),
      interval: (json['interval'] ?? 0) as int,
      nextReview: json['next_review'] is Timestamp
          ? json['next_review'] as Timestamp
          : (json['next_review'] != null
                ? Timestamp.fromDate(DateTime.parse(json['next_review']))
                : null),
      collectionId: json['collectionId'] ?? '',
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
      image_url: m['image_url'] ?? m['image_url'] ?? '',
      repetition: (m['repetition'] ?? 0) as int,
      easiness: (m['easiness'] ?? 2.5).toDouble(),
      interval: (m['interval'] ?? 0) as int,
      nextReview: m['next_review'] as Timestamp?,
      collectionId: m['collectionId'] ?? '',
    );
  }

  Map<String, dynamic> toMap() => {
    'word': word,
    'type': type,
    'definition': definition,
    'example': example,
    'image_url': image_url,
    'repetition': repetition,
    'easiness': easiness,
    'interval': interval,
    'next_review': nextReview,
    'collectionId': collectionId,
  };

  CardWithAIModel copyWith({
    String? id,
    int? repetition,
    double? easiness,
    int? interval,
    Timestamp? nextReview,
    String? collectionId,
    String? word,
    List<dynamic>? type,
    String? definition,
    List<dynamic>? example,
    String? imageBase64,
  }) {
    return CardWithAIModel(
      id: id ?? this.id,
      repetition: repetition ?? this.repetition,
      easiness: easiness ?? this.easiness,
      interval: interval ?? this.interval,
      nextReview: nextReview ?? this.nextReview,
      collectionId: collectionId ?? this.collectionId,
      word: word ?? this.word,
      type: type ?? this.type,
      definition: definition ?? this.definition,
      example: example ?? this.example,
      image_url: imageBase64 ?? this.image_url,
    );
  }
}
