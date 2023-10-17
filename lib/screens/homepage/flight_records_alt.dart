import 'dart:async';
import 'dart:math';
import 'package:async/async.dart';
import 'package:drone_2_0/service/realtime_db_service.dart';
import 'package:drone_2_0/widgets/loading_icons.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:logger/logger.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/material.dart';

void main() => runApp(_MyApp());

class _MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: _StreamBuilderExample(),
    );
  }
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

Stream<List<ChartData>> generateData = (() async* {
  while (true) {
    await Future<void>.delayed(const Duration(milliseconds: 200));

    List<ChartData> data = [];
    Random random = Random();

    for (int i = 0; i <= 55; i++) {
      data.add(ChartData(i.toDouble(), random.nextDouble() * 100));
    }
    yield data;
  }
})();

class _StreamBuilderExample extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _StreamBuilderExampleState();
  }
}

class _StreamBuilderExampleState extends State<_StreamBuilderExample> {
  ChartSeriesController? _chartSeriesController;
  late List<ChartData> storedData = [];
  
  StreamSubscription<int>? _streamSubscription;
  final StreamController<int> _streamController = StreamController<int>();
  final List<ChartData> _streamValues = [];

  @override
  void initState() {
    super.initState();
    _streamSubscription = _streamController.stream.listen((data) {
       _chartSeriesController?.updateDataSource(
        addedDataIndexes: <int>[data],
        removedDataIndexes: <int>[0],
      );
        _streamValues.add(data as ChartData);
     
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chart Sample'),
      ),
      body: Center(
        child: StreamBuilder<List<ChartData>>(
          stream: generateData,
          builder: (
            BuildContext context,
            AsyncSnapshot<List<ChartData>> snapshot,
          ) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularLoadingIcon(),
                  Text(
                    'Data Loading',
                    style: TextStyle(color: Colors.black, fontSize: 24),
                  ),
                ],
              );
            } else if (snapshot.connectionState == ConnectionState.active ||
                snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                return const Text('Error');
              } else if (snapshot.hasData) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 40),
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(7)),
                  width: 960,
                  height: 360,
                  child: SfCartesianChart(
                    series: <ChartSeries>[
                      LineSeries<ChartData, double>(
                        onRendererCreated: (ChartSeriesController controller) {
                          _chartSeriesController = controller;
                        },
                        color: Colors.red,
                        animationDuration: 0,
                        dataSource: storedData,
                        xValueMapper: (ChartData data, _) => data.x,
                        yValueMapper: (ChartData data, _) => data.y,
                      ),
                    ],
                  ),
                );
              } else {
                return const Text('Empty data');
              }
            } else {
              return Text('State: ${snapshot.connectionState}');
            }
          },
        ),
      ),
    );
  }

  
  @override
  void dispose() {
    _streamSubscription?.cancel();
    _streamController.close();
    super.dispose();
  }
}

class ChartData {
  ChartData(this.x, this.y);

  final double x;
  final num y;
}
