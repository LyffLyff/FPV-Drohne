import 'package:drone_2_0/extensions/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AwaitingConnection extends StatelessWidget {
  const AwaitingConnection({super.key});

  @override
  Widget build(BuildContext context) {
    bool toggle = false;
    return AlertDialog(
      icon: const Icon(
        Icons.wifi_channel_outlined,
        size: 32,
      ),
      title: Text(
        'Awaiting Connection.....',
        style: context.textTheme.bodyMedium,
        textAlign: TextAlign.center,
      )
          .animate(
            target: 0.5,
            onComplete: (controller) {
              toggle = !toggle;
              controller.repeat(reverse: toggle);
            },
          )
          .fadeOut(
            curve: Curves.easeInOutSine,
            duration: const Duration(seconds: 1),
          ),
    );
  }
}
