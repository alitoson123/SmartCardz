import 'package:hive/hive.dart';
import 'package:smart_cards/Features/Auth/Data/models/user_model.dart';
import 'package:smart_cards/constant.dart';

class LocalServiceWithHive {
  final Box<UserModel> box = Hive.box<UserModel>(KUserBox);

  Future<void> saveUser(UserModel user) async {
    await box.put(currentUser, user);
  }

  UserModel? getUser() {
    return box.get(currentUser);
  }

  Future<void> deleteUser() async {
    await box.delete(currentUser);
  }
}
