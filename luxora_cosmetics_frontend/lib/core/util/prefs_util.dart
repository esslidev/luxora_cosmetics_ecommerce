import 'package:shared_preferences/shared_preferences.dart';

import '../../locator.dart';

class PrefsUtil {
  static final SharedPreferences _prefs = locator<SharedPreferences>();

  // Checks if a key exists
  static bool containsKey(String key) {
    return _prefs.containsKey(key);
  }

  // Get a single string value
  static String? getString(String key) {
    return _prefs.getString(key);
  }

  // Set a single string value
  static void setString(String key, String value) {
    _prefs.setString(key, value);
  }

  // Remove a single key-value pair
  static void remove(String key) {
    _prefs.remove(key);
  }

  // Get a list of strings
  static List<String>? getStringList(String key) {
    return _prefs.getStringList(key);
  }

  // Set a list of strings
  static void setStringList(String key, List<String> value) {
    _prefs.setStringList(key, value);
  }

  // Add a string to a list
  static void addToStringList(String key, String value) {
    final list = getStringList(key) ?? [];
    if (!list.contains(value)) {
      list.add(value);
      setStringList(key, list);
    }
  }

  // Remove a string from a list
  static void removeFromStringList(String key, String value) {
    final list = getStringList(key) ?? [];
    list.remove(value);
    setStringList(key, list);
  }

  // Delete the list of strings
  static void deleteStringList(String key) {
    _prefs.remove(key);
  }

  // Check if a string exists in the list
  static bool stringExistsInList(String key, String value) {
    final list = getStringList(key) ?? [];
    return list.contains(value);
  }
}
