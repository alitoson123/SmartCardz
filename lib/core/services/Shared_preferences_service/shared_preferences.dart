import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  SharedPreferencesService._privateConstructor();
  static final SharedPreferencesService instance =
      SharedPreferencesService._privateConstructor();

  late SharedPreferences _prefs;

  /// MUST be called in main()
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // -------------------------------
  // SETTERS
  // -------------------------------
  Future<void> setString(String key, String value) async {
    await _prefs.setString(key, value);
  }

  Future<void> setInt(String key, int value) async {
    await _prefs.setInt(key, value);
  }

  Future<void> setBool(String key, bool value) async {
    await _prefs.setBool(key, value);
  }

  Future<void> setDouble(String key, double value) async {
    await _prefs.setDouble(key, value);
  }

  Future<void> setStringList(String key, List<String> value) async {
    await _prefs.setStringList(key, value);
  }

  // -------------------------------
  // GETTERS
  // -------------------------------
  String? getString(String key) => _prefs.getString(key);

  int? getInt(String key) => _prefs.getInt(key);

  bool? getBool(String key) => _prefs.getBool(key);

  double? getDouble(String key) => _prefs.getDouble(key);

  List<String>? getStringList(String key) => _prefs.getStringList(key);

  // -------------------------------
  // REMOVE & CLEAR
  // -------------------------------
  Future<void> remove(String key) async {
    await _prefs.remove(key);
  }

  Future<void> clear() async {
    await _prefs.clear();
  }

  // Check if key exists
  bool contains(String key) => _prefs.containsKey(key);
}
