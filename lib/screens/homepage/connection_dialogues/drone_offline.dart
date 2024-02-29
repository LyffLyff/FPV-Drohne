import 'package:drone_2_0/extensions/extensions.dart';
import 'package:drone_2_0/widgets/loading_icons.dart';
import 'package:drone_2_0/widgets/utils/helper_widgets.dart';
import 'package:flutter/material.dart';

class DroneOffline extends StatelessWidget {
  const DroneOffline({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      icon: const Icon(
        Icons.error_outline,
        size: 56,
      ),
      title: const Text(
        'Drone Offline',
        textAlign: TextAlign.center,
      ),
      content: Text(
        'Start the Ground Station by pressing the Button in the lower left Corner\nIf the problem persists take a look into the help section',
        style: context.textTheme.bodySmall,
        textAlign: TextAlign.center,
      ),
      actions: const <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Column(
            children: [
              Text("Awaiting the online signal...."),
              VerticalSpace(height: 8),
              CircularLoadingIcon(
                length: 24,
              ),
            ],
          ),
        )
      ],
    );
  }
}
