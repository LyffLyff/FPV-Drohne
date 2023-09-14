import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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

class AuthService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<User?> getUser() async {
    return FirebaseAuth.instance.currentUser;
  }

  Future<String?> registration({
    required String email,
    required String password,
    required String username,
    required String name,
  }) async {
    try {
      // Create User with Email and Password
      FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Add Data to User Profile
      print("INITING USER");
      await initUserData(
        newUser: UserModel(
            email: email, name: name, username: username, profileImgURL: ""),
      );

      return 'Success';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        return 'The account already exists for that email.';
      } else {
        return e.message;
      }
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> login({
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return 'Success';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        return 'Wrong password provided for that user.';
      } else {
        return e.message;
      }
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> initUserData({
    required UserModel newUser,
  }) async {
    await _firestore.collection("users").doc(newUser.email).set({
      "email": newUser.email,
      "name": newUser.name,
      "profileImgURL": "",
      "username": newUser.username,
      "settings": newUser.settings,
    });

    print("Userdata Saved");
    return null;
  }

  Future<Map<String, dynamic>?> fetchUserData({required String email}) async {
    var docSnapshot = await _firestore.collection("users").doc(email).get();
    if (docSnapshot.exists) {
      Map<String, dynamic>? data = docSnapshot.data();
      return data;
    }
    return null;
  }

  Future<void> changeUserEmail({required String oldEmail, required String newEmail}) async {
    // retrieving old Userdata
    var docSnapshot = await _firestore.collection("users").doc(oldEmail).get();
    if (docSnapshot.exists) {
      // creating new document with new Email
      Map<String, dynamic>? data = docSnapshot.data();
      initUserData(newUser: UserModel(email: newEmail, name: data?["name"], username: data?["username"], profileImgURL: data?["profileImgURL"]));
      // deleting old document
      
    }
    return null;
  }
}
