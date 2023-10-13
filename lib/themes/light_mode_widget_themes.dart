import 'package:drone_2_0/themes/colors.dart';
import 'package:drone_2_0/themes/text_themes.dart';
import 'package:flutter/material.dart';

class LightThemeWidgets {
  static AppBarTheme appBarTheme = AppBarTheme(
    backgroundColor: Colors.grey.shade200,
    foregroundColor: Colors.black,
    shadowColor: Colors.blueGrey,
    titleTextStyle: TextThemes.lightTextTheme.titleMedium,
  );

  static NavigationBarThemeData navigationBarTheme =
      const NavigationBarThemeData(
    backgroundColor: Colors.black,
  );

  static ElevatedButtonThemeData elevatedButtonThemeData =
      ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: LightColors.accentColor,
      foregroundColor: LightColors.textColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  );
}
