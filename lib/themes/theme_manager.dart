import 'package:drone_2_0/service/settings_service.dart';
import 'package:flutter/material.dart';

class ThemeManager extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.dark; // default is dark mode
  bool _isDark = true;

  get themeMode => _themeMode;
  get isDark => _isDark;

  Future<void> initThemeSettings(String userId) async {
    // Load data from the database here, e.g., using async/await
    // Replace this with your database query code
    final value = await SettingsService()
        .fetchSingleSetting(userId: userId, settingKey: "isDark");
    if (value == "invalid key" || value == null) {
      return;
    }
    _isDark = value;
    setTheme(_isDark);
  }

  setTheme(bool toggle) {
    _themeMode = toggle ? ThemeMode.dark : ThemeMode.light;
    _isDark = toggle;
    notifyListeners();
  }

  toggleTheme() {
    _isDark = !_isDark;
    setTheme(_isDark);
  }

  String getLogoPath() {
    return _isDark
        ? "assets/images/logo_light.png"
        : "assets/images/logo_dark.png";
  }

  String getWeatherIconPath() {
    return _isDark
        ? "assets/images/weather_icons/light/"
        : "assets/images/weather_icons/dark/";
  }
}
