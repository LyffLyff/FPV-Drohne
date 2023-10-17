import 'package:drone_2_0/extensions/extensions.dart';
import 'package:drone_2_0/widgets/side_menu.dart';
import 'package:flutter/material.dart';
import 'package:drone_2_0/screens/homepage/flight_records.dart';
import 'package:drone_2_0/screens/homepage/live_view.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  static String id = 'homepage';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentPageIdx = 0;

  @override
  void initState() {
    super.initState();
  }

  final _pages = <Widget>[
    const FlightRecords(),
    const LiveView(),
  ];

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
        backgroundColor: context.appBarTheme.backgroundColor ??
            context.primaryColor,
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
      body: IndexedStack(
        index: currentPageIdx,
        children: _pages,
      ),
    );
  }
}
