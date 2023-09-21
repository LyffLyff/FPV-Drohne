import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drone_2_0/data/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
      UserCredential userCredentials =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Add Data to User Profile
      print("INITING USER");
      await initUserData(
        newUser: UserModel(
            userId: userCredentials.user!.uid,
            email: email,
            name: name,
            username: username,
            profileImgURL: ""),
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
    await _firestore.collection("users").doc(newUser.userId).set({
      "email": newUser.email,
      "name": newUser.name,
      "profileImgURL": "",
      "username": newUser.username,
      "settings": newUser.settings,
    });

    print("Userdata Saved");
    return null;
  }

  Future<Map<String, dynamic>?> fetchUserData({required String userId}) async {
    if (userId.isEmpty) {
      return {};
    }
    var docSnapshot = await _firestore.collection("users").doc(userId).get();
    if (docSnapshot.exists) {
      Map<String, dynamic>? data = docSnapshot.data();
      return data;
    }
    return null;
  }

  Future<dynamic> fetchSingleSetting(
      {required String userId, required String settingKey}) async {
    if (userId.isEmpty) {
      return null;
    }
    var docSnapshot = await _firestore.collection("users").doc(userId).get();
    if (docSnapshot.exists) {
      Map<String, dynamic>? data = docSnapshot.data();
      return data?["settings"][settingKey] ?? "invalid key";
    }
    return null;
  }

  Future<void> changeUserEmail(
      {required String oldEmail, required String newEmail}) async {
    // retrieving old Userdata
    var docSnapshot = await _firestore.collection("users").doc(oldEmail).get();
    if (docSnapshot.exists) {
      // creating new document with new Email
      Map<String, dynamic>? data = docSnapshot.data();
      /*initUserData(
          newUser: UserModel(
            userId: ,
              email: newEmail,
              name: data?["name"],
              username: data?["username"],
              profileImgURL: data?["profileImgURL"]));*/
      // deleting old document
    }
  }
}
