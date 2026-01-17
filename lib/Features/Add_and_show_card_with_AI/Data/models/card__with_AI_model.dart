import 'dart:convert';
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
  final String type;
  @HiveField(7)
  @override
  final String definition;
  @HiveField(8)
  @override
  final List<String> example;
  @HiveField(9)
  @override
  final String image_url;
  @HiveField(11)
  @override
  final String is_valid;

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
    required this.is_valid,
  }) : super(
         word: word,
         type: type,
         definition: definition,
         example: example,
         image_url: image_url,
         is_valid: is_valid,
       );

  /// From a simple JSON (e.g., from AI/mock). Sets sane SM-2 defaults.
  factory CardWithAIModel.fromJson(
    Map<String, dynamic> json, {
    String id = '',
  }) {
    return CardWithAIModel(
      id: id,
      word: json['word'] ?? '',
      type: (json['type'] ?? '') as String,
      definition: json['description'] ?? '',
      example: _parseExamples(json['examples']),
      image_url: _convertDriveUrl(json['URL'] ?? '') ?? '',
      repetition: (json['repetition'] ?? 0) as int,
      easiness: (json['easiness'] ?? 2.5).toDouble(),
      interval: (json['interval'] ?? 0) as int,
      nextReview: json['next_review'] is Timestamp
          ? json['next_review'] as Timestamp
          : (json['next_review'] != null
                ? Timestamp.fromDate(DateTime.parse(json['next_review']))
                : null),
      collectionId: json['collectionId'] ?? '',
      is_valid: json['is_valid'] ?? '',
    );
  }

  static List<String> _parseExamples(dynamic input) {
    if (input == null) return [];
    if (input is List) {
      return input.map((e) => e.toString()).toList();
    }
    if (input is String) {
      // Trying to handle the case where it might be a double-encoded JSON string
      try {
        final decoded = jsonDecode(input);
        if (decoded is List) {
          return decoded.map((e) => e.toString()).toList();
        }
        // ignore: empty_catches
      } catch (_) {}
      // Fallback to split if it's not a JSON array string
      if (input.isNotEmpty) {
        return input.split(',').map((e) => e.trim()).toList();
      }
    }
    return [];
  }

  /// From Firestore DocumentSnapshot
  factory CardWithAIModel.fromDoc(DocumentSnapshot doc) {
    final m = doc.data() as Map<String, dynamic>;
    return CardWithAIModel(
      id: doc.id,
      word: m['word'] ?? '',
      type: m['type'] ?? '[]',
      definition: m['definition'] ?? '',
      example: (m['example'] as List?)?.map((e) => e.toString()).toList() ?? [],
      image_url: m['image_url'] ?? '',
      repetition: (m['repetition'] ?? 0) as int,
      easiness: (m['easiness'] ?? 2.5).toDouble(),
      interval: (m['interval'] ?? 0) as int,
      nextReview: m['next_review'] as Timestamp?,
      collectionId: m['collectionId'] ?? '',
      is_valid: m['is_valid'] ?? '',
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
    String? type,
    String? definition,
    List<String>? example,
    String? image_url,
    String? is_valid,
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
      image_url: image_url ?? this.image_url,
      is_valid: is_valid ?? this.is_valid,
    );
  }

  static String? _convertDriveUrl(String? url) {
    if (url == null || url.isEmpty) return url;
    if (!url.contains('drive.google.com')) return url;

    try {
      // Regex to extract ID from: https://drive.google.com/file/d/[ID]/view...
      // or https://drive.google.com/open?id=[ID]...
      final idRegExp = RegExp(r'(?:/d/|id=)([\w-]+)');
      final match = idRegExp.firstMatch(url);

      if (match != null && match.groupCount >= 1) {
        final id = match.group(1);
        if (id != null && id.isNotEmpty) {
          return 'https://drive.google.com/uc?export=view&id=$id';
        }
      }
    } catch (e) {
      // If parsing fails, return original
      return url;
    }
    return url;
  }
}
