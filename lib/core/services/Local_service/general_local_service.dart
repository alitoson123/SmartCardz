import 'package:hive/hive.dart';

class GeneralLocalService {


   Future<int> add<T>(String boxName, T value) async {
    final box =  Hive.box<T>(boxName);
    return await box.add(value);
  }


   Future<List<T>> getAll<T>(String boxName) async {
    final box = Hive.box<T>(boxName);
    return box.values.toList();
  }


   Future<void> clearBox<T>(String boxName) async {
    final box = Hive.box<T>(boxName);
    await box.clear();
  }



   Future<void> deleteBox(String boxName) async {
    if (Hive.isBoxOpen(boxName)) {
      await Hive.box(boxName).close();
    }
    await Hive.deleteBoxFromDisk(boxName);
  }
}
