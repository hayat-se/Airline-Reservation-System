import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  bool isLoading = false;

  void toggleLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  Future<void> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    toggleLoading(true);
    await Future.delayed(const Duration(seconds: 2)); // Simulate API call
    toggleLoading(false);
    // You can add real backend call here
  }
}
