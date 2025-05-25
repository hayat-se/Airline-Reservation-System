import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  // 🔑 Keys
  static const _kNameKey = 'name';
  static const _kEmailKey = 'email';
  static const _kAddressKey = 'address';
  static const _kPassportKey = 'passport';
  static const _kDOBKey = 'dob';
  static const _kCountryKey = 'country';
  static const _kImagePathKey = 'imagePath';
  static const _kPasswordKey = 'password';

  /// ✅ Save full user info (profile + optional password)
  static Future<void> saveUser(Map<String, String?> user) async {
    final prefs = await SharedPreferences.getInstance();
    user.forEach((key, value) {
      if (value != null) prefs.setString(key, value.trim());
    });
  }

  /// ✅ Retrieve all stored user details
  static Future<Map<String, String?>> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'name': prefs.getString(_kNameKey),
      'email': prefs.getString(_kEmailKey),
      'address': prefs.getString(_kAddressKey),
      'passport': prefs.getString(_kPassportKey),
      'dob': prefs.getString(_kDOBKey),
      'country': prefs.getString(_kCountryKey),
      'imagePath': prefs.getString(_kImagePathKey),
      'password': prefs.getString(_kPasswordKey),
    };
  }

  /// ✅ Save only profile image
  static Future<void> saveProfileImagePath(String path) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kImagePathKey, path);
  }

  /// ✅ Save or overwrite login credentials (email & password)
  static Future<void> saveUserCredentials(
      String email, String password, {String? name}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kEmailKey, email.trim());
    await prefs.setString(_kPasswordKey, password.trim());
    if (name != null) await prefs.setString(_kNameKey, name.trim());
  }

  /// ✅ Verify login credentials
  static Future<bool> verify(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_kEmailKey) == email.trim() &&
        prefs.getString(_kPasswordKey) == password.trim();
  }

  /// ✅ Check if user is considered logged in
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString(_kEmailKey);
    final password = prefs.getString(_kPasswordKey);
    return email != null && email.isNotEmpty && password != null && password.isNotEmpty;
  }

  /// ✅ Clear all user data (logout)
  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kNameKey);
    await prefs.remove(_kEmailKey);
    await prefs.remove(_kAddressKey);
    await prefs.remove(_kPassportKey);
    await prefs.remove(_kDOBKey);
    await prefs.remove(_kCountryKey);
    await prefs.remove(_kImagePathKey);
    await prefs.remove(_kPasswordKey);
  }
}
