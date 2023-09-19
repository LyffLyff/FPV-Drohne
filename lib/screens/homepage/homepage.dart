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

  final _pages = <Widget>[
    const FlightRecords(),
    const LiveView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const NavDrawer(),
      appBar: AppBar(
        title: const Text("FPV-Drohne",),
      ),
      bottomNavigationBar: Container(
        color: Colors.grey.shade900,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          child: GNav(
            // Style
            activeColor: Colors.white,
            style: GnavStyle.google,
            iconSize: 28,
            tabBackgroundColor: Colors.grey.shade800,
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
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
        ),
      ),
      body: IndexedStack(
        index: currentPageIdx,
        children: _pages,
      ),
    );
  }
}
