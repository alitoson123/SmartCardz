import 'package:hive/hive.dart';

class GeneralLocalService {
  Future<int> add<T>(String boxName, T value) async {
    final box = Hive.box<T>(boxName);
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

  Future<void> deleteItems<T>(String boxName, bool Function(T) filter) async {
    final box = Hive.box<T>(boxName);
    final keysToDelete = <dynamic>[];
    for (var key in box.keys) {
      final item = box.get(key);
      if (item != null && filter(item)) {
        keysToDelete.add(key);
      }
    }
    await box.deleteAll(keysToDelete);
  }

  Future<void> updateItem<T>(
    String boxName,
    T newValue,
    bool Function(T) filter,
  ) async {
    final box = Hive.box<T>(boxName);
    dynamic keyToUpdate;

    for (var key in box.keys) {
      final item = box.get(key);
      if (item != null && filter(item)) {
        keyToUpdate = key;
        break;
      }
    }

    if (keyToUpdate != null) {
      await box.put(keyToUpdate, newValue);
    }
  }

  Future<void> deleteBox(String boxName) async {
    if (Hive.isBoxOpen(boxName)) {
      await Hive.box(boxName).close();
    }
    await Hive.deleteBoxFromDisk(boxName);
  }
}
