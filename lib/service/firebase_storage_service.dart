import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class FirebaseStorageService {
  final storageRef = FirebaseStorage.instance.ref();

  Future<void> uploadFile(String filePath) async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    
final mountainsRef = storageRef.child(filePath);

    String filePath = '${appDocDir.absolute}/file-to-upload.png';
    File file = File(filePath);

    try {
      await mountainsRef.putFile(file);
    } on firebase_core.FirebaseException catch (e) {
      // ...
    }
  }
}
