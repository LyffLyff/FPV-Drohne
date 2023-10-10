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
      //systemNavigationBarColor: Colors.grey.shade900,
    );
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  }

  final _pages = <Widget>[
    const FlightRecords(),
    const LiveView(),
  ];

  Color getBarColor(isDarkMode) {
    return isDarkMode ? Colors.grey.shade900 : Colors.grey.shade400;
  }

  Color getBackgroundColor(isDarkMode) {
    return isDarkMode ? Colors.grey.shade900 : Colors.grey.shade400;
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Provider.of<ThemeManager>(context).isDark;
    return Scaffold(
      drawer: const NavDrawer(),
      appBar: AppBar(
        backgroundColor: getBarColor(isDarkMode),
        foregroundColor: isDarkMode ? Colors.white : Colors.black,
        title: const Text(
          "FPV-Drone",
        ),
        centerTitle: true,
      ),
      bottomNavigationBar: Container(
        color: getBarColor(isDarkMode),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          child: GNav(
            // Style
            activeColor: isDarkMode ? Colors.white : Colors.black,
            color: getBarColor(isDarkMode),
            style: GnavStyle.google,
            iconSize: 28,
            tabBackgroundColor: getBarColor(isDarkMode),
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
      backgroundColor: getBarColor(isDarkMode).withAlpha(128),
    );
  }
}
