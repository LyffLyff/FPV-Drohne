import 'package:drone_2_0/extensions/extensions.dart';
import 'package:drone_2_0/widgets/loading_icons.dart';
import 'package:drone_2_0/widgets/utils/helper_widgets.dart';
import 'package:flutter/material.dart';

class DroneNotConnected extends StatelessWidget {
  const DroneNotConnected({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      icon: const Icon(
        Icons.sensors_rounded,
        size: 64,
      ),
      title: const Text(
        'Drone available',
        textAlign: TextAlign.center,
      ),
      content: Text(
        'Check if the Drone and the corresponding Box is turned on and properly initialized.\nIf the Problem consists check the Help section in the Side menu for further information',
        style: context.textTheme.bodySmall,
        textAlign: TextAlign.center,
      ),
      actions: const <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Column(
            children: [
              Text("Waiting for Connection..."),
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
