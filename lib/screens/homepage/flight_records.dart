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
    final Stream<DatabaseEvent> velocityStream =
        RealtimeDatabaseService().listenToValue("velocity");
    final periodicStream = Stream<int>.periodic(
      const Duration(seconds: 1),
      (count) => count, // Emit the current count
    );
    final combinedStream = StreamGroup.merge([periodicStream, velocityStream]);

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

Future<Map> _initChartData() async {
  // Reading the initial value from the Database before listening to changes
  final ref = RealtimeDatabaseService();
  final int vel = await ref.readValueOnce("velocity");
  return {
    "velocity": vel,
  };
}

final List<ChartData> chartData = [];
int timeAxisValue = 0;
int lastMeasurement = 1;

class FlightRecords extends StatelessWidget {
  const FlightRecords({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initChartData(),
      builder: (context, AsyncSnapshot<Map> snapshot) {
        if (snapshot.hasData) {
          chartData.add(ChartData(timeAxisValue, snapshot.data?["velocity"]));

          // Widget return
          return Column(
            children: [
              StreamBuilder(
                stream: combinedStreams(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Expanded(
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }

                  // Extract data from the snapshot
                  final data = snapshot.data;
                  final periodicValue = data['periodicValue'];
                  final firebaseData = data['firebaseData'];

                  timeAxisValue++;

                  if (periodicValue != null) {
                    chartData.add(ChartData(timeAxisValue, lastMeasurement));
                  } else if (firebaseData != null) {
                    chartData.add(ChartData(timeAxisValue, firebaseData));
                    lastMeasurement = firebaseData;
                  }

                  return SfCartesianChart(
                    // Chart title
                    title: ChartTitle(
                        text: 'Current Velocity',
                        textStyle: Theme.of(context).textTheme.bodyMedium),
                    series: <LineSeries<ChartData, int>>[
                      LineSeries<ChartData, int>(
                          dataSource: chartData,
                          xValueMapper: (ChartData time, _) => time.x,
                          yValueMapper: (ChartData velocity, _) => velocity.y,
                          // Enable data label
                          dataLabelSettings:
                              const DataLabelSettings(isVisible: true))
                    ],
                  );
                },
              ),
            ],
          );
        } else {
          return const Center(
            child: CircularProgressIndicator.adaptive(),
          );
        }
      },
    );
  }
}
