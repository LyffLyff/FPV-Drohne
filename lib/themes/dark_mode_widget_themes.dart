import 'package:drone_2_0/themes/colors.dart';
import 'package:drone_2_0/themes/text_themes.dart';
import 'package:flutter/material.dart';

class DarkThemeWidgets {
  static AppBarTheme appBarTheme = AppBarTheme(
    foregroundColor: Colors.white,
    backgroundColor: Colors.grey.shade900,
    titleTextStyle: TextThemes.darkTextTheme.titleMedium,
  );

  static NavigationBarThemeData navigationBarTheme =
      const NavigationBarThemeData(
    backgroundColor: Colors.black,
  );

  static BottomNavigationBarThemeData bottomNavigationBarTheme =
      BottomNavigationBarThemeData(backgroundColor: DarkColors.accentColor);

  static IconThemeData iconThemeData = const IconThemeData(
    color: Colors.white,
  );

  static TabBarTheme tabBarTheme = const TabBarTheme(
    labelColor: Colors.white, // Icon Color
  );

  static ElevatedButtonThemeData elevatedButtonThemeData =
      ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: DarkColors.accentColor,
      foregroundColor: DarkColors.textColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
  );
}
