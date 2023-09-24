import 'package:drone_2_0/service/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String _profileDownloadUrl = "";
  String _localStorageUrl = "";
  String _name = "";

  User? get getUser => _auth.currentUser;
  String get getProfileImageDownloadURL => _profileDownloadUrl;
  String get username => _auth.currentUser?.displayName ?? "";
  String get userId => _auth.currentUser?.uid ?? "";
  String get name => _name; // CHANGE TO ACTUAL NAME
  String get email => _auth.currentUser?.email ?? "";
  String get storageUrl => _localStorageUrl;

  void initPhotoUrl() {
    _localStorageUrl = getUser?.photoURL ?? "";
  }

  void setProfileImageURL(String newImgURL) {
    // updating the actual link for downloading
    _profileDownloadUrl = newImgURL;
    notifyListeners();
  }

  void updatePhotoURL(String newPhotoURL) {
    // updating the relative path within Firebase Storage
    _localStorageUrl = newPhotoURL;
    _auth.currentUser?.updatePhotoURL(newPhotoURL);
    notifyListeners();
  }

  void updateEmail(String newEMail) {
    _auth.currentUser?.updateEmail(newEMail);
    notifyListeners();
  }

  void updateUsername(String newUsername) {
    _auth.currentUser?.updateEmail(newUsername);
    notifyListeners();
  }

  void updateName(String newName) {
    _name = newName;
    Logger().i("CHange Name -> Not implemented");
    //_auth.currentUser?.updateEmail(newUsername);
    //notifyListeners();
  }

  Future<void> fetchProfileDownloadURL() async {
    // initializing the photo download url for later synchronous use
    if (_localStorageUrl != "") {
      _profileDownloadUrl = await StorageService().downloadURL(_localStorageUrl);
      print("New Download Image URL: $_profileDownloadUrl");
    }
    notifyListeners();
  }
}
