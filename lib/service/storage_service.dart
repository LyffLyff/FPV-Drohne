import 'dart:io';
import 'package:drone_2_0/data/providers/logging_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_core/firebase_core.dart' as firebase_core;

class StorageService {
  final firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  Future<void> uploadFile(
      String storageFolder, String filepath, String filename) async {
    File file = File(filepath); // convert filepath to file object

    try {
      await storage.ref("$storageFolder/$filename").putFile(file);
    } on firebase_core.FirebaseException catch (error) {
      Logging.error(error);
    } catch (e) {
      Logging.error(e.toString());
    }
  }

  Future<firebase_storage.ListResult> listFiles(String storageFolder) async {
    firebase_storage.ListResult result =
        await storage.ref(storageFolder).listAll();
    Logging.info(result.items.toString());
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
      Logging.error(e);
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
      Logging.error(e);
    } catch (e) {
      Logging.error(e);
    }
    return "https://source.unsplash.com/random/?otter";
  }
}
