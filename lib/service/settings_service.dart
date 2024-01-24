import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drone_2_0/data/providers/logging_provider.dart';

class SettingsService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String?> addNewSettings(
      {required String userId, required Map<String, dynamic> settings}) async {
    // Creating new Document or Adding to Already existing one
    try {
      await _firestore
          .collection("users")
          .doc(userId)
          .update({"settings": settings});
    } on FirebaseException catch (e) {
      Logging.error(e.toString());
    }

    return null;
  }

  Future<dynamic> fetchSingleSetting(
      {required String userId, required String settingKey}) async {
    try {
      if (userId.isEmpty) {
        return null;
      }

      var docSnapshot = await _firestore.collection("users").doc(userId).get();

      if (docSnapshot.exists) {
        Map<String, dynamic>? data = docSnapshot.data();
        return data?["settings"]?[settingKey] ?? "invalid key";
      }
    } catch (e) {
      // Handle the exception here (e.g., log it, return a default value, etc.)
      Logging.error("Error Fetching Single Setting: $e");
    }
    return null; // You can customize the error handling as needed
  }
}
