import 'package:drone_2_0/screens/homepage/flight_recording/awaiting_connection_dialogue.dart';
import 'package:drone_2_0/screens/homepage/flight_recording/chart_data.dart';
import 'package:drone_2_0/screens/homepage/flight_recording/flight_data.dart';
import 'package:drone_2_0/screens/homepage/flight_recording/stream_displayer.dart';
import 'package:drone_2_0/service/mqtt_manager.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:async/async.dart';

enum MQTTData { identifier, value, timestamp }

Map<String, List<ChartData>> _emptyChartData = {
  "velocity": [],
  "height": [],
  "temperature": [],
};

class FlightRecords extends StatefulWidget {
  final FlightData flightData;

  const FlightRecords({
    super.key,
    required this.flightData,
  });

  @override
  State<FlightRecords> createState() => _FlightRecordsState();
}

class _FlightRecordsState extends State<FlightRecords> {
  final Logger logger = Logger();
  late final MQTTManager mqttManager;
  Map<String, List<ChartData>> chartData =
      Map.from(_emptyChartData); // copy of empty chart data
  int timeAxisValue = 0;
  num lastMeasurement = 1;
  int flightStartTimestamp = -1;
  List<dynamic> snapData = [];

  Stream<dynamic> _combinedStreams() {
    try {
      final mqttStream = mqttManager.messageStream;
      final combinedStream = StreamGroup.merge([mqttStream]);

      return combinedStream.map((event) {
        List<String> data = event.values.first.split(" ");
        List<dynamic> convertedData = [data[0]];
        convertedData.add(double.parse(data[1]));
        convertedData.add(int.parse(data[2]));
        return convertedData;
        // ignore: unnecessary_null_comparison
      }).where((data) => data != null); // Filter out null values
    } on FirebaseException catch (e) {
      Logger().e(e);
      return const Stream.empty();
    }
  }

  Future<void> initDataConnection() async {
    // Reading the initial value from the Database before listening to changes
    chartData = Map.from(_emptyChartData); // reset data in init
    await mqttManager.connect();

    // Subscribe to topics
    mqttManager.subscribeToTopic("data/velocity");
    mqttManager.subscribeToTopic("data/height");
    mqttManager.subscribeToTopic("data/temperature");
    logger.i("SUBSCRIBED TO TOPICS");
  }

  void limitDataPoints(String key) {
    chartData[key] = (chartData[key]!.length > 500
        ? chartData[key]!.sublist(chartData[key]!.length - 500)
        : chartData[key])!;
  }

  setData(String key, int xValue) {
    chartData[key]?.add(ChartData(xValue, snapData[MQTTData.value.index]));
    widget.flightData.addDatapoint(key, snapData[MQTTData.value.index], xValue);
    lastMeasurement = snapData[1];
    limitDataPoints(key);
  }

  @override
  void initState() {
    super.initState();

    // initialize mqtt manager class
    mqttManager = MQTTManager("192.168.8.111", 1883,
        "FPV-Drone-Applictation-${DateTime.now().toString()}");
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Column(
        children: [
          const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.speed)),
              Tab(icon: Icon(Icons.height_outlined)),
              Tab(icon: Icon(Icons.thermostat_rounded)),
            ],
          ),
          Expanded(
            child: FutureBuilder(
                future: initDataConnection(),
                builder: (context, AsyncSnapshot<void> snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return const AwaitingConnection();
                  }

                  // Widget return
                  return Column(
                    children: [
                      StreamBuilder(
                        stream: _combinedStreams(),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return Center(
                              child: Text('Error: ${snapshot.error}'),
                            );
                          }

                          if (!snapshot.hasData) {
                            return const Expanded(child: AwaitingConnection());
                          }

                          // Extract data from the snapshot
                          snapData = snapshot.data;

                          if (flightStartTimestamp == -1) {
                            flightStartTimestamp = snapData[2];
                          }
                          timeAxisValue = (snapData[2] - flightStartTimestamp);

                          switch (snapData[MQTTData.identifier.index]) {
                            case "V":
                              chartData["velocity"] =
                                  setData("velocity", timeAxisValue);
                            case "H":
                              setData("height", timeAxisValue);
                            case "T":
                              setData("temperature", timeAxisValue);
                          }

                          Logger().i(chartData["height"]?.length);

                          return Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TabBarView(
                                children: [
                                  StreamDisplay(
                                      title: "Velocity",
                                      xAxisName: "meters per second",
                                      yAxisName: "second since start",
                                      dataArray: chartData["velocity"] ?? [],
                                      lastMeasurement: lastMeasurement),
                                  StreamDisplay(
                                      title: "Height",
                                      xAxisName: "meters",
                                      yAxisName: "second since start",
                                      dataArray: chartData["height"] ?? [],
                                      lastMeasurement: lastMeasurement),
                                  StreamDisplay(
                                      title: "Temperature",
                                      xAxisName: "celsius",
                                      yAxisName: "second since start",
                                      dataArray: chartData["temperature"] ?? [],
                                      lastMeasurement: lastMeasurement),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  );
                }),
          ),
        ],
      ),
    );
  }
}
