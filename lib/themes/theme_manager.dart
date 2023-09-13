import 'package:flutter/material.dart';

class ThemeManager extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;
  bool isDark = false;

  get themeMode => _themeMode;

  toggleTheme() {
    isDark = !isDark;
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    print("Theme is Dark: " + isDark.toString());
    notifyListeners();
  }
}
