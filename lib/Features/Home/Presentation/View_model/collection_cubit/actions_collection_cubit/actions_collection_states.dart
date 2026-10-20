import 'package:smart_cards/Features/Home/Domain/Entities/collection_entity.dart';

class ActionsCollectionStates {}

class ActionsCollectionInitial extends ActionsCollectionStates {}

class ActionsCollectionLoading extends ActionsCollectionStates {}

class AddCollectionSuccess extends ActionsCollectionStates {
  final CollectionEntity collectionEntity;

  AddCollectionSuccess({required this.collectionEntity});
}

class DeleteCollectionSuccess extends ActionsCollectionStates {
  final String collectionId;
  DeleteCollectionSuccess({required this.collectionId});
}

class RenameCollectionSuccess extends ActionsCollectionStates {
  final String collectionName;
  final String collectionId;

  RenameCollectionSuccess({
    required this.collectionName,
    required this.collectionId,
  });
}

class MoveCollectionSuccess extends ActionsCollectionStates {
  final String collectionId;
  final String? folderId;

  MoveCollectionSuccess({
    required this.collectionId,
    this.folderId,
  });
}

class ActionsCollectionFailure extends ActionsCollectionStates {
  final String errMessage;
  ActionsCollectionFailure({required this.errMessage});
}
