import 'dart:async';
import 'dart:math';
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

final List<ChartData> chartData = [];
int timeAxisValue = 0;
int LastMeasurement = 1;
Timer? timer;
// Redraw the series with updating or creating new points by using this controller.
ChartSeriesController? _chartSeriesController;
// Count of type integer which binds as x value for the series
int count = 19;

 void _updateDataSource(Timer timer) {
      chartData.add(ChartData(count, _getRandomInt(10, 100)));
      if (chartData.length >= 50) {
        chartData.removeAt(0);
        _chartSeriesController?.updateDataSource(
          addedDataIndexes: <int>[chartData!.length - 1],
          removedDataIndexes: <int>[0],
        );
      } else {
        _chartSeriesController?.updateDataSource(
          addedDataIndexes: <int>[chartData!.length - 1],
        );
      }
      count = count + 1;
    
  }


  int _getRandomInt(int min, int max) {
    final Random random = Random();
    return min + random.nextInt(max - min);
  }


class FlightRecords extends StatelessWidget {
  const FlightRecords({super.key});

  ///Continously updating the data source based on timer

  ///Get the random data


  @override
  Widget build(BuildContext context) {
    timer = Timer.periodic(const Duration(milliseconds: 1000), _updateDataSource);
    return StreamBuilder(
        //stream: combinedStreams(),
        builder: (context, snapshot) {
         /* if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }*/

          // Extract data from the snapshot
          final data = snapshot.data;
          //final periodicValue = data['periodicValue'];
          //final firebaseData = data['firebaseData'];

          timeAxisValue++;

          /*if (periodicValue != null) {
            chartData.add(ChartData(timeAxisValue, LastMeasurement));
          } else if (firebaseData != null) {
            chartData.add(ChartData(timeAxisValue, firebaseData));
            LastMeasurement = firebaseData;
          }*/

          return SfCartesianChart(
              // Chart title
              title: ChartTitle(text: 'Current Velocity'),
              series: <LineSeries<ChartData, int>>[
                LineSeries<ChartData, int>(
                    onRendererCreated: (ChartSeriesController controller) {
                      // Assigning the controller to the _chartSeriesController.
                      _chartSeriesController = controller;
                    },
                    dataSource: chartData,
                    xValueMapper: (ChartData sales, _) => sales.x,
                    yValueMapper: (ChartData sales, _) => sales.y,
                    // Enable data label
                    dataLabelSettings: const DataLabelSettings(isVisible: true))
              ]);
        });
  }
}
