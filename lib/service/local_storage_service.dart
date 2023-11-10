import 'dart:convert';
import 'dart:io';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';

class LocalStorageService {
  Future<String> get _localPath async {
    // get app data directory
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> _getLocalFile(String fileName) async {
    final path = await _localPath;
    return File('$path/$fileName');
  }

  Future<File> writeFile(dynamic data, String filename) async {
    final file = await _getLocalFile(filename);

    // Write the file
    return file.writeAsString(jsonEncode(data));
  }

  Future<dynamic> readFile(String fileName) async {
    try {
      final file = await _getLocalFile(fileName);

      Logger().i(file.path);

      // Read the file
      final contents = await file.readAsString();

      return jsonDecode(contents);  // returning content as String -> parsing after that
    } catch (e) {
      // If encountering an error, return empty String
      return null;
    }
  }
}
