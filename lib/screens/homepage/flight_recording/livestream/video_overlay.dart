import 'package:drone_2_0/screens/homepage/flight_recording/livestream/overlay_text.dart';
import 'package:flutter/material.dart';

class VideoOverlay extends StatelessWidget {
  final double aspectRatio;
  final bool isFullscreen;
  const VideoOverlay(
      {super.key, required this.aspectRatio, required this.isFullscreen});

  double getPadding() {
    return 2;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: getPadding()),
      child: const Column(
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
