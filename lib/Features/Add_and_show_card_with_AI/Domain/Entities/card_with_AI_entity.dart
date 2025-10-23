import 'package:smart_cards/core/Entities/base_card_entity.dart';

class CardWithAIEntity extends BaseCardEntity {
  final String word;
  final String type;
  final String definition;
  final String imageBase64;
  final String example;

  CardWithAIEntity({
    required this.word,
    required this.type,
    required this.definition,
    required this.example,
    required this.imageBase64,
  });

  // 👇 هنا نربط الواجهات بمعنى الكارت
  @override
  String get frontSide => word;

  @override
  String get backSide => '$definition\n\nExample: $example';
}
