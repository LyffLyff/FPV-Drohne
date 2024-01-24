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

const _textColor = Color(0xFFf5ebef);
const _backgroundColor = Color(0xFF090306);
const _primaryColor = Color(0xFFe384a8);
const _primaryFgColor = Color(0xFF090306);
const _secondaryColor = Color(0xFF8f1241);
const _secondaryFgColor = Color(0xFFf5ebef);
const _accentColor = Color(0xFFf73780);
const _accentFgColor = Color(0xFF090306);

const _colorScheme = ColorScheme(
  brightness: Brightness.dark,
  background: _backgroundColor,
  onBackground: _textColor,
  primary: _primaryColor,
  onPrimary: _primaryFgColor,
  secondary: _secondaryColor,
  onSecondary: _secondaryFgColor,
  tertiary: _accentColor,
  onTertiary: _accentFgColor,
  surface: _backgroundColor,
  onSurface: _textColor,
  error: Colors.red,
  onError: Colors.white,
);

class DarkColors {
  // General
  static Color backgroundColor = _backgroundColor;
  static Color textColor = _textColor;
  static ColorScheme colorScheme = _colorScheme.copyWith(
    error: const Color(0xffF2B8B5),
    onError: const Color(0xffFFFFFF),
  );
}

class LightColors {
  static Color primaryColor = const Color.fromARGB(255, 40, 53, 62);
  static Color secondaryColor = const Color.fromARGB(255, 224, 230, 235);
  static Color accentColor = const Color.fromARGB(255, 99, 132, 156);
  static Color backgroundColor = const Color.fromARGB(255, 227, 233, 237);
  static Color textColor = const Color.fromARGB(255, 16, 21, 25);
  static ColorScheme colorScheme = _colorScheme.copyWith(
      onBackground: const Color.fromARGB(255, 16, 21, 25),
      background: const Color.fromARGB(255, 227, 233, 237),
      error: const Color(0xffB3261E),
      onError: const Color(0xff601410),
      brightness: Brightness.light);
}
