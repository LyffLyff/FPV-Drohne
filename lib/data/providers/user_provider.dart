import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  late User _user;
  late String _email = "";
  late String _username = "";
  late String _name = "";
  late String _userId = "";

  String get email => _email;
  String get username => _username;
  String get name => _name;
  String get userId => _userId;
  User get currentUser => _user;

void setCurrentUser(User newUser) {
  _user = newUser;
  notifyListeners();
}

void setUser(String newEmail) {
    _email = newEmail;
    // letting any widget including this know of the change
    notifyListeners();
  }

  void changeUserEmail(String newEmail) {
    _email = newEmail;
    // letting any widget including this know of the change
    notifyListeners();
  }

  void changeUsername(String newUsername) {
    _username = newUsername;
    notifyListeners();
  }

  void changeName(String newName) {
    _name = newName;
    notifyListeners();
  }

  void changeUserId(String newUserId) {
    _userId = newUserId;
    notifyListeners();
  }
}