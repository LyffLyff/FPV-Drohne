import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


class UserModel{
  final String email;
  final String name;
  final String username;
  final String profileImgURL;

  UserModel(
      {required this.email,
      required this.name,
      required this.username,
      required this.profileImgURL
      }
    );

  Map<String, dynamic> toJson() => {
        "email": email,
        "name": name,
        "username": username,
        "profileImgURL": ""
      };

  static UserModel? fromSnap (DocumentSnapshot snap) {
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

  Future<String?> registration({
    required String email,
    required String password,
    required String username,
    required String name,
  }) async {
    try {

      // Create User with Email and Password
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Add Data to User Profile
      print("INITING USER");
      await initUserData(newUser: UserModel(email: email, name: name, username: username, profileImgURL: ""));

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
    _firestore.collection("users").doc(newUser.email).set({
      "email" : newUser.email,
      "name" : newUser.name,
      "profileImgURL" : "",
      "username" : newUser.username
      });

    print("Userdata Saved");
    return null;
  }

  Future<String?> fetchUserData({required String email}) async {
      var docSnapshot = await _firestore.collection("users").doc(email).get();
      if (docSnapshot.exists) {
        Map<String, dynamic>? data = docSnapshot.data();
        return data?['username'];
      }
      return null;
    }
}


