import 'package:drone_2_0/data/providers/logging_provider.dart';
import 'package:drone_2_0/extensions/extensions.dart';
import 'package:drone_2_0/service/realtime_db_service.dart';
import 'package:flutter/material.dart';

class FloatingCenterMenu extends StatefulWidget {
  final VoidCallback stopRecording;
  final VoidCallback startRecording;
  final bool isConnected;

  const FloatingCenterMenu({
    super.key,
    required this.stopRecording,
    required this.startRecording,
    required this.isConnected,
  });

  @override
  State<FloatingCenterMenu> createState() => _FloatingCenterMenuState();
}

class _FloatingCenterMenuState extends State<FloatingCenterMenu> {
  bool isRecordingFlight = false;

  @override
  void initState() {
    initDroneConnection();
    super.initState();
  }

  void initDroneConnection() async {
    // initializing drone connection status variable
    await RealtimeDatabaseService().readValueOnce("is_connected").then((value) {
      Logging.info("is connected -> $value");
      setState(() {
        isRecordingFlight = value;
      });
    });
  }

  void toggleRecording() {
    // toggling flight recording via floating menu button
    if (isRecordingFlight) {
      widget.stopRecording();
    } else {
      widget.startRecording();
    }
    setState(() {
      isRecordingFlight = !isRecordingFlight;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 24, // distance from bottom
      left: 0,
      right: 0,
      child: Row(
        children: [
          const Spacer(flex: 24),
          Container(
            height: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: context.colorScheme.primary,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children: [
                  IconButton.filled(
                    style: ButtonStyle(
                      foregroundColor: MaterialStatePropertyAll(
                          context.colorScheme.onPrimary),
                      backgroundColor:
                          // hiding the background purple which is standard
                          const MaterialStatePropertyAll(Colors.transparent),
                    ),
                    iconSize: 24,
                    onPressed: () {
                      Logging.info("Toggle Recording");
                      toggleRecording();
                    },
                    icon: isRecordingFlight
                        ? const Icon(Icons.stop_rounded)
                        : const Icon(Icons.play_arrow_rounded),
                  ),
                ],
              ),
            ),
          ),
          const Spacer(flex: 1),
        ],
      ),
    );
  }
}
