import 'package:drone_2_0/service/auth/auth_service.dart';
import 'package:flutter/material.dart';

class ThemeManager extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.dark; // default is dark mode
  bool isInitialized = false;
  bool _isDark = false;

  get themeMode => _themeMode;
  get isDark => _isDark;

  Future<void> initThemeSettings(String userId) async {
    // Load data from the database here, e.g., using async/await
    // Replace this with your database query code
    final value = await AuthService().fetchSingleSetting(userId: userId, settingKey: "isDark");
    isInitialized = true;
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
    print("Theme is Dark: $_isDark");
  }
}
