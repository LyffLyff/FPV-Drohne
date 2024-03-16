import 'package:drone_2_0/data/providers/logging_provider.dart';
import 'package:drone_2_0/screens/general/error/failed_connection.dart';
import 'package:drone_2_0/screens/homepage/flight_recording/livestream/stream_placeholder.dart';
import 'package:drone_2_0/screens/homepage/flight_recording/livestream/video_overlay.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

VlcPlayerOptions _controllerOptions = VlcPlayerOptions(
  advanced: VlcAdvancedOptions([
    VlcAdvancedOptions.clockSynchronization(1),

    // no caching -> realtime image
    VlcAdvancedOptions.liveCaching(0),
    VlcAdvancedOptions.networkCaching(0),
    VlcAdvancedOptions.fileCaching(0),
  ]),
  rtp: VlcRtpOptions([
    // got the feeling with it, it runs smoother
    VlcRtpOptions.rtpOverRtsp(true),
  ]),
  video: VlcVideoOptions([
    VlcVideoOptions.dropLateFrames(true), // better late than never
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
  bool connectionError = false;

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

    // Defining the Function that is called as soon as anything changes on the Status of the Player
    _videoPlayerController.addListener(listener);
  }

  void listener() {
    if (!mounted) return;

    // Checking an Error occurred
    if (_videoPlayerController.value.hasError) {
      Logging.error(_videoPlayerController.value.errorDescription);
    } else if (_videoPlayerController.value.playingState ==
        PlayingState.initialized) {
      setState(() {
        connectionError = false;
      });
    }
    Logging.info(_videoPlayerController.value.playingState);
    if (_videoPlayerController.value.isInitialized) {
      if (_videoPlayerController.value.isRecording &&
          _videoPlayerController.value.isPlaying) {
        // Hochzählen einer Variable in Sekunden seit Start einer Aufnahme
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
    } else if (_videoPlayerController.value.playingState !=
        PlayingState.stopped) {
      setState(() {
        connectionError = true;
      });
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

  Future<void> takeScreenshot() async {
    Uint8List imageData = await _videoPlayerController.takeSnapshot();
    await ImageGallerySaver.saveImage(imageData);
  }

  @override
  Widget build(BuildContext context) {
    //Logging.debug("Reloading Stream: ${widget.ipAdress}:${widget.port}");
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: MediaQuery.sizeOf(context).width,
          height: 320,
          child: Stack(
            children: [
              connectionError
                  ? const ConnectionError()
                  : VlcPlayer(
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
              icon: _videoPlayerController.value.isPlaying
                  ? const Icon(Icons.pause_circle_outline)
                  : const Icon(Icons.play_circle_outline),
              onPressed: () async {
                await _togglePlaying();
              },
            ),
            IconButton(
              iconSize: 24,
              onPressed: () async {
                Logging.info("Taking Screenshot");
                await takeScreenshot();
              },
              icon: const Icon(Icons.screenshot_monitor_rounded),
            ),
          ],
        )
      ],
    );
  }
}
