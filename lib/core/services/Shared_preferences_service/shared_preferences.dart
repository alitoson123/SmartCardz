import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  static const String isLogin = 'isLogin';

  static Future<void> setVlaue({required bool value}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setBool(isLogin, value);
  }

  static Future<bool> getValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool result = prefs.getBool(isLogin) ?? false;

    return result;
  }

  static Future<void> removeAuthData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(isLogin);
  }
}
