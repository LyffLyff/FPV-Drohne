import 'package:drone_2_0/extensions/extensions.dart';
import 'package:drone_2_0/service/realtime_db_service.dart';
import 'package:flutter/material.dart';

class FloatingCenterMenu extends StatefulWidget {
  final VoidCallback stopRecording;
  final VoidCallback startRecording;
  final bool droneOnline;

  const FloatingCenterMenu(
      {super.key,
      required this.stopRecording,
      required this.startRecording,
      required this.droneOnline});

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
      bottom: 20, // distance from bottom
      left: 0,
      right: 0,
      child: Row(
        children: [
          const Spacer(flex: 24),
          Container(
            height: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
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
                    iconSize: 24,
                    onPressed: () {
                      print("Toggle Recording");
                      if (!widget.droneOnline) {
                        // drone not online unable to start flight
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text(
                                'Cannot Record Flight without connection!'),
                            backgroundColor: Colors.red
                                .shade800, // Customize the background color if needed
                          ),
                        );
                        return;
                      }
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
