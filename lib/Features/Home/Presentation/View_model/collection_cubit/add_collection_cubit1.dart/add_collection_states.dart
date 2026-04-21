import 'package:smart_cards/Features/Home/Domain/Entities/collection_entity.dart';

class AddCollectionStates {}

class AddCollectionLoading extends AddCollectionStates {}

class AddCollectionSuccess extends AddCollectionStates {
  final CollectionEntity collectionEntity;

  AddCollectionSuccess({required this.collectionEntity});
}

class AddCollectionFailure extends AddCollectionStates {
  final String errMessage;

  AddCollectionFailure({required this.errMessage});
}
