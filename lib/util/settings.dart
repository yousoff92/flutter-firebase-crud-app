
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class Settings {

  static Future<String> getSettings(String key, [String defaultValue]) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key) ?? (defaultValue ?? null);
  }

  static Future<bool> setSettings(String key, dynamic value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(key, value);
  }

}