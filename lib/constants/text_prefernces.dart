import 'package:shared_preferences/shared_preferences.dart';

class TextPreferences {
  static final Future<SharedPreferences> _preferences = SharedPreferences.getInstance();

  static const _keyText = 'text';

  static Future<void> setText(String text) async {
    final prefs = await _preferences;
    await prefs.setString(_keyText, text);
  }

  static Future<String> getText() async {
    final prefs = await _preferences;
    return prefs.getString(_keyText) ?? '';
  }
}
