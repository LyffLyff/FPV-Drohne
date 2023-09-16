import 'package:drone_2_0/service/auth/auth_service.dart';
import 'package:flutter/material.dart';

class ThemeManager extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;
  bool isInitialized = false;
  bool isDark = false;

  get themeMode => _themeMode;

  Future<void> initThemeSettings(String email) async {
    // Load data from the database here, e.g., using async/await
    // Replace this with your database query code
    isDark = await AuthService().fetchSingleSetting(email: email, settingKey: "isDark");
    print(isDark);
    setTheme(isDark);
    isInitialized = true;

    // Notify listeners that the data has been loaded
    notifyListeners();
  }

  setTheme(bool toggle) {
     _themeMode = toggle ? ThemeMode.dark : ThemeMode.light;
  }

  toggleTheme() {
    isDark = !isDark;
    setTheme(isDark);
    print("Theme is Dark: $isDark");
    notifyListeners();
  }
}
