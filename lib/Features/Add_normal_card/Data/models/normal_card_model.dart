import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smart_cards/Features/Add_normal_card/Domain/Entities/normal_card_entity.dart';
import 'package:hive/hive.dart';
part 'normal_card_model.g.dart';

@HiveType(typeId: 3)
class NormalCardModel extends NormalCardEntity {
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
  @HiveField(9)
  @override
  final String collectionId;
  @HiveField(5)
  @override
  final String frontSide;
  @HiveField(6)
  @override
  final String backSide;
  @HiveField(7)
  @override
  final String frontImageUrl;
  @HiveField(8)
  @override
  final String backImageUrl;

  NormalCardModel({
    required this.id,
    required this.repetition,
    required this.easiness,
    required this.interval,
    required this.nextReview,
    required this.frontSide,
    required this.backSide,
    required this.frontImageUrl,
    required this.backImageUrl,
    required this.collectionId,
  }) : super(
         frontSide: frontSide,
         backSide: backSide,
         frontImageUrl: frontImageUrl,
         backImageUrl: backImageUrl,
       );

  /// From Firestore DocumentSnapshot
  factory NormalCardModel.fromDoc(DocumentSnapshot doc) {
    final m = doc.data() as Map<String, dynamic>;
    return NormalCardModel(
      id: doc.id,
      frontSide: m['front_side'] ?? '',
      backSide: m['back_side'] ?? '',
      frontImageUrl: m['front_image_url'] ?? '',
      backImageUrl: m['back_image_url'] ?? '',
      repetition: (m['repetition'] ?? 0) as int,
      easiness: (m['easiness'] ?? 2.5).toDouble(),
      interval: (m['interval'] ?? 0) as int,
      nextReview: m['next_review'] as Timestamp?,
      collectionId: m['collectionId'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'front_side': frontSide,
      'back_side': backSide,
      'front_image_url': frontImageUrl,
      'back_image_url': backImageUrl,
      'repetition': repetition,
      'easiness': easiness,
      'interval': interval,
      'next_review': nextReview,
      'collectionId': collectionId,
    };
  }

  Map<String, dynamic> toJson() => toMap();

  NormalCardModel copyWith({
    String? id,
    int? repetition,
    double? easiness,
    int? interval,
    Timestamp? nextReview,
    String? collectionId,
    String? frontSide,
    String? backSide,
    String? frontImageUrl,
    String? backImageUrl,
  }) {
    return NormalCardModel(
      id: id ?? this.id,
      repetition: repetition ?? this.repetition,
      easiness: easiness ?? this.easiness,
      interval: interval ?? this.interval,
      nextReview: nextReview ?? this.nextReview,
      collectionId: collectionId ?? this.collectionId,
      frontSide: frontSide ?? this.frontSide,
      backSide: backSide ?? this.backSide,
      frontImageUrl: frontImageUrl ?? this.frontImageUrl,
      backImageUrl: backImageUrl ?? this.backImageUrl,
    );
  }

  // Override BaseCardEntity properties
  @override
  String get cardType => 'normal';
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
