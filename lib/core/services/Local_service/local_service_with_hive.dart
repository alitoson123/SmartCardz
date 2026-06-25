import 'package:hive/hive.dart';
import 'package:smart_cards/Features/Auth/Data/models/user_model.dart';
import 'package:smart_cards/constant.dart';

class LocalServiceWithHive {
  final Box<UserModel> box = Hive.box<UserModel>(AppConstants.K_USER_BOX);

  Future<void> saveUser(UserModel user) async {
    await box.put(AppConstants.K_CURRENT_USER, user);
  }

  UserModel? getUser() {
    return box.get(AppConstants.K_CURRENT_USER);
  }

  Future<void> deleteUser() async {
    await box.delete(AppConstants.K_CURRENT_USER);
  }
}
