import 'dart:io';

import 'package:drone_2_0/data/providers/logging_provider.dart';
import 'package:drone_2_0/extensions/extensions.dart';
import 'package:drone_2_0/screens/general/error/failed_connection.dart';
import 'package:drone_2_0/screens/homepage/flight_recording/error_terminal.dart';
import 'package:drone_2_0/screens/homepage/flight_recording/flight_data_recording/awaiting_connection_dialogue.dart';
import 'package:drone_2_0/screens/homepage/flight_recording/flight_data_recording/chart_data.dart';
import 'package:drone_2_0/screens/homepage/flight_recording/flight_data_recording/flight_data.dart';
import 'package:drone_2_0/screens/homepage/flight_recording/flight_data_recording/stream_displayer.dart';
import 'package:drone_2_0/service/mqtt_manager.dart';
import 'package:flutter/material.dart';
import 'package:async/async.dart';

enum MQTTData { identifier, value, timestamp }

Map<String, List<ChartData>> _emptyChartData = {
  "voltage": [],
  "height": [],
  "temperature": [],
};

class FlightRecords extends StatefulWidget {
  FlightData flightData;
  final String ipAdress;
  final int port;

  FlightRecords({
    super.key,
    required this.flightData,
    required this.ipAdress,
    required this.port,
  });

  @override
  State<FlightRecords> createState() => _FlightRecordsState();
}

class _FlightRecordsState extends State<FlightRecords> {
  late final MQTTManager mqttManager;
  Map<String, List<ChartData>> chartData =
      Map.from(_emptyChartData); // copy of empty chart data
  int timeAxisValue = 0;
  num lastMeasurement = 1;
  int flightStartTimestamp = -1;
  List<dynamic> snapData = [];

  Stream<dynamic> _dataStreams() {
    try {
      final mqttStream = mqttManager.messageStream;
      final combinedStream = StreamGroup.merge([mqttStream]);

      return combinedStream.map((event) {
        List<String> data = event.values.first.split(" ");
        List<dynamic> convertedData = [data[MQTTData.identifier.index]];
        convertedData.add(double.parse(data[MQTTData.value.index]));
        convertedData.add(int.parse(data[MQTTData.timestamp.index]));
        return convertedData;
        // ignore: unnecessary_null_comparison
      }).where((data) => data != null); // Filter out null values
    } on SocketException catch (e) {
      Logging.error(e.toString());
      return const Stream.empty();
    }
  }

  Future<bool> initDataConnection() async {
    // reset data on init
    chartData = Map.from(_emptyChartData);
    widget.flightData = FlightData();

    bool connection = await mqttManager.connect();

    // Subscribe to topics
    if (connection) {
      mqttManager.subscribeToTopic("data/height");
      mqttManager.subscribeToTopic("data/temperature");
      mqttManager.subscribeToTopic("data/voltage");
      mqttManager.subscribeToTopic("data/messages");
      Logging.info("Subscribed to Flight Records MQTT Topics");
    }

    return connection;
  }

  void limitDataPoints(String key) {
    // limitiert eine Flugdaten-Map auf 500 Datenwerte -> Scrollende Diagramme
    int maxDataPoints = 500;
    chartData[key] = (chartData[key]!.length > maxDataPoints
        ? chartData[key]!.sublist(chartData[key]!.length - maxDataPoints)
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
    mqttManager = MQTTManager(widget.ipAdress, widget.port,
        "FPV-Drone-Applictation-${DateTime.now().toString()}");
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Column(
        children: [
          TabBar(
            tabs: [
              Tab(
                icon: Icon(
                  Icons.height_outlined,
                  color: context.colorScheme.onBackground,
                ),
              ),
              Tab(
                icon: Icon(
                  Icons.thermostat_rounded,
                  color: context.colorScheme.onBackground,
                ),
              ),
              Tab(
                icon: Icon(
                  Icons.battery_charging_full_rounded,
                  color: context.colorScheme.onBackground,
                ),
              ),
              Tab(
                icon: Icon(
                  Icons.terminal_rounded,
                  color: context.colorScheme.onBackground,
                ),
              ),
            ],
          ),
          Expanded(
            child: FutureBuilder(
                future: initDataConnection(),
                builder: (context, AsyncSnapshot<bool> snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return const AwaitingConnection();
                  } else if (snapshot.data == false) {
                    return const ConnectionError();
                  }

                  // Widget return
                  return Column(
                    children: [
                      StreamBuilder(
                        stream: _dataStreams(),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return const Expanded(
                              child: ConnectionError(),
                            );
                          }

                          if (!snapshot.hasData) {
                            return const Expanded(
                              child: AwaitingConnection(),
                            );
                          }

                          // Extract data from the snapshot
                          snapData = snapshot.data;

                          if (flightStartTimestamp == -1) {
                            flightStartTimestamp = snapData[2];
                          }
                          timeAxisValue = (snapData[2] - flightStartTimestamp);

                          switch (snapData[MQTTData.identifier.index]) {
                            case "V":
                              chartData["voltage"] =
                                  setData("voltage", timeAxisValue);
                            case "H":
                              setData("height", timeAxisValue);
                            case "T":
                              setData("temperature", timeAxisValue);
                          }

                          Logging.info(chartData["height"]!.length.toString());

                          return Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TabBarView(
                                children: [
                                  StreamDisplay(
                                    title: "Height",
                                    xAxisName: "meters",
                                    yAxisName: "seconds since start",
                                    dataArray: chartData["height"] ?? [],
                                    lastMeasurement: lastMeasurement,
                                    unit: 'm',
                                    maxY: 500,
                                    minY: 0,
                                  ),
                                  StreamDisplay(
                                    title: "Temperature",
                                    xAxisName: "celsius",
                                    yAxisName: "seconds since start",
                                    dataArray: chartData["temperature"] ?? [],
                                    lastMeasurement: lastMeasurement,
                                    unit: '°C',
                                    maxY: 60,
                                    minY: -10,
                                  ),
                                  StreamDisplay(
                                    title: "Spannung",
                                    xAxisName: "voltage",
                                    yAxisName: "seconds since start",
                                    dataArray: chartData["voltage"] ?? [],
                                    lastMeasurement: lastMeasurement,
                                    unit: 'V',
                                    maxY: 25,
                                    minY: 12,
                                  ),
                                  ErrorTerminal(
                                    mqttManager: mqttManager,
                                  ),
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
