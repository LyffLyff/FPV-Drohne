import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? get getUser => _auth.currentUser;
  String? get getUsername => _auth.currentUser?.displayName;
  String? get getUserId => _auth.currentUser?.uid;
  String? get getEmail => _auth.currentUser?.email;
}
