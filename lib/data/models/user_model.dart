import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String email;
  final String name;
  final String username;
  final String profileImgURL;
  final Map<String, dynamic> settings = {};

  UserModel(
      {required this.email,
      required this.name,
      required this.username,
      required this.profileImgURL});

  Map<String, dynamic> toJson() => {
        "email": email,
        "name": name,
        "username": username,
        "profileImgURL": ""
      };

  static UserModel? fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return UserModel(
      username: snapshot['username'],
      name: snapshot['name'],
      email: snapshot['email'],
      profileImgURL: snapshot['profileImgURL'],
    );
  }
}