import 'package:drone_2_0/data/models/user_model.dart';
import 'package:drone_2_0/service/storage_service.dart';
import 'package:drone_2_0/service/user_profile_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final UserProfileService _userDocument = UserProfileService();

  // local variables (for easier usage)
  String _profileImageDownloadURL = "";
  String _storagePath = "";
  String _fullName = "";
  String _username = "";

  // Getters
  User? get currentUser => _auth.currentUser;
  String get profileImageDownloadURL => _profileImageDownloadURL;
  String get username => _username;
  String get userId => _auth.currentUser?.uid ?? "";
  String get fullName => _fullName; // CHANGE TO ACTUAL NAME
  String get email => _auth.currentUser?.email ?? "";
  String get storageUrl => _storagePath;

  // Profile Image Methods
  Future<void> initStoragePath() async {
    updatePhotoURL(_storagePath);
  }

  Future<void> updatePhotoURL(String newStoragePath) async {
    // updating the relative path within Firebase Storage
    _storagePath = newStoragePath;
    _auth.currentUser?.updatePhotoURL(newStoragePath);
    await _userDocument.setUserValue(
        userId: userId, key: "storagePath", value: newStoragePath);

    // fetching the new download url
    await _fetchProfileDownloadURL();

    notifyListeners();
  }

  Future<void> _fetchProfileDownloadURL() async {
    // initializing the photo download url for later synchronous use
    if (_storagePath != "") {
      _profileImageDownloadURL =
          await StorageService().downloadURL(_storagePath);
      print("New Download Image URL: $_profileImageDownloadURL");
    }
    notifyListeners();
  }

  // Updating Userdata
  Future<void> updateEmail(String newEmail) async {
    _auth.currentUser?.updateEmail(newEmail);
    await _userDocument.setUserValue(
        userId: userId, key: "email", value: newEmail);
    notifyListeners();
  }

  Future<void> updateUsername(String newUsername) async {
    _username = newUsername;
    _auth.currentUser?.updateDisplayName(newUsername);
    await _userDocument.setUserValue(
        userId: userId, key: "username", value: newUsername);
    Logger().i("Changed Username of Current User: $userId");
    notifyListeners();
  }

  Future<void> updateName(String newName) async {
    _fullName = newName;
    await _userDocument.setUserValue(
        userId: userId, key: "fullName", value: newName);
    Logger().i("Changed Full Name of Current User: $userId");
    notifyListeners();
  }

  // Initializers
  Future<void> createUser(User newUser, UserDataModel userDataModel) async {
    // called when registering a new account

    // init firestore user document
    await _userDocument.setMultipleUserValues(
        userId: newUser.uid, newUserdata: userDataModel.toMap());

    // init user credentials
    newUser.updateDisplayName(userDataModel.username);
  }

  Future<void> initUser() async {
    // called on startup of Application -> setting all needed values
    Map<String, dynamic>? data = await _userDocument.fetchUserData(userId: userId);
    _fullName = data?["fullName"] ?? "";
    _username = data?["username"] ?? "";
    _storagePath = data?["storagePath"] ?? "";
    
    await initStoragePath();
  }
}
