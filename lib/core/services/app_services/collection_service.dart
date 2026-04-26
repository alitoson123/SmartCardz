import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smart_cards/Features/Home/Data/Models/collection_model.dart';
import 'package:smart_cards/Features/Home/Domain/Entities/collection_entity.dart';

class CollectionService {
  static final firestore = FirebaseFirestore.instance;

  // create collection
  Future<CollectionEntity> createNewCollection({
    required String collectionName,
  }) async {
    final ref = firestore.collection('collections').doc();
    await ref.set({
      'id': ref.id,
      'ownerId': FirebaseAuth.instance.currentUser!.uid,
      'collection_name': collectionName,
      'cards_count': 0,
      'created_at': FieldValue.serverTimestamp(),
    });

    final snapshot = await ref.get();
    final model = CollectionModel.fromDoc(snapshot);

    return model;
  }
  /* need to return ???

  yes , because

In your Cubit, when you successfully create a new collection, you can take the returned CollectionModel and immediately append it to your existing list of collections in the state
and if You didn't return it, you would have to trigger a completely new fetch of the entire list from Firebase just to make the new collection appear on the screen, which costs extra Firestore reads and makes the app feel slower.

  */

  // fetch user collections
  Future<List<CollectionEntity>> fetchUserCollections() async {
    final snap = await firestore
        .collection('collections')
        .where('ownerId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .orderBy('created_at')
        .get();

    final collections = snap.docs
        .map(
          (e) => CollectionModel.fromDoc(e),
        ) // ديه map() (function)  هنا مفيش key/value فيه بس:عنصر (e)بتحوّله لحاجة تانية
        .toList(); // map بترجع حاجة اسمها Iterable وإنت محتاج List

    return collections;
  }

  // delete collection
  static Future<String> deleteCollection({required String collectionId}) async {
    final cardsSnap = await firestore
        .collection('cards')
        .where('collectionId', isEqualTo: collectionId)
        .get(); // get all cards of the collection

    for (final item in cardsSnap.docs) {
      // delete all cards of the collection
      await item.reference.delete();
    }

    await firestore
        .collection('collections')
        .doc(collectionId)
        .delete(); // delete the collection

    return collectionId;
  }

  // rename collection
  static Future<void> renameCollection({
    required String collectionId,
    required String newCollectionName,
  }) async {
    await firestore.collection('collections').doc(collectionId).update({
      'collection_name': newCollectionName,
    });
  }

  // get card cards and due cards count
  static Future<Map<String, int>> getCardStateCounts({
    required String collectionId,
  }) async {
    final now = Timestamp.now();

    final collectionDoc = await firestore
        .collection('collections')
        .doc(collectionId)
        .get();

    final totalCardsCount = (collectionDoc.data()?['cards_count'] ?? 0) as int;

    final dueCardsAgg = await firestore
        .collection('cards')
        .where('collectionId', isEqualTo: collectionId)
        .where('due_date', isLessThanOrEqualTo: now)
        .count()
        .get();

    return {'due': dueCardsAgg.count ?? 0, 'total': totalCardsCount};
  }
}
