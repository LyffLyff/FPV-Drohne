import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:logger/logger.dart';

class StorageService {
  final firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  Future<void> uploadFile(
      String storageFolder, String filepath, String filename) async {
    File file = File(filepath); // convert filepath to file object

    try {
      await storage.ref("$storageFolder/$filename").putFile(file);
    } on firebase_core.FirebaseException catch (error) {
      Logger().e(error);
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

  Future<bool> fileExists(firebase_storage.Reference fileRef) async {
    final results = await fileRef.listAll();
    return results.items.isNotEmpty;
  }

  Future<void> deleteFile(String storagePath) async {
    final fileRef = storage.ref(storagePath);

    try {
      await fileRef.delete();
    } on FirebaseException catch (e) {
      Logger().e(e);
    }
    /*if (await fileExists(fileRef))  {
    }*/
  }

  Future<String> downloadURL(String storageURL) async {
    if (storageURL == "") return "";
    try {
      String downloadURL = await storage.ref(storageURL).getDownloadURL();
      return downloadURL;
    } on FirebaseException catch (e) {
      Logger().e(e);
    }
    return "https://source.unsplash.com/random/?otter";
  }
}
