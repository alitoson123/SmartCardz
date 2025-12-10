import 'package:smart_cards/core/Domain/Entities/base_card_entity.dart';

class NormalCardEntity extends BaseCardEntity {
  @override
  final String frontSide;
  @override
  final String backSide;
  @override
  final String frontImageUrl;
  @override
  final String backImageUrl;
  
  NormalCardEntity({required this.frontSide, required this.backSide, required this.frontImageUrl, required this.backImageUrl});
  
  // Override card type identification
  @override
  String get cardType => 'normal';
  

}
