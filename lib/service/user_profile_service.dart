import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfileService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<int> editDocumentField({required String collection, required String document, required String fieldTitle, required String newFieldValue}) async {
    try {
      await _firestore.collection(collection).doc(document).update({fieldTitle: newFieldValue});
      return 200;
    } on FirebaseException catch(e) {
      print(e.toString());
      return 400;
    }
  }
}