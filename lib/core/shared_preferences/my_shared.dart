import 'package:shared_preferences/shared_preferences.dart';

import 'my_shared_keys.dart';

class MyShared {
  static SharedPreferences? _preferences;

  static Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  static Future<void> clear() async {
    await _preferences?.clear();
  }

  static Future<void> clearUserData() async {
    await putString(key: MySharedKeys.apiToken, value: "");
    await putString(key: MySharedKeys.name, value: "");
    await putString(key: MySharedKeys.picture, value: "");
    await putString(key: MySharedKeys.email, value: "");
    await putString(key: MySharedKeys.phone, value: "");
  }

  static void putBoolean({
    required MySharedKeys key,
    required bool value,
  }) async {
    await _preferences?.setBool(key.name, value);
  }

  static bool getBoolean({
    required MySharedKeys key,
    bool defaultValue = false,
  }) {
    return _preferences?.getBool(key.name) ?? defaultValue;
  }

  static Future<bool> putString({
    required MySharedKeys key,
    required String? value,
  }) async {
    return await _preferences?.setString(key.name, value ?? "") ?? false;
  }

  static Future<bool> putInt({
    required MySharedKeys key,
    required int? value,
  }) async {
    return await _preferences?.setInt(key.name, value ?? 0) ?? false;
  }
  static int? getInt({required MySharedKeys key}) {
    return _preferences?.getInt(key.name) ;
  }
  static String getString({required MySharedKeys key}) {
    return _preferences?.getString(key.name) ?? "";
  }

  static String getCurrentLanguage() {
    return _preferences?.getString(MySharedKeys.currentLanguage.name) ?? "en";
  }

  static bool isLoggedIn() {
    return (_preferences?.getString(MySharedKeys.apiToken.name) ?? "")
        .isNotEmpty;
  }

  static bool isEnglish() => getCurrentLanguage() == "en";

  static bool isFirstOpen() {
    return _preferences?.getBool(MySharedKeys.firstOpen.name) ?? true;
  }
}
