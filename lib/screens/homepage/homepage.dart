import 'package:drone_2_0/data/providers/auth_provider.dart';
import 'package:drone_2_0/data/providers/logging_provider.dart';
import 'package:drone_2_0/extensions/extensions.dart';
import 'package:drone_2_0/screens/homepage/3d_rotation/drone_model_viewer.dart';
import 'package:drone_2_0/screens/homepage/connection_dialogues/drone_not_connected.dart';
import 'package:drone_2_0/screens/homepage/connection_dialogues/drone_offline.dart';
import 'package:drone_2_0/screens/homepage/flight_recording/flight_data_recording/finished_flight.dart';
import 'package:drone_2_0/screens/homepage/flight_recording/flight_data_recording/flight_data.dart';
import 'package:drone_2_0/screens/homepage/floating_center_menu.dart';
import 'package:drone_2_0/screens/homepage/homepage_tabs.dart';
import 'package:drone_2_0/screens/homepage/ip_dialogue.dart';
import 'package:drone_2_0/screens/homepage/special/special_screen.dart';
import 'package:drone_2_0/screens/settings/app_settings.dart';
import 'package:drone_2_0/service/realtime_db_service.dart';
import 'package:drone_2_0/themes/theme_manager.dart';
import 'package:drone_2_0/widgets/animations/animation_routes.dart';
import 'package:drone_2_0/widgets/loading_icons.dart';
import 'package:drone_2_0/widgets/side_menu.dart';
import 'package:flutter/material.dart';
import 'package:drone_2_0/screens/homepage/flight_recording/flight_data_recording/flight_records.dart';
import 'package:drone_2_0/screens/homepage/flight_recording/livestream/live_view.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  static String id = 'homepage';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentPageIdx = 0;
  bool ipAdressSelected = false;
  bool droneFlight = false;
  bool isOnline = false;
  RealtimeDatabaseService rtdbService = RealtimeDatabaseService();

  // Server Config
  String ipAdress = "";
  int mqttPort = 0;
  int videoPort = 0;

  FlightData flightData = FlightData();

  @override
  void initState() {
    super.initState();
    colorSettings(context.read<ThemeManager>().isDark);
  }

  @override
  void dispose() {
    super.dispose();

    // at the end set -> "is_connected" to false since collecting data isn't possible when app closed
    rtdbService.updateData("", {"is_connected": true});
  }

  void _stopRecording() async {
    int endTimestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    if (flightData.finishFlight(
        endTimestamp, FlightRecordingFinishType.manual, context)) {
      Navigator.of(context).push(
        pageRouteAnimation(
          FinishedFlight(
            endTimestamp: endTimestamp,
          ),
        ),
      );
    }
    flightData = FlightData();
    droneFlight = false;
    ipAdressSelected = false;
  }

  void _startRecording() async {
    // Set is_connected on database to -> "true"
    rtdbService.updateData("", {"is_connected": true});
    droneFlight = true;
  }

  void _onInitDialogueDataEntered(
      String ipAdress, String mqttPort, String videoPort) {
    Logging.info("Server Data Entered -> Show Homepage");
    Logging.info("ENTERED CONFIG: $ipAdress  $mqttPort  $videoPort");
    setState(() {
      this.ipAdress = ipAdress;
      this.mqttPort = int.tryParse(mqttPort) ?? 1883;
      this.videoPort = int.tryParse(videoPort) ?? 1935;
      ipAdressSelected = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const NavDrawer(),
      appBar: AppBar(
        elevation: 0.0, // remove shadow
        title: const Text(
          "FPV-Drone",
        ),
        centerTitle: true,
      ),
      bottomNavigationBar: Visibility(
        visible: ipAdressSelected,
        child: GNav(
          // Style
          style: GnavStyle.google,
          iconSize: 28,
          tabBackgroundColor: context.hoverColor,
          tabMargin: const EdgeInsets.symmetric(
              vertical: 5), // setting the space between buttons and end of bar
          padding: const EdgeInsets.symmetric(
              horizontal: 5,
              vertical: 10), // setting thickness of button and bar in general
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          gap: 10,

          // Function
          selectedIndex: currentPageIdx,
          tabs: const [
            GButton(
              icon: Icons.data_exploration,
              text: "Flight Records",
            ),
            GButton(
              icon: Icons.rotate_right_outlined,
              text: "3D-Space",
            ),
            GButton(
              icon: Icons.video_camera_back,
              text: "Live View",
            ),
          ],

          onTabChange: (value) {
            setState(() {
              currentPageIdx = value;
            });
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onLongPress: () {
            Navigator.of(context).push(
              pageRouteAnimation(
                const SpecialScreen(),
              ),
            );
          },
          child: StreamBuilder(
            stream: RealtimeDatabaseService().listenToValue("is_online"),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const CircularLoadingIcon();
              }
              isOnline = (snapshot.data!.snapshot.value as bool?)!;
              if (isOnline == false) {
                if (droneFlight) {
                  // stopping the recording of the flight if the drone suddenly looses connection
                  // -> "is_online" is set to false by drone not the user
                  _stopRecording();
                  ipAdressSelected = false;
                }
                return const DroneOffline();
              }

              // drone flag "is_online" -> checked -> ready to connect
              return Stack(
                children: [
                  StreamBuilder<dynamic>(
                    stream:
                        RealtimeDatabaseService().listenToValue("is_connected"),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const CircularLoadingIcon();
                      }
                      // check if drone is connected -> flag in RTDB
                      var isConnected = snapshot.data.snapshot.value;
                      if (isConnected) {
                        // Show Server Dialogue for Ip and Port Configuration
                        if (!ipAdressSelected) {
                          return IpDialogue(
                            onDataEntered: _onInitDialogueDataEntered,
                            ipAdressController: TextEditingController(),
                            mqttPortController: TextEditingController(),
                            videoPortController: TextEditingController(),
                          );
                        }

                        // Start collecting Flight Data
                        flightData.startFlight(
                            context.read<AuthenticationProvider>().userId,
                            DateTime.now().millisecondsSinceEpoch);

                        // Display Realtime Data
                        return HomePageTabs(
                          currentPageIdx: currentPageIdx,
                          pages: <Widget>[
                            FlightRecords(
                              flightData: flightData,
                              ipAdress: ipAdress,
                              port: mqttPort,
                            ),
                            DroneModelViewer(
                              title: "Drone",
                              ipAdress: ipAdress,
                              port: mqttPort,
                            ),
                            LiveView(
                                ipAdress: ipAdress,
                                port: videoPort,
                                streamName: "live/stream",
                                aspectRatio: 4 / 3),
                          ],
                        );
                      } else {
                        return const DroneNotConnected();
                      }
                    },
                  ),
                  FloatingCenterMenu(
                    startRecording: _startRecording,
                    stopRecording: _stopRecording,
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
