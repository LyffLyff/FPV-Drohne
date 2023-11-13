import 'package:drone_2_0/extensions/extensions.dart';
import 'package:drone_2_0/widgets/utils/helper_widgets.dart';
import 'package:flutter/material.dart';

class GeneralFlightData extends StatelessWidget {
  final int timestamp;
  final int durationInSeconds;

  const GeneralFlightData(
      {super.key, required this.timestamp, required this.durationInSeconds});

  BoxDecoration _getRectangleDecoration(BuildContext context) {
    return BoxDecoration(
        color: context.canvasColor,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(16));
  }

  String _getFormattedDate() {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    return "${dateTime.day}/${dateTime.month}/${dateTime.year}";
  }

  String _getFormattedDuration() {
    if (durationInSeconds < 60) {
      return "${durationInSeconds}sec";
    } else if (durationInSeconds < 60 * 60) {
      return "${durationInSeconds / 60}min ${durationInSeconds % 60}sec";
    } else {
      return "${durationInSeconds / 3600}h ${durationInSeconds % 60}min";
    }
  }

  @override
  Widget build(BuildContext context) {
    TextStyle? textStyle = context.textTheme.bodyMedium;
    const double infoPadding = 4;
    const double infoBoxHeight = 8 * 13;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(width: 4, color: context.canvasColor),
          ),
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Center(
              child: Icon(
                Icons.cloud,
                size: MediaQuery.sizeOf(context).width * 0.45,
                color: context.primaryColor,
              ),
            ),
          ),
        ),
        const VerticalSpace(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(infoPadding),
                child: DecoratedBox(
                  decoration: _getRectangleDecoration(context),
                  child: SizedBox(
                    height: infoBoxHeight,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
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
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(infoPadding),
                child: DecoratedBox(
                  decoration: _getRectangleDecoration(context),
                  child: SizedBox(
                    height: infoBoxHeight,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
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
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
