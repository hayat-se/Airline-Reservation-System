import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static const _kEmailKey    = 'email';
  static const _kPasswordKey = 'password';
  static const _kNameKey     = 'name';

  /* ---------------- PUBLIC API --------------- */

  /// Save or overwrite credentials & name.
  static Future<void> saveUserCredentials(
      String email,
      String password, {
        String? name,
      }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kEmailKey, email.trim());
    await prefs.setString(_kPasswordKey, password.trim());
    if (name != null) await prefs.setString(_kNameKey, name.trim());
  }

  /// Return a map with whatever fields were found.
  static Future<Map<String, String?>> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'email'   : prefs.getString(_kEmailKey),
      'password': prefs.getString(_kPasswordKey),
      'name'    : prefs.getString(_kNameKey),
    };
  }

  /// Check typed email & password against stored values.
  static Future<bool> verify(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_kEmailKey) == email.trim() &&
        prefs.getString(_kPasswordKey) == password.trim();
  }

  /// Remove everything (call on logout).
  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kEmailKey);
    await prefs.remove(_kPasswordKey);
    await prefs.remove(_kNameKey);
  }

  /// Check if user is logged in by checking if email & password are stored
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString(_kEmailKey);
    final password = prefs.getString(_kPasswordKey);
    return email != null && email.isNotEmpty && password != null && password.isNotEmpty;
  }
}
