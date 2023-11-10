import 'package:drone_2_0/extensions/extensions.dart';
import 'package:flutter/material.dart';

class GeneralFlightData extends StatelessWidget {
  final int timestamp;
  final int durationInSeconds;

  const GeneralFlightData(
      {super.key, required this.timestamp, required this.durationInSeconds});

  @override
  Widget build(BuildContext context) {
    TextStyle? textStyle = context.textTheme.bodyLarge;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Recorded on:",
          style: textStyle,
        ),
        Text(
          timestamp.toString(),
          style: textStyle,
        ),
        Text(
          timestamp.toString(),
          style: textStyle,
        ),
        Text(
          "Duration: ${durationInSeconds / 60}min",
          style: textStyle,
        ),
      ],
    );
  }
}
