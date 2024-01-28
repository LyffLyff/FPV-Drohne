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

  static IconThemeData iconThemeData = const IconThemeData(
    color: Colors.black,
  );

  static TabBarTheme tabBarTheme = const TabBarTheme(
    labelColor: Colors.black, // Icon Color
  );

  static InputDecorationTheme inputDecorationTheme = InputDecorationTheme(
    fillColor: DarkColors.colorScheme.primary,
    hintStyle: TextThemes.darkTextTheme.labelSmall,
    isCollapsed: true,
    // Unfocused border -> with opacity < 1.0
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
    ),
  );

  /// Buttons ///
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

  static DrawerThemeData drawerTheme = DrawerThemeData(
    backgroundColor: LightColors.colorScheme.background,
  );

  static TextButtonThemeData textButtonThemeData = TextButtonThemeData(
    style: TextButton.styleFrom(
      textStyle: TextThemes.lightTextTheme.bodyMedium,
      foregroundColor: LightColors.textColor,
    ),
  );
}
