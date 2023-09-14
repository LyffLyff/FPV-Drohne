import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Define a method to check if the user is logged in.
  User? get getUser => _auth.currentUser;

  // Add methods for login, logout, and other authentication operations.
  // ...
}