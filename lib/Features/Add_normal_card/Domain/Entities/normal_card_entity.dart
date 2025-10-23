import 'package:smart_cards/core/Entities/base_card_entity.dart';

class NormalCardEntity extends BaseCardEntity {
  final String frontSide;
  final String backSide;
  NormalCardEntity({required this.frontSide, required this.backSide});
  
  @override
  String get definition => '';
  
  @override
  String get example => '';
  
  @override

  String get imageBase64 => '';
  
  @override
  String get type => '';
  
  @override
  String get word => '';
}
