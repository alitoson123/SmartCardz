import 'package:hive/hive.dart';
import 'package:smart_cards/Features/Auth/Data/models/user_model.dart';
import 'package:smart_cards/constant.dart';

class LocalServiceWithHive {
  final Box<UserModel> box = Hive.box<UserModel>(K_USER_BOX);

  Future<void> saveUser(UserModel user) async {
    await box.put(K_CURRENT_USER, user);
  }

  UserModel? getUser() {
    return box.get(K_CURRENT_USER);
  }

  Future<void> deleteUser() async {
    await box.delete(K_CURRENT_USER);
  }
}
