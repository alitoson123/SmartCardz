import 'package:smart_cards/core/Domain/Entities/base_card_entity.dart';

class CardWithAIEntity extends BaseCardEntity {
  @override
  final String word;
  @override
  final String type;
  @override
  final String definition;
  @override
  final String image_url;
  @override
  final List<String> example;
  @override
  final bool is_valid;

  CardWithAIEntity({
    required this.word,
    required this.type,
    required this.definition,
    required this.example,
    required this.image_url,
    required this.is_valid,
  });

  // Override card type identification
  @override
  String get cardType => 'ai';
}
