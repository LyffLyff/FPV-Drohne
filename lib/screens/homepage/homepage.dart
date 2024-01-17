import 'package:drone_2_0/data/providers/auth_provider.dart';
import 'package:drone_2_0/extensions/extensions.dart';
import 'package:drone_2_0/screens/homepage/flight_recording/finished_flight.dart';
import 'package:drone_2_0/screens/homepage/flight_recording/flight_data.dart';
import 'package:drone_2_0/screens/homepage/floating_center_menu.dart';
import 'package:drone_2_0/screens/settings/app_settings.dart';
import 'package:drone_2_0/service/realtime_db_service.dart';
import 'package:drone_2_0/themes/theme_manager.dart';
import 'package:drone_2_0/widgets/animations/animation_routes.dart';
import 'package:drone_2_0/widgets/loading_icons.dart';
import 'package:drone_2_0/widgets/side_menu.dart';
import 'package:drone_2_0/widgets/utils/helper_widgets.dart';
import 'package:flutter/material.dart';
import 'package:drone_2_0/screens/homepage/flight_recording/flight_records.dart';
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
  bool droneFlight = false;
  FlightData flightData = FlightData();

  @override
  void initState() {
    super.initState();
    colorSettings(context.read<ThemeManager>().isDark);

    // init drone status
    _initConnectivity();
  }

  late final _pages = <Widget>[
    FlightRecords(flightData: flightData),
    const LiveView(
        ipAdress: "192.168.8.105",
        port: 554,
        streamName: "live/stream",
        aspectRatio: 4 / 3),
  ];

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
  }

  void _startRecording() async {
    // set flag on database
    RealtimeDatabaseService().updateData("", {"is_connected": true});
    droneFlight = true;
  }

  void _initConnectivity() async {}

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
      bottomNavigationBar: GNav(
        // Style
        backgroundColor:
            context.appBarTheme.backgroundColor ?? context.primaryColor,
        activeColor: context.primaryColor,
        color: context.disabledColor,
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
      body: Stack(children: [
        StreamBuilder(
            stream: RealtimeDatabaseService().listenToValue("is_online"),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                Object? isOnline = snapshot.data!.snapshot.value;
                print("Data: $isOnline");
                if (isOnline == true) {
                  // drone flag "is_online" -> checked -> ready to connect
                  return StreamBuilder<dynamic>(
                      stream: RealtimeDatabaseService()
                          .listenToValue("is_connected"),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          // check if drone is connected -> flag in RTDB
                          var val = snapshot.data.snapshot.value;
                          if (val == true) {
                            // Start collection data
                            flightData.startFlight(
                                context.read<AuthProvider>().userId,
                                DateTime.now().millisecondsSinceEpoch);

                            // display Data
                            return IndexedStack(
                              index: currentPageIdx,
                              children: _pages,
                            );
                          } else if (val == false) {
                            return AlertDialog(
                              icon: const Icon(
                                Icons.error_outline,
                                size: 56,
                              ),
                              title: const Text(
                                'Drone is not connected :(',
                                textAlign: TextAlign.center,
                              ),
                              content: Text(
                                'Check if the Drone and the corresponding Box is turned on and properly initialized.\nIf the Problem consists check the Help section in the Side menu for further information',
                                style: context.textTheme.bodySmall,
                              ),
                              actions: const <Widget>[
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 10),
                                  child: Column(
                                    children: [
                                      Text("Waiting for Connection..."),
                                      VerticalSpace(height: 10),
                                      CircularLoadingIcon(
                                        length: 20,
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            );
                          }
                        }
                        return const CircularLoadingIcon();
                      });
                } else {
                  if (droneFlight) {
                    // stopping the recording of the flight if the drone suddenly looses connection
                    // -> "is_online" is set to false by drone not the user
                    _stopRecording();
                  }
                  return const Center(child: Text("Drone not online"));
                }
              }
              return const Center(
                  child: Text("Connection Problems to Database"));
            }),
        FloatingCenterMenu(
          startRecording: _startRecording,
          stopRecording: _stopRecording,
        ),
      ]),
    );
  }
}
