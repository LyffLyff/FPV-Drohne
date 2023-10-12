import 'package:drone_2_0/themes/theme_manager.dart';
import 'package:drone_2_0/widgets/side_menu.dart';
import 'package:flutter/material.dart';
import 'package:drone_2_0/screens/homepage/flight_records.dart';
import 'package:drone_2_0/screens/homepage/live_view.dart';
import 'package:flutter/services.dart';
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

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.grey.shade900,
      ),
    );
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  }

  final _pages = <Widget>[
    const FlightRecords(),
    const LiveView(),
  ];

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Provider.of<ThemeManager>(context).isDark;
    return Scaffold(
      drawer: const NavDrawer(),
      appBar: AppBar(
        elevation: 0.0, // remove shadow
        title: const Text(
          "FPV-Drone",
        ),
        centerTitle: true,
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
        child: GNav(
          // Style
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor ?? Theme.of(context).primaryColor,
          activeColor: isDarkMode ? Colors.white : Colors.black,
          color: Theme.of(context).hintColor,
          style: GnavStyle.google,
          iconSize: 28,
          tabBackgroundColor: Theme.of(context).hoverColor,
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
      body: IndexedStack(
        index: currentPageIdx,
        children: _pages,
      ),
    );
  }
}
