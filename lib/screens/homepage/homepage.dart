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
    // TODO: implement initState
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
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
        title: const Text(
          "FPV-Drohne",
        ),
      ),
      bottomNavigationBar: Container(
        color: isDarkMode ? Colors.grey.shade900 : Colors.grey.shade100,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          child: GNav(
            // Style
            activeColor: isDarkMode ? Colors.white : Colors.black,
            color: isDarkMode ? Colors.white : Colors.grey.shade800,
            style: GnavStyle.google,
            iconSize: 28,
            tabBackgroundColor:
                isDarkMode ? Colors.grey.shade800 : Colors.grey.shade300,
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
