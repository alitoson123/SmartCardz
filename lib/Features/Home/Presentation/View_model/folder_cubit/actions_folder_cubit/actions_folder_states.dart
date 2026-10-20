import 'package:smart_cards/Features/Home/Domain/Entities/folder_entity.dart';

class ActionsFolderStates {}

class ActionsFolderInitial extends ActionsFolderStates {}

class ActionsFolderLoading extends ActionsFolderStates {}

class AddFolderSuccess extends ActionsFolderStates {
  final FolderEntity folderEntity;

  AddFolderSuccess({required this.folderEntity});
}

class DeleteFolderSuccess extends ActionsFolderStates {
  final String folderId;
  DeleteFolderSuccess({required this.folderId});
}

class RenameFolderSuccess extends ActionsFolderStates {
  final String folderName;
  final String folderId;

  RenameFolderSuccess({
    required this.folderName,
    required this.folderId,
  });
}

class ActionsFolderFailure extends ActionsFolderStates {
  final String errMessage;
  ActionsFolderFailure({required this.errMessage});
}
