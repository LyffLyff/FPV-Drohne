import 'package:drone_2_0/service/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String _photoURL = "";
  String _name = "";

  User? get getUser => _auth.currentUser;
  String get getProfileImageDownloadURL => _photoURL;
  String get username => _auth.currentUser?.displayName ?? "";
  String get userId => _auth.currentUser?.uid ?? "";
  String get name => _name; // CHANGE TO ACTUAL NAME
  String get email => _auth.currentUser?.email ?? "";

  void setProfileImageURL(String newImgURL) {
    // setting the profile image to the users
    _auth.currentUser?.updatePhotoURL(newImgURL);
    _photoURL = newImgURL;
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
    final imgURL = getUser?.photoURL;
    if (imgURL != null) {
      _photoURL = await StorageService().downloadURL(imgURL);
    }
    notifyListeners();
  }
}
