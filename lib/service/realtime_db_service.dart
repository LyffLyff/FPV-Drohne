import 'dart:async';
import 'package:firebase_database/firebase_database.dart';

class RealtimeDatabaseService {
  final DatabaseReference ref = FirebaseDatabase.instance.ref();

  Future<void> setData(String path, Map<String, dynamic> data) async {
    // write to DB, setting NOT updating
    await ref.child(path).set(data);
  }

  Future<void> updateData(String path, Map<String, dynamic> data) async {
    // update values in DB
    await ref.child(path).update(data);
  }

  // reading data
  Stream<DatabaseEvent> listenToValue(String dbPath) {
    return ref.child(dbPath).onValue;
  }

  Future<dynamic> readValueOnce(String dbPath) async {
    final DataSnapshot snapshot = await ref.child(dbPath).get();
    return snapshot.value;
  }
}
