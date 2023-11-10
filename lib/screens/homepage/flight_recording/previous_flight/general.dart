import 'package:flutter/material.dart';

class GeneralFlightData extends StatelessWidget {
  final int timestamp;
  final int durationInSeconds;

  const GeneralFlightData(
      {super.key, required this.timestamp, required this.durationInSeconds});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text("Recorded on:"),
        Text(timestamp.toString()),
        Text(timestamp.toString()),
        Text("Duration: ${durationInSeconds / 60}min"),
      ],
    );
  }
}
