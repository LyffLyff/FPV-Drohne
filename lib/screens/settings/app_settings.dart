import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void defaultAppSettings({bool darkMode = true}) {
  // OS Navigation
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  colorSettings(darkMode);

  // Prevent turning phone
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
}

void colorSettings(bool darkMode) {
  SystemUiOverlayStyle mySystemTheme;
  if (darkMode) {
    // dark mode sytem colors
    mySystemTheme = SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: Colors.grey.shade900,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.grey.shade900,
    );
  } else {
    // light mode sytem colors
    mySystemTheme = SystemUiOverlayStyle.light.copyWith(
      statusBarColor: Colors.grey.shade200,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.grey.shade200,
    );
  }
  SystemChrome.setSystemUIOverlayStyle(mySystemTheme);
}
