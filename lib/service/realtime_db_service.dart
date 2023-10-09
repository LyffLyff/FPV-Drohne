import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/utils/stream_subscriber_mixin.dart';

class RealtimeDatabaseService {
  Future<void> setData(String path, Map<String, dynamic> data) async {
    final DatabaseReference ref = FirebaseDatabase.instance.ref(path);

    // write to DB, setting NOT updating
    await ref.set(data);
  }

  Future<void> updateData(String path, Map<String, dynamic> data) async {
    final DatabaseReference ref = FirebaseDatabase.instance.ref(path);

    // update values in DB
    await ref.update(data);
  }

  // reading data
  Stream<DatabaseEvent> fetchVelocity() {
    DatabaseReference velocityRef = FirebaseDatabase.instance.ref("velocity");
    return velocityRef.onValue;
  }
}
