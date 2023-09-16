import 'package:drone_2_0/widgets/side_menu.dart';
import 'package:flutter/material.dart';
import 'package:drone_2_0/screens/homepage/flight_records.dart';
import 'package:drone_2_0/screens/homepage/live_view.dart';

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
        title: const Text("FPV-Drohne"),
      ),
      body: _pages[currentPageIdx],
      bottomNavigationBar: NavigationBar(
        indicatorColor: Colors.black12,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.video_camera_back),
            label: "Flight Records",
            
          ),
          NavigationDestination(
            icon: Icon(Icons.data_exploration_rounded),
            label: "Live View",
          ),
        ],
        onDestinationSelected: (int index) {
          // -> passes the index of the NavigationDestination within the NavigationDestinations list above
          // to make use of a stateful widget you need to add setState
          setState(() {
            currentPageIdx = index;
          });
        },

        // highlights the button with the value of the current page value
        selectedIndex: currentPageIdx,
      ),
    );
  }
}
