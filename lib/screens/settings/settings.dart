import 'package:drone_2_0/themes/theme_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeManager>(builder: (_, themeManager, __) => Scaffold(
      appBar: AppBar(
        title: Text("Help"),
      ),
      body: Column(
        children: [
          TextButton(child: Text("Toggle Theme"), onPressed: () {
            print("Toggling ");
            themeManager.toggleTheme();
          },)
        ],
      ),
    ),
    );
  }
}