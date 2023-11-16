import 'package:drone_2_0/extensions/extensions.dart';
import 'package:flutter/material.dart';

class FloatingCenterMenu extends StatelessWidget {
  final VoidCallback stopRecording;
  final VoidCallback startRecording;

  const FloatingCenterMenu(
      {super.key, required this.stopRecording, required this.startRecording});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 20, // distance from bottom
      left: 0,
      right: 0,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          Container(
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(24),
              color: context.canvasColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.4),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children: [
                  IconButton.filled(
                    onPressed: () {
                      stopRecording();
                    },
                    icon: const Icon(Icons.stop_rounded),
                  ),
                  IconButton.filled(
                    onPressed: () {
                      startRecording();
                    },
                    icon: const Icon(Icons.play_arrow_rounded),
                  ),
                ],
              ),
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
