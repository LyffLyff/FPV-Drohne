import 'package:drone_2_0/data/models/user_model.dart';
import 'package:drone_2_0/data/providers/auth_provider.dart';
import 'package:drone_2_0/service/auth/auth_error_handler.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  Future<User?> currentUser() async {
    return FirebaseAuth.instance.currentUser;
  }

  Future<AuthStatus?> registration({
    required String email,
    required String password,
    required String username,
    required String name,
    required AuthenticationProvider authProvider,
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
      await authProvider.createUser(
          user!,
          UserDataModel(
            email: email,
            userId: user.uid,
            fullName: name,
            storagePath: '',
            username: username,
          ));

      return AuthStatus.successful;
    } on FirebaseAuthException catch (e) {
      return AuthExceptionHandler.handleAuthException(e);
    } catch (e) {
      return AuthStatus.unknown;
    }
  }

  Future<AuthStatus?> login({
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return AuthStatus.successful;
    } on FirebaseAuthException catch (e) {
      return AuthExceptionHandler.handleAuthException(e);
    } catch (e) {
      return AuthStatus.unknown;
    }
  }

  Future<UserCredential?> signInWithGoogle() async {
    GoogleSignIn googleSignIn = GoogleSignIn();
    // Trigger the authentication flow
    // -> causes PlatformException on dismiss that cannot be catched -> not an issue in release version apparently
    GoogleSignInAccount? googleUser;
    googleUser = await googleSignIn.signIn().catchError((onError) => null);
    if (googleUser == null) {
      // User canceled the Google Sign-In dialog
      // Handle this case as needed
      return null;
    }

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }
}
