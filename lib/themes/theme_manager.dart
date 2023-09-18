import 'package:drone_2_0/service/auth/auth_service.dart';
import 'package:flutter/material.dart';

class ThemeManager extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;
  bool isInitialized = false;
  bool _isDark = false;

  get themeMode => _themeMode;
  get isDark => _isDark;

  Future<void> initThemeSettings(String email) async {
    // Load data from the database here, e.g., using async/await
    // Replace this with your database query code
    final value = await AuthService().fetchSingleSetting(email: email, settingKey: "isDark");
    isInitialized = true;
    if (value == "invalid key") {
      return;
    }
    _isDark = value;
    print(_isDark);
    setTheme(_isDark);

    // Notify listeners that the data has been loaded
    notifyListeners();
  }

  setTheme(bool toggle) {
     _themeMode = toggle ? ThemeMode.dark : ThemeMode.light;
     notifyListeners();
  }

  toggleTheme() {
    _isDark = !_isDark;
    setTheme(_isDark);
    print("Theme is Dark: $_isDark");
  }
}
