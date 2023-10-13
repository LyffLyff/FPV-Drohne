import 'package:flutter/material.dart';

MaterialColor createMaterialColor(Color color) {
  // automatically creates a swatch (related colours) from an input color
  List strengths = <double>[.05];
  Map<int, Color> swatch = {};
  final int r = color.red, g = color.green, b = color.blue;

  for (int i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }
  for (var strength in strengths) {
    final double ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    );
  }
  return MaterialColor(color.value, swatch);
}

class DarkColors {
  // General
  static Color primaryColor = const Color.fromARGB(255, 193, 206, 215);
  static Color secondaryColor = const Color.fromARGB(255, 20, 26, 31);
  static Color accentColor = const Color.fromARGB(255, 99, 132, 156);
  static Color backgroundColor = const Color.fromARGB(255, 18, 24, 28);
  static Color textColor = const Color.fromARGB(255, 230, 235, 239);
}

class LightColors {
  static Color primaryColor = const Color.fromARGB(255, 40, 53, 62);
  static Color secondaryColor = const Color.fromARGB(255, 224, 230, 235);
  static Color accentColor = const Color.fromARGB(255, 99, 132, 156);
  static Color backgroundColor = const Color.fromARGB(255, 227, 233, 237);
  static Color textColor = const Color.fromARGB(255, 16, 21, 25);
}