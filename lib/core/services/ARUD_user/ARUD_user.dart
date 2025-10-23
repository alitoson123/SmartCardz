import 'package:cloud_firestore/cloud_firestore.dart';

class ArudUser {
  Future<void> addUser(
      {required String documentName,
      required Map<String, dynamic> data,
      required String userUid}) async {
    var user = FirebaseFirestore.instance.collection(documentName).doc(userUid);
    user.set(
      data,
      SetOptions(merge: true),
    );
  }

  Future<Map<String, dynamic>> getUser(
      {required String documentName, required String useruid}) async {
    var user = await FirebaseFirestore.instance
        .collection(documentName)
        .doc(useruid)
        .get();

    return user.data() as Map<String, dynamic>;
  }

  Future<void> deleteUser(
      {required String documentName, required String useruid}) async {
    await FirebaseFirestore.instance
        .collection(documentName)
        .doc(useruid)
        .delete();
  }

  Future<bool> CheckIsUserAddDataBefore(
      {required String documentName, required String useruid}) async {
    var user = await FirebaseFirestore.instance
        .collection(documentName)
        .doc(useruid)
        .get();

    return user.exists;
  }
}
