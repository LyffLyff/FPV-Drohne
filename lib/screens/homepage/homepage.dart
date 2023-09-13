import 'package:drone_2_0/widgets/side_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:drone_2_0/screens/homepage/flight_records.dart';
import 'package:drone_2_0/screens/homepage/live_view.dart';
import 'package:drone_2_0/screens/homepage/welcome_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  
  static String id = 'homepage';  
  
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int current_page_idx = 1;

  final _pages = <Widget>[
    const WelcomePage(),
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
      body: _pages[current_page_idx],
      bottomNavigationBar: NavigationBar(
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.paragliding_outlined),
            label: "Welcome",
          ),
          NavigationDestination(
            icon: Icon(Icons.flight),
            label: "Flight Records",
          ),
          NavigationDestination(
            icon: Icon(Icons.live_tv),
            label: "Live View",
          ),
        ],
        onDestinationSelected: (int index) {
          // -> passes the index of the NavigationDestination within the NavigationDestinations list above
          // to make use of a stateful widget you need to add setState
          setState(() {
            current_page_idx = index;
          });
        },

        // highlights the button with the value of the current page value
        selectedIndex: current_page_idx,
      ),
    );
  }
}
