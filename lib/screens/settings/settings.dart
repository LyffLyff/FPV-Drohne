import 'package:drone_2_0/data/providers/auth_provider.dart';
import 'package:drone_2_0/screens/settings/app_settings.dart';
import 'package:drone_2_0/service/settings_service.dart';
import 'package:drone_2_0/themes/theme_constants.dart';
import 'package:drone_2_0/themes/theme_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

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
                value: themeManager.isDark,
                title: const Text("Theme Mode"),
                subtitle: Text(
                  'Light/Dark Mode Toggle',
                  style: TextStyle(
                    color: Colors.blueGrey[600],
                  ),
                ),
                controlAffinity: ListTileControlAffinity.trailing,
                onChanged: ((value) {
                  themeManager.setTheme(value);
                  colorSettings(value);
                  SettingsService().addNewSettings(
                    userId: Provider.of<AuthenticationProvider>(context,
                            listen: false)
                        .userId,
                    settings: {
                      "isDark": themeManager.isDark,
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
