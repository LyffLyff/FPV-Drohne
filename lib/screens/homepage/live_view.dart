import 'package:flutter/material.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';

var initialized = false;

class LiveView extends StatelessWidget {
  LiveView({super.key});

  final VlcPlayerController _vlcViewController = VlcPlayerController.network(
    autoInitialize: true,
    "rtmp://192.168.8.107:554/live/stream",
    hwAcc: HwAcc.auto,
    autoPlay: true,
  );

  @override
  Widget build(BuildContext context) {
    if (!initialized) {
      // preventing multiple initialization -> error
      initialized = true;
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        VlcPlayer(
          controller: _vlcViewController,
          aspectRatio: 4 / 3,
          placeholder: const DecoratedBox(
              decoration: BoxDecoration(
                  shape: BoxShape.rectangle, color: Colors.black)),
        ),
      ],
    );
  }
}
