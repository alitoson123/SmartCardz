import 'package:smart_cards/core/Entities/base_card_entity.dart';

class NormalCardEntity extends BaseCardEntity {
  @override
  final String frontSide;
  @override
  final String backSide;
  
  NormalCardEntity({required this.frontSide, required this.backSide});
  
  // Override card type identification
  @override
  String get cardType => 'normal';
  

}
