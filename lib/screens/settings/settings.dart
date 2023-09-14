import 'package:drone_2_0/themes/theme_constants.dart';
import 'package:drone_2_0/themes/theme_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeManager>(builder: (_, themeManager, __) => Scaffold(
      appBar: AppBar(
        title: const Text("General Settings"),
      ),
      body: Container(
        margin: const EdgeInsets.all(Margins.stdMargin),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(child: const Text("Toggle Theme"), onPressed: () {
              print("Toggling ");
              themeManager.toggleTheme();
            },)
          ],
        ),
      ),
    ),
    );
  }
}