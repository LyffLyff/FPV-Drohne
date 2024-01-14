import 'package:drone_2_0/service/local_storage_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:logger/logger.dart';

VlcPlayerOptions controllerOptions = VlcPlayerOptions(
  advanced: VlcAdvancedOptions([
    VlcAdvancedOptions.clockSynchronization(0),
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
  const LiveView({super.key});

  @override
  State<LiveView> createState() => _LiveViewState();
}

class _LiveViewState extends State<LiveView> {
  late VlcPlayerController _videoPlayerController;
  PlayingState controllerState = PlayingState.ended;

  @override
  void initState() {
    super.initState();

    // initialize VLC Player Controller with RTMP Adress
    // ignore: prefer_conditional_assignment, unnecessary_null_comparison
    if (controllerState != PlayingState.initialized) {
      _videoPlayerController = VlcPlayerController.network(
        autoInitialize: true,
        "rtmp://192.168.8.111:554/live/stream",
        hwAcc: HwAcc.full,
        autoPlay: true,
        options: controllerOptions,
      );

      controllerState = PlayingState.initializing;

      _videoPlayerController.addOnInitListener(
        () {
          controllerState = PlayingState.initialized;
          Logger().i("VLC Player Initialized");
          // rebuild widget
          setState(() {});
          // Recording footage
          _videoPlayerController.startRecording(
              "${LocalStorageService().getLocalFile("recordings/")}");
        },
      );
    } else {
      Logger().i("Controller already initialized");
    }
  }

  @override
  void dispose() async {
    super.dispose();
    await _videoPlayerController.stopRendererScanning();
  }

  @override
  Widget build(BuildContext context) {
    switch (_videoPlayerController.value.playingState) {
      case PlayingState.error:
        Logger().i(_videoPlayerController.value.playingState);
      case PlayingState.initializing || PlayingState.buffering:
        Logger().i(_videoPlayerController.value.playingState);
      case PlayingState.initialized:
        return VlcPlayer(
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
        );
      default:
        Logger().i(_videoPlayerController.value.playingState);
    }
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
        IconButton(
            onPressed: () async {
              Logger().i(_videoPlayerController.value.playingState);
              Logger().i(_videoPlayerController.value.bufferPercent);
              Logger().i(_videoPlayerController.value.errorDescription);
              _videoPlayerController = VlcPlayerController.network(
                autoInitialize: true,
                "rtmp://192.168.8.111:554/live/stream",
                hwAcc: HwAcc.full,
                autoPlay: true,
                options: controllerOptions,
              );
              setState(() {
                controllerState = PlayingState.initialized;
              });
            },
            icon: const Icon(Icons.screenshot_monitor_rounded))
      ],
    );
  }
}
