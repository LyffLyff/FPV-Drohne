import 'package:firebase_auth/firebase_auth.dart';

enum AuthStatus {
  successful,
  wrongPassword,
  emailAlreadyExists,
  invalidEmail,
  weakPassword,
  unknown,
}

class AuthExceptionHandler {
  static handleAuthException(FirebaseAuthException e) {
    AuthStatus status;
    switch (e.code) {
      case "invalid-email":
        status = AuthStatus.invalidEmail;
        break;
      case "wrong-password":
        status = AuthStatus.wrongPassword;
        break;
      case "weak-password":
        status = AuthStatus.weakPassword;
        break;
      case "email-already-in-use":
        status = AuthStatus.emailAlreadyExists;
        break;
      default:
        // any other error -> https://firebase.google.com/docs/reference/js/auth?hl=de#autherrorcodes
        status = AuthStatus.unknown;
    }
    return status;
  }

  static String generateErrorMessage(error) {
    String errorMessage;
    switch (error) {
      case AuthStatus.invalidEmail:
        errorMessage = "Email Adress is badly formatted";
        break;
      case AuthStatus.weakPassword:
        errorMessage = "Your Password must be atleast 6 characters";
        break;
      case AuthStatus.wrongPassword:
        errorMessage = "Wrong password or email";
        break;
      case AuthStatus.emailAlreadyExists:
        errorMessage = "Email Adress already in use";
        break;
      default:
        errorMessage = "An unknown error occured";
    }
    return errorMessage;
  }
}
