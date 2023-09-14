// ignore_for_file: constant_identifier_names, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:syncfusion_flutter_gauges/gauges.dart';

const OPEN_WEATHER_MAP_API_KEY = "e25cb6c3122c44cece85d59ed6104436";
const LATITUDE_STAATZ = "48.676712";
const LONGITUDE_STAATZ = "16.483971";

double getTemperature(Map<String, dynamic> weatherData) {
  final temperature = weatherData['list'][0]['main']["temp"];
  return temperature.toDouble();
}

class FlightRecords extends StatefulWidget {
  const FlightRecords({super.key});

  @override
  State<FlightRecords> createState() => _FlightRecordsState();
}

class _FlightRecordsState extends State<FlightRecords> {
  double current_temperature = -1;

  Future<void> fetchWeatherData(String apiKey, String latitude, String longitude) async {
    try {
      final response = await http.get(Uri.parse(
          'https://api.openweathermap.org/data/2.5/forecast?lat=$latitude&lon=$longitude&units=metric&appid=$apiKey'));
      print(response.statusCode);
      if (response.statusCode == 200) {
        setState(() {
          current_temperature = getTemperature(json.decode(response.body));
        });
        return;
      } else {
        throw Exception('Failed to fetch weather data');
      }
    } catch (e) {
      print('Failed to fetch weather data: $e');
    }
  }

  void startTimer() {
    Timer.periodic(const Duration(seconds: 6), (Timer timer) {
      fetchWeatherData(
          OPEN_WEATHER_MAP_API_KEY, LATITUDE_STAATZ, LONGITUDE_STAATZ);
    });
  }

  @override
  void initState() {
    super.initState();
    startTimer();
    fetchWeatherData(
        OPEN_WEATHER_MAP_API_KEY, LATITUDE_STAATZ, LONGITUDE_STAATZ);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text("Flight Records", style: TextStyle(fontSize: 32),),
        SfRadialGauge(
          enableLoadingAnimation: true,
          axes: <RadialAxis>[
            RadialAxis(
              minimum: 0,
              maximum: 45,
              ranges: <GaugeRange>[
                GaugeRange(
                    startValue: 0,
                    endValue: 15,
                    color: Colors.green,
                    startWidth: 10,
                    endWidth: 10),
                GaugeRange(
                    startValue: 15,
                    endValue: 25,
                    color: Colors.orange,
                    startWidth: 10,
                    endWidth: 10),
                GaugeRange(
                    startValue: 25,
                    endValue: 45,
                    color: Colors.red,
                    startWidth: 10,
                    endWidth: 10)
              ],
              pointers: <GaugePointer>[
                NeedlePointer(value: current_temperature),
              ],
              annotations: <GaugeAnnotation>[
                GaugeAnnotation(
                    widget: Text(current_temperature.toString(),
                        style: const TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold)),
                    angle: 90,
                    positionFactor: 0.5)
              ],
            ),
          ],
        ),
        const Text("Current Temperature in Staatz", style: TextStyle(fontSize: 24),),
      ],
    );
  }
}
