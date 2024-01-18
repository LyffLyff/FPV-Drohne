import 'package:flutter/material.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:logger/logger.dart';

VlcPlayerOptions controllerOptions = VlcPlayerOptions(
  advanced: VlcAdvancedOptions([
    VlcAdvancedOptions.networkCaching(300),
  ]),
  rtp: VlcRtpOptions([
    // got the feeling with it, it runs smoother
    VlcRtpOptions.rtpOverRtsp(true),
  ]),
  video: VlcVideoOptions([
    VlcVideoOptions.dropLateFrames(false), // better late than never
    VlcVideoOptions.skipFrames(
        true), // never drop any image received -> else sometimes playing audio without video
  ]),
);

final VlcPlayerController _videoPlayerController = VlcPlayerController.network(
  autoInitialize: true,
  "rtmp://192.168.0.105:554/live/stream",
  hwAcc: HwAcc.full,
  autoPlay: false,
  options: controllerOptions,
);

class LiveView extends StatefulWidget {
  const LiveView({super.key});

  @override
  State<LiveView> createState() => _LiveViewState();
}

class _LiveViewState extends State<LiveView> {
  double recordingTextOpacity = 0;
  DateTime lastRecordingShowTime = DateTime.now();
  bool isRecording = false;

  @override
  void initState() {
    super.initState();
    _videoPlayerController.addListener(listener);
  }

  void listener() {
    if (!mounted) return;
    //
    if (_videoPlayerController.value.isInitialized) {
      // update recording blink widget
      if (_videoPlayerController.value.isRecording &&
          _videoPlayerController.value.isPlaying) {
        if (DateTime.now().difference(lastRecordingShowTime).inSeconds >= 1) {
          setState(() {
            lastRecordingShowTime = DateTime.now();
            recordingTextOpacity = 1 - recordingTextOpacity;
          });
        }
      } else {
        setState(() => recordingTextOpacity = 0);
      }
      // check for change in recording state
      if (isRecording != _videoPlayerController.value.isRecording) {
        setState(() => isRecording = _videoPlayerController.value.isRecording);
        if (!isRecording) {
          // IMPLEMENT STOP RECORDING
          _videoPlayerController.value.recordPath;
        }
      }
    }
  }

  @override
  void dispose() async {
    super.dispose();
  }

  Future<void> _togglePlaying() async {
    _videoPlayerController.value.isPlaying
        ? await _videoPlayerController.pause()
        : await _videoPlayerController.play();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        VlcPlayer(
          controller: _videoPlayerController,
          aspectRatio: 4 / 3,
          placeholder: SizedBox(
            width: MediaQuery.sizeOf(context).width,
            height: 300,
            child: const DecoratedBox(
                decoration: BoxDecoration(
                    shape: BoxShape.rectangle, color: Colors.black),
                child: Center(child: Text("Error Opening Livestream :("))),
          ),
        ),
        Row(
          children: [
            IconButton(
              color: Colors.white,
              icon: _videoPlayerController.value.isPlaying
                  ? const Icon(Icons.pause_circle_outline)
                  : const Icon(Icons.play_circle_outline),
              onPressed: _togglePlaying,
            ),
            IconButton(
                onPressed: () {
                  Logger().i("Print PRESSED");
                },
                icon: const Icon(Icons.screenshot_monitor_rounded)),
          ],
        )
      ],
    );
  }
}
