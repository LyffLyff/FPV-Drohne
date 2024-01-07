import 'package:drone_2_0/extensions/extensions.dart';
import 'package:drone_2_0/screens/homepage/flight_recording/awaiting_connection_dialogue.dart';
import 'package:drone_2_0/screens/homepage/flight_recording/flight_data.dart';
import 'package:drone_2_0/service/mqtt_manager.dart';
import 'package:drone_2_0/widgets/utils/helper_widgets.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:async/async.dart';

class ChartData {
  ChartData(this.x, this.y);
  final int x;
  final num y;
}

final mqtt = MQTTManager("192.168.8.107", "test/temp");

Stream<dynamic> combinedStreams() {
  try {
    final mqttStream = mqtt.messageStream;
    final periodicStream = Stream<int>.periodic(
      const Duration(seconds: 1),
      (count) => count, // Emit the current count
    );
    final combinedStream = StreamGroup.merge([periodicStream, mqttStream]);

    return combinedStream.map((event) {
      if (event is int) {
        // If it's a periodic value, emit it as 'periodicValue'
        return {'periodicValue': event, 'mqttData': null};
      } else if (event is String) {
        // If it's a MQTT Event, extract the data and emit it as 'mqttData'
        return {'periodicValue': null, 'mqttData': int.parse(event)};
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

List<ChartData> chartData = [];
int timeAxisValue = 0;
num lastMeasurement = 1;

Future<Map> _initChartData() async {
  // Reading the initial value from the Database before listening to changes
  chartData = []; // reset data in init
  await mqtt.connect();
  mqtt.subscribeToTopic("test/temp");
  return {
    "velocity": 0,
  };
}

class FlightRecords extends StatelessWidget {
  final FlightData flightData;

  const FlightRecords({super.key, required this.flightData});

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

                  /*if (snapshot.connectionState == ConnectionState.waiting) {
                    return const AwaitingConnection();
                  }*/
                  if (!snapshot.hasData) {
                    return const AwaitingConnection();
                  }

                  // Extract data from the snapshot
                  final data = snapshot.data;
                  final periodicValue = data['periodicValue'];
                  final mqttData = data['mqttData'];

                  timeAxisValue++;

                  int timestamp = DateTime.now().millisecondsSinceEpoch;

                  if (periodicValue != null) {
                    chartData.add(ChartData(timeAxisValue, lastMeasurement));
                    flightData.addDatapoint(
                        timestamp, lastMeasurement.toInt(), -1, -1);
                  } else if (mqttData != null) {
                    chartData.add(ChartData(timeAxisValue, mqttData));
                    flightData.addDatapoint(timestamp, mqttData, -1, -1);
                    lastMeasurement = mqttData;
                  }

                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        SfCartesianChart(
                          // Chart title
                          title: ChartTitle(
                              text: 'Speed in meters per second',
                              textStyle: context.textTheme.bodyMedium),

                          // Style
                          primaryXAxis: NumericAxis(
                            name: "Time",
                            title: AxisTitle(text: "Seconds since start"),
                          ),
                          primaryYAxis: NumericAxis(
                            name: "Velocity",
                            title: AxisTitle(text: "Velocity in m/s"),
                          ),

                          // Data
                          series: <CartesianSeries>[
                            LineSeries<ChartData, int>(
                              dataSource: chartData,
                              xValueMapper: (ChartData time, _) => time.x,
                              yValueMapper: (ChartData velocity, _) =>
                                  velocity.y,
                              markerSettings: const MarkerSettings(
                                isVisible: true,
                                shape: DataMarkerType.circle,
                              ),
                            ),
                          ],
                        ),
                        const VerticalSpace(),
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: Colors.grey.shade900,
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.circular(16)),
                          child: Center(
                            child: RichText(
                              text: TextSpan(
                                style: context.textTheme.headlineLarge,
                                children: <TextSpan>[
                                  TextSpan(text: lastMeasurement.toString()),
                                  TextSpan(
                                    text: ' m/s',
                                    style: context.textTheme.headlineMedium,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
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
    );
  }
}
