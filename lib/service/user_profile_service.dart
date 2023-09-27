import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfileService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> editDocumentField(
      {required String collection,
      required String document,
      required String key,
      required dynamic newFieldValue}) async {
    try {
      await _firestore
          .collection(collection)
          .doc(document)
          .set({key: newFieldValue}, SetOptions(merge : true));
      return "Success";
    } on FirebaseException catch (e) {
      return e.toString();
    }
  }

  Future<String> editMultipleDocumentFields(
      {required String collection,
      required String document,
      required Map<String, dynamic> data}) async {
    try {
      await _firestore.collection(collection).doc(document).set(data, SetOptions(merge : true));
      return "Success";
    } on FirebaseException catch (e) {
      return e.toString();
    }
  }

  // easier functions when directly editing userdata
  Future<String> setUserValue(
      {required String userId, required String key, required dynamic value}) {
    return editDocumentField(
        collection: "users", document: userId, key: key, newFieldValue: value);
  }

  Future<String> setMultipleUserValues(
      {required String userId, required Map<String, dynamic> newUserdata}) {
    return editMultipleDocumentFields(
        collection: "users", document: userId, data: newUserdata);
  }

  Future<dynamic> fetchUserDocumentKey({required String userId, required String key}) async {
    if (userId.isEmpty) {
      return "";
    }
    var docSnapshot = await _firestore.collection("users").doc(userId).get();
    if (docSnapshot.exists) {
      Map<String, dynamic>? data = docSnapshot.data();
      return data?[key];
    }
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
}
