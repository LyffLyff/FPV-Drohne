import 'package:drone_2_0/extensions/extensions.dart';
import 'package:flutter/material.dart';

class GeneralFlightData extends StatelessWidget {
  final int timestamp;
  final int durationInSeconds;

  const GeneralFlightData(
      {super.key, required this.timestamp, required this.durationInSeconds});

  String _getFormattedDate() {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    return "${dateTime.day}/${dateTime.month}/${dateTime.year}";
  }

  String _getFormattedDuration() {
    if (durationInSeconds < 60) {
      return "${durationInSeconds}sec";
    }
    else if (durationInSeconds < 60 * 60) {
      return "${durationInSeconds / 60}min ${durationInSeconds % 60}sec"; 
    }
    else {
      return "${durationInSeconds / 3600}h ${durationInSeconds % 60}min"; 
    }
  }

  @override
  Widget build(BuildContext context) {
    TextStyle? textStyle = context.textTheme.bodyMedium;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Icon(
            Icons.cloud,
            size: MediaQuery.sizeOf(context).width * 0.5,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [
                Text(
                  "Recorded on:",
                  style: textStyle,
                ),
                Text(
                  _getFormattedDate(),
                  style: textStyle,
                ),
              ],
            ),
            Column(
              children: [
                Text(
                  "Duration:",
                  style: textStyle,
                ),
                Text(
                  _getFormattedDuration(),
                  style: textStyle,
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
