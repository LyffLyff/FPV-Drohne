import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_core/firebase_core.dart' as firebase_core;

class StorageService {
  final firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  Future<void> uploadFile(String storageFolder, String filepath, String filename) async {
    File file = File(filepath); // convert filepath to file object

    try {
      await storage.ref("$storageFolder/$filename").putFile(file);
    } on firebase_core.FirebaseException catch (error) {
      print(error);
    }
  }

  Future<firebase_storage.ListResult> listFiles(String storageFolder) async {
    firebase_storage.ListResult result =
        await storage.ref(storageFolder).listAll();
    for (var element in result.items) {
      print(element);
    }
    return result;
  }

  Future<String> downloadURL(String imageName) async {
    if (imageName == "") {
      return "";
    }
    String downloadURL =
        await storage.ref("test_images/$imageName").getDownloadURL();
    return downloadURL;
  }
}
