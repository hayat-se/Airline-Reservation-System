import 'package:flutter/material.dart';

class LoginProvider with ChangeNotifier {
  bool keepSignedIn = false;

  void toggleKeepSignedIn() {
    keepSignedIn = !keepSignedIn;
    notifyListeners();
  }
}
