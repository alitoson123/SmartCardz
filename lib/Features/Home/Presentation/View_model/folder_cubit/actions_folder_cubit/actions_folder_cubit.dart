import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_cards/Features/Home/Domain/Repos/folder_repo/folder_repo.dart';
import 'package:smart_cards/Features/Home/Presentation/View_model/folder_cubit/actions_folder_cubit/actions_folder_states.dart';

class ActionsFolderCubit extends Cubit<ActionsFolderStates> {
  ActionsFolderCubit({required this.folderRepo}) : super(ActionsFolderInitial());

  final FolderRepo folderRepo;

  // add folder
  Future<void> addFolderMethod({required String folderName}) async {
    emit(ActionsFolderLoading());
    final result = await folderRepo.addFolder(
      folderName: folderName,
    );

    result.fold(
      (failure) => emit(ActionsFolderFailure(errMessage: failure.errorMessage)),
      (success) => emit(AddFolderSuccess(folderEntity: success)),
    );
  }

  // delete folder
  Future<void> deleteFolder({required String folderId}) async {
    emit(ActionsFolderLoading());
    final result = await folderRepo.deleteFolder(
      folderId: folderId,
    );
    result.fold(
      (failure) => emit(ActionsFolderFailure(errMessage: failure.errorMessage)),
      (success) => emit(DeleteFolderSuccess(folderId: success)),
    );
  }

  // rename folder
  Future<void> renameFolder({
    required String folderId,
    required String newName,
  }) async {
    emit(ActionsFolderLoading());
    final result = await folderRepo.renameFolder(
      folderId: folderId,
      newName: newName,
    );
    result.fold(
      (failure) => emit(ActionsFolderFailure(errMessage: failure.errorMessage)),
      (success) => emit(
        RenameFolderSuccess(
          folderName: success['name']!,
          folderId: success['folder_id']!,
        ),
      ),
    );
  }
}
