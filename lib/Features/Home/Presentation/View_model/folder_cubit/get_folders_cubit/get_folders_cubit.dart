import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_cards/Features/Home/Data/Repo_impl/folder_repo_impl.dart';
import 'package:smart_cards/Features/Home/Presentation/View_model/folder_cubit/get_folders_cubit/get_folders_states.dart';
import 'package:smart_cards/Features/Home/Domain/Entities/folder_entity.dart';

class GetFoldersCubit extends Cubit<GetFoldersStates> {
  GetFoldersCubit({required this.folderRepoImpl}) : super(GetFoldersInitial());

  final FolderRepoImpl folderRepoImpl;

  Future<void> getFolders() async {
    emit(GetFoldersLoading());
    final result = await folderRepoImpl.getFolders();
    result.fold(
      (failure) => emit(GetFoldersFailure(errMessage: failure.errorMessage)),
      (success) => emit(GetFoldersSuccess(folders: success)),
    );
  }

  void removeFolderLocally(String folderId) {
    if (state is GetFoldersSuccess) {
      final currentState = state as GetFoldersSuccess;
      final updatedList = currentState.folders
          .where((element) => element.id != folderId)
          .toList();
      emit(GetFoldersLoading());
      emit(GetFoldersSuccess(folders: updatedList));
    }
  }

  void addFolderLocally(FolderEntity folder) {
    if (state is GetFoldersSuccess) {
      final currentState = state as GetFoldersSuccess;
      final updatedList = List<FolderEntity>.from(currentState.folders)
        ..add(folder); // Add to the bottom of the list
      emit(GetFoldersLoading());
      emit(GetFoldersSuccess(folders: updatedList));
    } else {
      getFolders(); // If not loaded yet, just fetch
    }
  }

  void renameFolderLocally(String folderId, String newName) {
    if (state is GetFoldersSuccess) {
      final currentState = state as GetFoldersSuccess;
      final updatedList = currentState.folders
          .map(
            (e) => e.id == folderId ? e.copyWith(name: newName) : e,
          )
          .toList();
      emit(GetFoldersLoading());
      emit(GetFoldersSuccess(folders: updatedList));
    }
  }
}
