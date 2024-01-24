import 'package:flutter/material.dart';

TextStyle _overlayStyle = const TextStyle(
  fontFamily: "VCR_OSD_Mono",
);

class VideoOverlay extends StatelessWidget {
  const VideoOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "TOP LEFT",
                style: _overlayStyle,
              ),
              Text(
                "TOP RIGHT",
                style: _overlayStyle,
              ),
            ],
          ),
          const Spacer(),
          const Row(
            children: [
              Spacer(),
              Column(
                children: [
                  Text(" -"),
                  Text("--"),
                  Text(" -"),
                  Text(" -"),
                  Text("--"),
                  Text(" -"),
                ],
              ),
              Spacer(
                flex: 8,
              ),
              Column(
                children: [
                  Text("- "),
                  Text("--"),
                  Text("- "),
                  Text("- "),
                  Text("--"),
                  Text("- "),
                ],
              ),
              Spacer(),
            ],
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "BOTTOM LEFT",
                style: _overlayStyle,
              ),
              Text(
                "BOTTOM RIGHT",
                style: _overlayStyle,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
