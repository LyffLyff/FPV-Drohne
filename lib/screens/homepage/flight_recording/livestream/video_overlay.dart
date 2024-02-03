import 'package:drone_2_0/screens/homepage/flight_recording/livestream/overlay_text.dart';
import 'package:flutter/material.dart';

class VideoOverlay extends StatelessWidget {
  const VideoOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              OverlayText(
                text: "TOP LEFT",
              ),
              OverlayText(
                text: "TOP RIGHT",
              ),
            ],
          ),
          Spacer(),
          Row(
            children: [
              Spacer(),
              Column(
                children: [
                  OverlayText(
                    text: " -",
                  ),
                  OverlayText(
                    text: "--",
                  ),
                  OverlayText(
                    text: " -",
                  ),
                  OverlayText(
                    text: " -",
                  ),
                  OverlayText(
                    text: "--",
                  ),
                  OverlayText(
                    text: " -",
                  ),
                ],
              ),
              Spacer(
                flex: 8,
              ),
              Column(
                children: [
                  OverlayText(
                    text: "- ",
                  ),
                  OverlayText(
                    text: "--",
                  ),
                  OverlayText(
                    text: "- ",
                  ),
                  OverlayText(
                    text: "- ",
                  ),
                  OverlayText(
                    text: "--",
                  ),
                  OverlayText(
                    text: "- ",
                  ),
                ],
              ),
              Spacer(),
            ],
          ),
          Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              OverlayText(
                text: "BOTTOM LEFT",
              ),
              OverlayText(
                text: "BOTTOM RIGHT",
              ),
            ],
          ),
        ],
      ),
    );
  }
}
