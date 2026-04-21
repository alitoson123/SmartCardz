import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smart_cards/Features/Add_and_show_card_with_AI/Domain/Entities/card_with_AI_entity.dart';
import 'package:smart_cards/core/Domain/Entities/base_card_entity.dart';

class AICardModel extends AICardEntity {
  const AICardModel({
    required super.id,
    required super.collectionId,
    required super.word,
    required super.type,
    required super.definition,
    required super.example,
    super.image_url,
    super.aiImagePath,
    super.is_valid,
    super.state,
    super.ease,
    super.interval,
    super.repetition,
    super.currentStep,
    super.lapses,
    required super.dueDate,
  });

  // from json
  factory AICardModel.fromJson(Map<String, dynamic> json, {String id = ''}) {
    return AICardModel(
      id: id,
      image_url: _convertDriveUrl(json['URL'] ?? '') ?? '',
      aiImagePath: json['ai_image_path'] ?? '',
      definition: json['description'] ?? '',
      word: json['word'] ?? '',
      type: (json['type'] ?? '') as String,
      example: _parseExamples(json['examples']),
      is_valid: json['is_valid'] ?? false,
      collectionId: json['collectionId'] ?? '',
      state: CardState.newCard, // always new card when coming from ai
      ease: 2.5,
      interval: 0,
      repetition: 0,
      currentStep: 0,
      lapses: 0,
      dueDate: DateTime.now(),
    );
  }

  // from firestore
  factory AICardModel.fromFirestore(DocumentSnapshot doc) {
    final m = doc.data() as Map<String, dynamic>;
    return AICardModel(
      id: doc.id,
      word: m['word'] ?? '',
      type: m['type'] ?? '',
      definition: m['definition'] ?? '',
      example: (m['example'] as List?)?.map((e) => e.toString()).toList() ?? [], // convert list of dynamic to list of strings
      image_url: m['image_url'] ?? '',
      aiImagePath: m['ai_image_path'] ?? '',
      collectionId: m['collectionId'] ?? '',
      is_valid: m['is_valid'] ?? false,
      state: _stateFromString(m['state'] ?? 'newCard'),
      ease: (m['ease'] ?? 2.5).toDouble(),
      interval: m['interval'] ?? 0,
      repetition: m['repetition'] ?? 0,
      currentStep: m['current_step'] ?? 0,
      lapses: m['lapses'] ?? 0,
      dueDate: (m['due_date'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() => {
    'word': word,
    'type': type,
    'definition': definition,
    'example': example,
    'image_url': image_url,
    'is_valid': is_valid,
    'collectionId': collectionId,
    'is_ai_card': true, // ✅ للتمييز
    'state': state.name, // 'newCard', 'learning', etc.
    'ease': ease,
    'interval': interval,
    'repetition': repetition,
    'current_step': currentStep,
    'lapses': lapses,
    'due_date': Timestamp.fromDate(dueDate),
    'last_reviewed': FieldValue.serverTimestamp(),
  };

  factory AICardModel.fromEntity(AICardEntity entity) {
    return AICardModel(
      id: entity.id,
      word: entity.word,
      type: entity.type,
      definition: entity.definition,
      example: entity.example,
      image_url: entity.image_url,
      is_valid: entity.is_valid,
      collectionId: entity.collectionId,
      state: entity.state,
      ease: entity.ease,
      interval: entity.interval,
      repetition: entity.repetition,
      currentStep: entity.currentStep,
      lapses: entity.lapses,
      dueDate: entity.dueDate,
    );
  }

  // helper methods

  // convert string to card state
  static CardState _stateFromString(String s) {
    return CardState.values.firstWhere(
      (e) => e.name == s,
      orElse: () => CardState.newCard,
    ); // "دور في كل قيم CardState على واحدة اسمها زي الـ string، ولو ملقيتش رجّع newCard"
  }

  // parse examples
  static List<String> _parseExamples(String? input) {
    if (input == null || input.isEmpty) return [];

    return input.split(';').map((e) => e.trim()).toList();
  }

  // convert drive url to view url
  static String? _convertDriveUrl(String? url) {
    if (url == null || url.isEmpty) return url;
    if (!url.contains('drive.google.com'))
      return url; // لو مش لينك Drive → سيبه زي ما هو

    try {
      // استخراج الـ ID باستخدام Regex
      final idRegExp = RegExp(r'(?:/d/|id=)([\w-]+)');
      final match = idRegExp.firstMatch(url);

      if (match != null && match.groupCount >= 1) {
        final id = match.group(1);
        if (id != null && id.isNotEmpty) {
          return 'https://drive.google.com/uc?export=view&id=$id';
        } // يبني الرابط الجديد بستخدام الـ ID
      }
    } catch (e) {
      // If parsing fails, return original
      return url;
    }
    return url;
  }
}
