import 'package:drone_2_0/service/settings_service.dart';
import 'package:drone_2_0/themes/theme_constants.dart';
import 'package:drone_2_0/themes/theme_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/providers/user_model.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool darkMode = false;

  // Icon for Dark Mode Switch
  final MaterialStateProperty<Icon?> themeModeIcon =
      MaterialStateProperty.resolveWith<Icon?>(
    (Set<MaterialState> states) {
      if (states.contains(MaterialState.selected)) {
        return const Icon(Icons.check);
      }
      return const Icon(Icons.close);
    },
  );

  @override
  void initState() {
    super.initState();
    darkMode = Provider.of<ThemeManager>(context, listen: false).isDark;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeManager>(
      builder: (_, themeManager, __) => Scaffold(
        appBar: AppBar(
          title: const Text("Settings"),
        ),
        body: Container(
          margin: const EdgeInsets.all(Margins.stdMargin),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SwitchListTile.adaptive(
                value: darkMode,
                title: const Text("Theme Mode"),
                subtitle: Text('Light/Dark Mode Toggle',style: TextStyle(
              color: Colors.blueGrey[600],
            ),
            ),
            controlAffinity: ListTileControlAffinity.trailing,
                onChanged: ((value) {
                  setState(() {
                    darkMode = value;
                  });
                  themeManager.setTheme(value);
                  SettingsService().addNewSettings(
                      userEmail:
                          Provider.of<UserProvider>(context, listen: false)
                              .email,
                      settings: {"isDark": themeManager.isDark});
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
