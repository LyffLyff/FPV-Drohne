import 'package:drone_2_0/screens/homepage/flight_recording/awaiting_connection_dialogue.dart';
import 'package:drone_2_0/screens/homepage/flight_recording/chart_data.dart';
import 'package:drone_2_0/screens/homepage/flight_recording/flight_data.dart';
import 'package:drone_2_0/screens/homepage/flight_recording/stream_displayer.dart';
import 'package:drone_2_0/service/mqtt_manager.dart';
import 'package:drone_2_0/widgets/loading_icons.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:async/async.dart';

final _mqtt = MQTTManager("192.168.8.111", "data/velocity");

Stream<dynamic> _combinedStreams() {
  try {
    final mqttStream = _mqtt.messageStream;
    final periodicStream = Stream<int>.periodic(
      const Duration(seconds: 1),
      (count) => count, // Emit the current count
    );
    final combinedStream = StreamGroup.merge([periodicStream, mqttStream]);

    return combinedStream.map((event) {
      if (event is int) {
        // If it's a periodic value, emit it as 'periodicValue'
        return {'periodicValue': event};
      } else if (event is String) {
        // one of the data streams from MQTT -> velocity, height, temperature
        // first character defines type of data received: V, T, H,....
        print("MQTT EVENT $event");
        print("VALUE ${event.substring(1)}");
        num value = num.parse(event.substring(1));
        switch (event[0]) {
          case "T":
            return {"temperature": value};
          case "V":
            return {"velocity": value};
          case "H":
            return {"height": value};
        }
      }
      return null;
    }).where((data) => data != null); // Filter out null values
  } on FirebaseException catch (e) {
    Logger().e(e);
    return const Stream.empty();
  }
}

Map<String, List<ChartData>> emptyChartData = {
  "velocity": [],
  "height": [],
  "temperature": [],
};
Map<String, List<ChartData>> chartData =
    Map.from(emptyChartData); // copy of empty chart data
int timeAxisValue = 0;
num lastMeasurement = 1;

Future<Map> _initChartData() async {
  // Reading the initial value from the Database before listening to changes
  chartData = Map.from(emptyChartData); // reset data in init
  await _mqtt.connect();
  _mqtt.subscribeToTopic("data/velocity");
  //_mqtt.subscribeToTopic("data/height");
  //_mqtt.subscribeToTopic("data/temperature");
  return Map.from(emptyChartData);
}

class FlightRecords extends StatelessWidget {
  final FlightData flightData;

  const FlightRecords({super.key, required this.flightData});

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
              future: _initChartData(),
              builder: (context, AsyncSnapshot<Map> snapshot) {
                if (snapshot.hasData) {
                  //chartData.add(
                  //    ChartData(timeAxisValue, snapshot.data?["velocity"]));

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
                            return const Expanded(child: CircularLoadingIcon());
                          }

                          // Extract data from the snapshot
                          final Map data = snapshot.data;
                          final periodicValue = data['periodicValue'];

                          timeAxisValue++;

                          int timestamp = DateTime.now().millisecondsSinceEpoch;

                          if (periodicValue != null) {
                            chartData["velocity"]?.add(
                                ChartData(timeAxisValue, lastMeasurement));
                            flightData.addDatapoint(
                                timestamp, lastMeasurement.toInt(), -1, -1);
                          } else {
                            switch (data.keys.first) {
                              case "velocity":
                                chartData["velocity"]?.add(
                                    ChartData(timeAxisValue, data["velocity"]));
                                flightData.addDatapoint(
                                    timestamp, data["velocity"], -1, -1);
                                lastMeasurement = data["velocity"];
                              case "height":
                                chartData["velocity"]?.add(
                                    ChartData(timeAxisValue, data["velocity"]));
                              case "temperature":
                                chartData["velocity"]?.add(
                                    ChartData(timeAxisValue, data["velocity"]));
                            }
                          }

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
                } else {
                  return const AwaitingConnection();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
