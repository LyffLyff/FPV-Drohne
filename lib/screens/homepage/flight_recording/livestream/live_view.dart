import 'package:drone_2_0/data/providers/logging_provider.dart';
import 'package:drone_2_0/screens/homepage/flight_recording/livestream/stream_placeholder.dart';
import 'package:drone_2_0/screens/homepage/flight_recording/livestream/video_overlay.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';

VlcPlayerOptions _controllerOptions = VlcPlayerOptions(
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

class LiveView extends StatefulWidget {
  final String ipAdress;
  final int port;
  final String streamName;
  final double aspectRatio;

  const LiveView(
      {super.key,
      required this.ipAdress,
      required this.port,
      required this.streamName,
      required this.aspectRatio});

  @override
  State<LiveView> createState() => _LiveViewState();
}

class _LiveViewState extends State<LiveView> {
  late VlcPlayerController _videoPlayerController;
  double recordingTextOpacity = 0;
  DateTime lastRecordingShowTime = DateTime.now();
  bool isRecording = false;

  @override
  void initState() {
    super.initState();
    Logging.debug("LiveView Initializing");
    _videoPlayerController = VlcPlayerController.network(
      autoInitialize: true,
      "rtmp://${widget.ipAdress}:${widget.port}/${widget.streamName}",
      hwAcc: HwAcc.auto,
      autoPlay: true,
      options: _controllerOptions,
    );
    _videoPlayerController.addListener(listener);
  }

  void listener() {
    if (!mounted) return;
    //
    if (_videoPlayerController.value.hasError) {
      Logging.error(_videoPlayerController.value.errorDescription);
    }
    if (_videoPlayerController.value.playingState == PlayingState.initialized) {
      setState(() {});
    }
    Logging.info(_videoPlayerController.value.playingState);
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
    if (_videoPlayerController.value.isInitialized) {
      await _videoPlayerController.stopRendererScanning();
      await _videoPlayerController.dispose();
    }
  }

  Future<void> _togglePlaying() async {
    _videoPlayerController.value.isPlaying
        ? await _videoPlayerController.pause()
        : await _videoPlayerController.play();
  }

  @override
  Widget build(BuildContext context) {
    if (!_videoPlayerController.value.isInitialized) {
      Logging.debug("LiveView not Initialized -> ${widget.ipAdress}");
      return const Center(
        child: SizedBox(
          height: 300,
          child: Stack(
            children: [
              LivestreamPlaceholder(),
              VideoOverlay(),
            ],
          ),
        ),
      );
    }
    Logging.debug(
        "PLAYER Initialized -> Loading Stream: ${widget.ipAdress}:${widget.port}");
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: MediaQuery.sizeOf(context).width,
          height: 320,
          child: Stack(
            children: [
              VlcPlayer(
                controller: _videoPlayerController,
                aspectRatio: widget.aspectRatio,
                placeholder: const LivestreamPlaceholder(),
              ),
              const VideoOverlay(),
            ],
          ),
        ),
        const Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              color: Colors.white,
              icon: _videoPlayerController.value.isPlaying
                  ? const Icon(Icons.pause_circle_outline)
                  : const Icon(Icons.play_circle_outline),
              onPressed: () async {
                await _togglePlaying();
              },
            ),
            IconButton(
              iconSize: 24,
              onPressed: () {
                Logging.info("Starting to record");
              },
              icon: const Icon(Icons.screenshot_monitor_rounded),
            ),
            IconButton(
              onPressed: () {
                _togglePlaying();
              },
              icon: const Icon(Icons.screenshot_monitor_rounded),
            ),
          ],
        )
      ],
    );
  }
}
