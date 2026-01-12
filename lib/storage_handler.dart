import 'package:shared_preferences/shared_preferences.dart';

class StorageHandler {
  late SharedPreferences _prefs; 

  StorageHandler._create(SharedPreferences prefs) {
    _prefs = prefs;
  }

  static Future<StorageHandler> create() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return StorageHandler._create(prefs);
  }

  Future<void> setUserData(List<String> list) async {
    await _prefs.setStringList("user", list);
  }

  Future<List<String>?> getUserData() async {
    return await _prefs.getStringList("user");
  } 

  Future<void> setBusinessData(List<String> list) async {
    await _prefs.setStringList("business", list);
  }

  Future<List<String>?> getBusinessData() async {
    return await _prefs.getStringList("business");
  }
}
