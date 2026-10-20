import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smart_cards/Features/Home/Data/Models/folder_model.dart';
import 'package:smart_cards/Features/Home/Domain/Entities/folder_entity.dart';

class FolderService {
  static final firestore = FirebaseFirestore.instance;

  // create folder
  Future<FolderEntity> createNewFolder({
    required String folderName,
  }) async {
    final ref = firestore.collection('folders').doc();
    await ref.set({
      'id': ref.id,
      'owner_id': FirebaseAuth.instance.currentUser!.uid,
      'name': folderName,
      'created_at': FieldValue.serverTimestamp(),
    });

    final snapshot = await ref.get();
    final model = FolderModel.fromDoc(snapshot);

    return model;
  }

  // fetch user folders
  Future<List<FolderEntity>> fetchUserFolders() async {
    final snap = await firestore
        .collection('folders')
        .where('owner_id', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .orderBy('created_at')
        .get();

    final folders = snap.docs.map((e) => FolderModel.fromDoc(e)).toList();

    return folders;
  }

  // delete folder
  static Future<String> deleteFolder({required String folderId}) async {
    // Delete the folder itself
    await firestore.collection('folders').doc(folderId).delete();
    
    // Note: We might want to remove the folder_id from all collections that were in this folder
    final collectionsSnap = await firestore
        .collection('collections')
        .where('folder_id', isEqualTo: folderId)
        .get();
        
    for (var doc in collectionsSnap.docs) {
      await doc.reference.update({'folder_id': null});
    }

    return folderId;
  }

  // rename folder
  static Future<Map<String, String>> renameFolder({
    required String folderId,
    required String newFolderName,
  }) async {
    await firestore.collection('folders').doc(folderId).update({
      'name': newFolderName,
    });

    return {
      'folder_id': folderId,
      'name': newFolderName,
    };
  }
}
