import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drone_2_0/service/local_storage_service.dart';

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
          .update({key: newFieldValue});
      return "Success";
    } on FirebaseException catch (e) {
      return e.toString();
    }
  }

  Future<String> setDocumentField(
      {required String collection,
      required String document,
      required String key,
      required dynamic newFieldValue}) async {
    if (document.isNotEmpty) {
      try {
        await _firestore
            .collection(collection)
            .doc(document)
            .update({key: newFieldValue});
        return "Success";
      } on FirebaseException catch (e) {
        return e.toString();
      }
    }
    return "No Document Provided";
  }

  Future<String> editMultipleDocumentFields(
      {required String collection,
      required String document,
      required Map<String, dynamic> data}) async {
    try {
      await _firestore.collection(collection).doc(document).update(data);
      return "Success";
    } on FirebaseException catch (e) {
      return e.toString();
    }
  }

  Future<void> addFlightData(String collection, String userId, int timestamp,
      Map<String, dynamic> newFlightData) async {
    // this function adds a new entry of flight data to the subcollection within the user document
    await FirebaseFirestore.instance
        .collection(collection)
        .doc(userId)
        .collection("flight_data")
        .doc(timestamp.toString())
        .set(newFlightData);

    // sets timestamp when last updated
    await FirebaseFirestore.instance
        .collection(collection)
        .doc(userId)
        .collection("data_timestamps")
        .doc("flight_data_age")
        .set({"flight_data_age": DateTime.now().millisecondsSinceEpoch});
  }

  Future<List> getFlightDataSets(String userId) async {
    // loading flight data
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .collection("flight_data")
        .get();

    // returning list of documents within flight_data subcollection
    return querySnapshot.docs.map((doc) => doc.data() as Map).toList();
  }

  Future<dynamic> fetchDataAge(
      {required String userId, required String timestampKey}) async {
    if (userId.isEmpty) {
      return "";
    }
    var docSnapshot = await _firestore
        .collection("users")
        .doc(userId)
        .collection("data_timestamps")
        .doc("flight_data_age")
        .get();
    if (docSnapshot.exists) {
      Map<String, dynamic>? data = docSnapshot.data();
      return data?[timestampKey];
    }
    return null;
  }

  Future<String> setMultipleDocumentFields(
      {required String collection,
      required String document,
      required Map<String, dynamic> data}) async {
    try {
      await _firestore.collection(collection).doc(document).set(data);
      return "Success";
    } on FirebaseException catch (e) {
      return e.toString();
    }
  }

  // easier functions when directly editing userdata
  Future<String> setUserValue(
      {required String userId, required String key, required dynamic value}) {
    return setDocumentField(
        collection: "users", document: userId, key: key, newFieldValue: value);
  }

  Future<String> updateUserValue(
      {required String userId, required String key, required dynamic value}) {
    return editDocumentField(
        collection: "users", document: userId, key: key, newFieldValue: value);
  }

  Future<String> setMultipleUserValues(
      {required String userId, required Map<String, dynamic> newUserdata}) {
    return setMultipleDocumentFields(
        collection: "users", document: userId, data: newUserdata);
  }

  Future<String> updateMultipleUserValues(
      {required String userId, required Map<String, dynamic> newUserdata}) {
    return editMultipleDocumentFields(
        collection: "users", document: userId, data: newUserdata);
  }

  Future<dynamic> fetchUserDocumentKey(
      {required String userId, required String key}) async {
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
