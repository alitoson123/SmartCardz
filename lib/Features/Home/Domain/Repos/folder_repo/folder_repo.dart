import 'package:dartz/dartz.dart';
import 'package:smart_cards/Features/Home/Domain/Entities/folder_entity.dart';
import 'package:smart_cards/core/errors/failure.dart';

abstract class FolderRepo {
  Future<Either<Failure, FolderEntity>> addFolder({
    required String folderName,
  });
  Future<Either<Failure, List<FolderEntity>>> getFolders();
  Future<Either<Failure, String>> deleteFolder({
    required String folderId,
  });
  Future<Either<Failure, Map<String, String>>> renameFolder({
    required String folderId,
    required String newName,
  });
}
