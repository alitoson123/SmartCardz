import 'package:smart_cards/Features/Home/Domain/Entities/collection_entity.dart';

class GetCollectionsStates {}

 class GetCollectionsInitial extends GetCollectionsStates {}

class GetCollectionsLoading extends GetCollectionsStates {}

class GetCollectionsSuccess extends GetCollectionsStates {
  final List<CollectionEntity> collections;

  GetCollectionsSuccess({required this.collections});
}

class GetCollectionsFailure extends GetCollectionsStates {
  final String errMessage;

  GetCollectionsFailure({required this.errMessage});
}
