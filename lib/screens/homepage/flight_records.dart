import 'dart:async';

import 'package:drone_2_0/service/realtime_db_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:async/async.dart';

class ChartData {
  ChartData(this.x, this.y);
  final int x;
  final int y;
}

Stream<dynamic> combinedStreams() {
  try {
    final DatabaseReference databaseRef =
        FirebaseDatabase.instance.ref("velocity");
    final Stream<DatabaseEvent> rtdbStream = databaseRef.onValue;
    final periodicStream = Stream<int>.periodic(
      const Duration(seconds: 1),
      (count) => count, // Emit the current count
    );
    final combinedStream = StreamGroup.merge([periodicStream, rtdbStream]);

    return combinedStream.map((event) {
      if (event is int) {
        // If it's a periodic value, emit it as 'periodicValue'
        return {'periodicValue': event, 'firebaseData': null};
      } else if (event is DatabaseEvent) {
        // If it's a Firebase Realtime Database event, extract the data and emit it as 'firebaseData'
        final dataSnapshot = event.snapshot;
        final firebaseData = dataSnapshot.value;
        return {'periodicValue': null, 'firebaseData': firebaseData};
      } else {
        // Handle other cases here or return null if not needed
        return null;
      }
    }).where((data) => data != null); // Filter out null values
  } on FirebaseException catch (e) {
    Logger().e(e);
    return const Stream.empty();
  }
}

Stream<DatabaseEvent> rtdbStream() {
  final DatabaseReference databaseRef =
      FirebaseDatabase.instance.ref("velocity");
  //StreamSubscription<DatabaseEvent> subscription = rtdbStream().listen((event) {
  //  Logger().i(event.snapshot.value);
  // });
  return databaseRef.onValue;
}

List<ChartData> chart_data = [];

class FlightRecords extends StatefulWidget {
  const FlightRecords({super.key});

  @override
  State<FlightRecords> createState() => _FlightRecordsState();
}

class _FlightRecordsState extends State<FlightRecords> {
  int _velocity = 0;
  late DatabaseReference _velocityRef;
  late StreamSubscription<DatabaseEvent> _velocitySubscription;

  bool initialized = false;
  FirebaseException? _error;

  @override
  void initState() {
    init();
    super.initState();
  }

  Future<void> init() async {
    _velocityRef = FirebaseDatabase.instance.ref('velocity');

    setState(() {
      initialized = true;
    });

    _velocitySubscription = _velocityRef.onValue.listen(
      (DatabaseEvent event) {
        setState(() {
          _error = null;
          _velocity = (event.snapshot.value ?? 0) as int;
        });
      },
      onError: (Object o) {
        final error = o as FirebaseException;
        setState(() {
          _error = error;
        });
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    _velocitySubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    if (!initialized) return const Text("Not Inited");
    return Center(
      child: Text(
        _velocity.toString(),
      ),
    );
  }
}
