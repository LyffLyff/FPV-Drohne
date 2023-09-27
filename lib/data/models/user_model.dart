import 'package:cloud_firestore/cloud_firestore.dart';

Map<String, dynamic> defaultSettings = {
  "isDark": true,
};

class UserDataModel {
  final String email;
  final String fullName;
  final String username;
  final String storagePath;
  final String userId;
  String downloadURL = "";
  Map<String, dynamic> settings = defaultSettings;

  UserDataModel(
      {required this.userId,
      required this.email,
      required this.fullName,
      required this.username,
      required this.storagePath});

  Map<String, dynamic> toMap() => {
        "email": email,
        "fullName": fullName,
        "username": username,
        "storagePath": storagePath,
        "settings" : defaultSettings,
      };

  static UserDataModel? fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return UserDataModel(
      username: snapshot['username'],
      fullName: snapshot['name'],
      email: snapshot['email'],
      storagePath: snapshot['storagePath'],
      userId: snapshot["userId"],
    );
  }
}
