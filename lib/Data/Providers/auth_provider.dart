import 'package:airline_reservation_system/data/providers/services/local_storage_service.dart';
import 'package:flutter/material.dart';
import '../../Ui/Screens/Login/login_with_phone_screen.dart';
import '../../main.dart';

class AuthProvider with ChangeNotifier {
  bool _isLoading = false;
  bool _isLoggedIn = false;

  bool get isLoading => _isLoading;
  bool get isLoggedIn => _isLoggedIn;

  AuthProvider() {
    _init();
  }

  Future<void> _init() async {
    _isLoggedIn = await LocalStorageService.isLoggedIn();
    notifyListeners();
  }

  Future<void> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    _setLoading(true);
    // Simulate network call
    await Future.delayed(const Duration(seconds: 1));
    await LocalStorageService.saveUserCredentials(
      email,
      password,
      name: name,
    );
    _isLoggedIn = true;
    _setLoading(false);
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    _setLoading(true);
    await Future.delayed(const Duration(seconds: 1));
    await LocalStorageService.saveUserCredentials(
      email,
      password,
      name: 'John Doe',
    );
    _isLoggedIn = true;
    _setLoading(false);
  }

  Future<void> logout() async {
    await LocalStorageService.clear();
    _isLoggedIn = false;
    notifyListeners();

    // use the root navigator to wipe every route and show login
    navigatorKey.currentState?.pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginWithPhoneScreen()),
          (_) => false,
    );
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
