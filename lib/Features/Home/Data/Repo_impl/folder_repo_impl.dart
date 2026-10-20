import 'package:dartz/dartz.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:smart_cards/Features/Home/Domain/Entities/folder_entity.dart';
import 'package:smart_cards/Features/Home/Domain/Repos/folder_repo/folder_repo.dart';
import 'package:smart_cards/core/errors/failure.dart';
import 'package:smart_cards/core/services/app_services/folder_service.dart';

class FolderRepoImpl extends FolderRepo {
  final FolderService folderService;
  FolderRepoImpl({required this.folderService});

  @override
  Future<Either<Failure, FolderEntity>> addFolder({
    required String folderName,
  }) async {
    try {
      var result = await folderService.createNewFolder(
        folderName: folderName,
      );
      return right(result);
    } catch (e) {
      if (e is FirebaseException) {
        return left(ServerFailure.fromFirebaseError(e));
      } else {
        return left(ServerFailure(errorMessage: e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, List<FolderEntity>>> getFolders() async {
    try {
      var result = await folderService.fetchUserFolders();
      return right(result);
    } catch (e) {
      if (e is FirebaseException) {
        return left(ServerFailure.fromFirebaseError(e));
      } else {
        return left(ServerFailure(errorMessage: e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, String>> deleteFolder({
    required String folderId,
  }) async {
    try {
      var result = await FolderService.deleteFolder(
        folderId: folderId,
      );
      return right(result);
    } catch (e) {
      if (e is FirebaseException) {
        return left(ServerFailure.fromFirebaseError(e));
      } else {
        return left(ServerFailure(errorMessage: e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, Map<String, String>>> renameFolder({
    required String folderId,
    required String newName,
  }) async {
    try {
      var result = await FolderService.renameFolder(
        folderId: folderId,
        newFolderName: newName,
      );
      return right(result);
    } catch (e) {
      if (e is FirebaseException) {
        return left(ServerFailure.fromFirebaseError(e));
      } else {
        return left(ServerFailure(errorMessage: e.toString()));
      }
    }
  }
}
