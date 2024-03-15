import 'package:drone_2_0/data/providers/auth_provider.dart';
import 'package:drone_2_0/data/providers/logging_provider.dart';
import 'package:drone_2_0/data/shared_preferences.dart';
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
import 'package:drone_2_0/data/app_settings.dart';
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
  bool isConnected = false;
  RealtimeDatabaseService rtdbService = RealtimeDatabaseService();

  // Server Config
  String ipAdress = "";
  int mqttPort = 0;
  int videoPort = 0;
  String videoProtocol = "";
  String videoApplicationName = "";
  String videoStreamKey = "";
  double videoAspectRatio = 4 / 3;

  FlightData flightData = FlightData();

  @override
  void initState() {
    super.initState();
    appNavigationColorSettings(context.read<ThemeManager>().isDark);
  }

  @override
  void dispose() {
    super.dispose();

    // at the end set -> "is_connected" to false since collecting data isn't possible when app closed
    _disconnectRTDBFlags(false);
  }

  void _stopRecording() async {
    int endTimestamp = DateTime.now().millisecondsSinceEpoch;
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

    _disconnectRTDBFlags(false);
  }

  void _disconnectRTDBFlags(bool toggle) {
    rtdbService.updateData("", {"is_connected": toggle});
    rtdbService.updateData("", {"server_selected": toggle});
  }

  void _startRecording() async {
    // Set is_connected on database to -> "true"
    rtdbService.updateData("", {"is_connected": true});
    droneFlight = true;
  }

  Future<void> _onInitDialogueDataEntered(
      String ipAdress,
      String mqttPort,
      String videoProtocol,
      String videoApplicationName,
      String videoStreamKey,
      String videoPort) async {
    Logging.info("Server Data Entered -> Show Homepage");
    Logging.info("ENTERED CONFIG: $ipAdress  $mqttPort  $videoPort");

    // Safe Data for later Sessions
    final SharedPrefs sharedPrefs = SharedPrefs();
    await sharedPrefs.saveText("serverIp", ipAdress);
    await sharedPrefs.saveText("mqttPort", mqttPort);
    await sharedPrefs.saveText("videoPort", videoPort);
    await sharedPrefs.saveText("videoProtocol", videoProtocol);
    await sharedPrefs.saveText("videoAppName", videoApplicationName);
    await sharedPrefs.saveText("videoStreamKey", videoStreamKey);

    // setting flag that sever was selected -> for bottom menu visibility
    rtdbService.updateData("", {"server_selected": true});

    // update data in homepage main screens
    setState(() {
      this.ipAdress = ipAdress;
      this.mqttPort = int.tryParse(mqttPort) ?? 1883;
      this.videoPort = int.tryParse(videoPort) ?? 1935;
      this.videoProtocol = videoProtocol;
      this.videoApplicationName = videoApplicationName;
      this.videoStreamKey = videoStreamKey;
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
      bottomNavigationBar: StreamBuilder<dynamic>(
        stream: rtdbService.listenToValue("server_selected"),
        builder: (context, snapshot) {
          bool visibility = ((snapshot.data?.snapshot.value ?? false) as bool);
          return Visibility(
            visible: visibility,
            child: GNav(
              // Style
              style: GnavStyle.google,
              iconSize: 28,
              tabBackgroundColor: context.colorScheme.secondary,
              tabMargin: const EdgeInsets.symmetric(
                  vertical:
                      5), // setting the space between buttons and end of bar
              padding: const EdgeInsets.symmetric(
                  horizontal: 5,
                  vertical:
                      8), // setting thickness of button and bar in general
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              gap: 8,

              // Function
              selectedIndex: currentPageIdx,
              tabs: [
                GButton(
                  icon: Icons.data_exploration,
                  text: "Flight Records",
                  iconColor: context.colorScheme.onBackground,
                  iconActiveColor: context.colorScheme.inversePrimary,
                ),
                GButton(
                  icon: Icons.rotate_right_outlined,
                  text: "3D-Space",
                  iconColor: context.colorScheme.onBackground,
                  iconActiveColor: context.colorScheme.inversePrimary,
                ),
                GButton(
                  icon: Icons.video_camera_back,
                  text: "Live View",
                  iconColor: context.colorScheme.onBackground,
                  iconActiveColor: context.colorScheme.inversePrimary,
                ),
              ],

              onTabChange: (value) {
                setState(() {
                  currentPageIdx = value;
                });
              },
            ),
          );
        },
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
            stream: rtdbService.listenToValue("is_online"),
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
                  setState(() {
                    ipAdressSelected = false;
                  });
                }
                return const DroneOffline();
              }

              // drone flag "is_online" -> checked -> ready to connect
              return Stack(
                children: [
                  StreamBuilder<dynamic>(
                    stream: rtdbService.listenToValue("is_connected"),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const CircularLoadingIcon();
                      }
                      // check if drone is connected -> flag in RTDB
                      isConnected = snapshot.data.snapshot.value;
                      if (isConnected) {
                        // Show Server Dialogue for Ip and Port Configuration
                        if (!ipAdressSelected) {
                          return IpDialogue(
                            onDataEntered: _onInitDialogueDataEntered,
                            ipAdressController: TextEditingController(),
                            mqttPortController: TextEditingController(),
                            videoPortController: TextEditingController(),
                            videoProtocolController: TextEditingController(),
                            videoAppNameController: TextEditingController(),
                            videoStreamKeyController: TextEditingController(),
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
                              aspectRatio: videoAspectRatio,
                              streamKey: videoStreamKey,
                              applicationName: videoApplicationName,
                              protocol: videoProtocol,
                            ),
                          ],
                        );
                      } else {
                        return const DroneNotConnected();
                      }
                    },
                  ),
                  FloatingCenterMenu(
                    isConnected: isConnected,
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
