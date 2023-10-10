import 'package:drone_2_0/data/models/user_model.dart';
import 'package:drone_2_0/data/providers/auth_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {

  Future<User?> currentUser() async {
    return FirebaseAuth.instance.currentUser;
  }

  Future<String?> registration({
    required String email,
    required String password,
    required String username,
    required String name,
    required AuthProvider authProvider,
  }) async {
    try {
      // Create User with Email and Password
      UserCredential userCredentials =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Set Additional Value for new Auth User Account
      User? user = userCredentials.user;
      //user?.sendEmailVerification();
      await authProvider.createUser(user!, UserDataModel(email: email, userId: user.uid, fullName: name, storagePath: '', username: username, ));
     
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

}
