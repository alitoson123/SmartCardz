class DeleteCollectionStates {}

class DeleteCollectionInitial extends DeleteCollectionStates {}

class DeleteCollectionLoading extends DeleteCollectionStates {}

class DeleteCollectionSuccess extends DeleteCollectionStates {
  final String collectionId;
  DeleteCollectionSuccess({required this.collectionId});
}

class DeleteCollectionFailure extends DeleteCollectionStates {
  final String errorMessage;
  DeleteCollectionFailure({required this.errorMessage});
}
