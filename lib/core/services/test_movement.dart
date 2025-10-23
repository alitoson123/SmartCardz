import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> migrateFlashCardsToEnglish() async {
  final firestore = FirebaseFirestore.instance;

  // المسار القديم
  final oldCardsRef = firestore.collection('flash cards');

  // المسار الجديد
  final newCardsRef = firestore
      .collection('users')
      .doc('kHkBrcrKm1WmzKAeI3Uj22TB1XK2')
      .collection('user_collections')
      .doc('user_collections_id')
      .collection('English');

  // نجيب كل الدوكمنتات القديمة
  final oldCardsSnapshot = await oldCardsRef.get();

  int moved = 0;

  for (var doc in oldCardsSnapshot.docs) {
    await newCardsRef.add(doc.data()); // ننقل الداتا نفسها
    moved++;
  }

  print('✅ تم نقل $moved كارت بنجاح إلى English');
}
