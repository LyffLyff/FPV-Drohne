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

  static ListTileThemeData listTileThemeData = ListTileThemeData(
    selectedColor: Colors.grey.shade900,
    tileColor: Colors.grey.shade900,
    selectedTileColor: Colors.grey.shade900,
  );

  // Input -> Textfield,...
  static InputDecorationTheme inputDecorationTheme = InputDecorationTheme(
    // Unfocused border -> with opacity < 1.0
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(color: DarkColors.secondaryColor),
    ),

    // Displayed during error Input -> e.g. Invalid Email
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: const BorderSide(color: Colors.red),
    ),

    // When in focus after press
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(color: DarkColors.primaryColor),
    ),
  );

  /// Buttons ///
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

  static TextButtonThemeData textButtonThemeData = TextButtonThemeData(
    style: TextButton.styleFrom(
      textStyle: TextThemes.darkTextTheme.bodyMedium,
      foregroundColor: DarkColors.textColor,
    ),
  );
}
