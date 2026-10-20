import 'package:smart_cards/Features/Home/Domain/Entities/folder_entity.dart';

abstract class GetFoldersStates {}

class GetFoldersInitial extends GetFoldersStates {}

class GetFoldersLoading extends GetFoldersStates {}

class GetFoldersSuccess extends GetFoldersStates {
  final List<FolderEntity> folders;

  GetFoldersSuccess({required this.folders});
}

class GetFoldersFailure extends GetFoldersStates {
  final String errMessage;

  GetFoldersFailure({required this.errMessage});
}
