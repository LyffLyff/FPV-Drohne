import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  late String _email;
  late String _username;

  String get email => _email;
  String get username => _username;

  void changeUserEmail(String newEmail) {
    _email = newEmail;

    // letting any widget including this know of the change
    notifyListeners();
  }

  void changeUsername(String newUsername) {
    _username = newUsername;
    notifyListeners();
  }
}