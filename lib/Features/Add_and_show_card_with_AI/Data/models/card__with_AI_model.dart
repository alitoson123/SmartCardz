import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smart_cards/Features/Add_and_show_card_with_AI/Domain/Entities/card_with_AI_entity.dart';
import 'package:hive/hive.dart';
import 'package:smart_cards/core/Domain/Entities/base_card_entity.dart';
//part 'card__with_AI_model.g.dart';

@HiveType(typeId: 2)
class AICardModel extends AICardEntity {
  const AICardModel({
    required super.id,
    required super.collectionId,
    required super.word,
    required super.type,
    required super.definition,
    required super.example,
    super.image_url,
    super.is_valid,
    super.state,
    super.ease,
    super.interval,
    super.repetition,
    super.currentStep,
    super.lapses,
    required super.dueDate,
  });

  /// From a simple JSON (e.g., from AI/mock). Sets sane SM-2 defaults.
  factory AICardModel.fromJson(Map<String, dynamic> json, {String id = ''}) {
    return AICardModel(
      id: id,
      image_url: _convertDriveUrl(json['URL'] ?? '') ?? '',
      definition: json['description'] ?? '',
      word: json['word'] ?? '',
      type: (json['type'] ?? '') as String,
      example: _parseExamples(json['examples']),
      is_valid: json['is_valid'] ?? false,
      collectionId: json['collectionId'] ?? '',
      state: _stateFromString(json['state'] ?? 'newCard'),
      ease: (json['ease'] ?? 2.5).toDouble(),
      interval: json['interval'] ?? 0,
      repetition: json['repetition'] ?? 0,
      currentStep: json['current_step'] ?? 0,
      lapses: json['lapses'] ?? 0,
      dueDate: (json['due_date'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  /// From Firestore DocumentSnapshot
  factory AICardModel.fromFirestore(DocumentSnapshot doc) {
    final m = doc.data() as Map<String, dynamic>;
    return AICardModel(
      id: doc.id,
      word: m['word'] ?? '',
      type: m['type'] ?? '[]',
      definition: m['definition'] ?? '',
      example: (m['example'] as List?)?.map((e) => e.toString()).toList() ?? [],
      image_url: m['image_url'] ?? '',
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

  // ══════════════════════════════
  //   Helper
  // ══════════════════════════════
  static CardState _stateFromString(String s) {
    return CardState.values.firstWhere(
      (e) => e.name == s,
      orElse: () => CardState.newCard,
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
        return input.split(';').map((e) => e.trim()).toList();
      }
    }
    return [];
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
