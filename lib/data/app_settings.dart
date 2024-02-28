import 'package:drone_2_0/themes/colors.dart';
import 'package:flutter/services.dart';

void defaultAppSettings({bool darkMode = true}) {
  // OS Navigation
  colorSettings(darkMode);
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

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
    mySystemTheme = SystemUiOverlayStyle.light.copyWith(
      statusBarColor: DarkColors.colorScheme.background,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarIconBrightness: Brightness.light,
      systemNavigationBarContrastEnforced: true,
      systemNavigationBarColor: DarkColors.colorScheme.background,
    );
  } else {
    // light mode sytem colors
    mySystemTheme = SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: LightColors.colorScheme.background,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: LightColors.colorScheme.background,
    );
  }
  SystemChrome.setSystemUIOverlayStyle(mySystemTheme);
}
