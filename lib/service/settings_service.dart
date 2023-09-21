import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SettingsService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String?> addNewSettings(
      {required String userId,
      required Map<String, dynamic> settings}) async {
    // Creating new Document or Adding to Already existing one
    await _firestore
        .collection("users")
        .doc(userId)
        .set({"settings": settings}, SetOptions(merge: true));

    return null;
  }
}
