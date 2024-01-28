import 'package:drone_2_0/themes/colors.dart';
import 'package:drone_2_0/themes/dark_mode_widget_themes.dart';
import 'package:drone_2_0/themes/light_mode_widget_themes.dart';
import 'package:drone_2_0/themes/text_themes.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    // General
    colorScheme: LightColors.colorScheme,

    // Text
    textTheme: TextThemes.lightTextTheme,

    // NavigationBars
    navigationBarTheme: LightThemeWidgets.navigationBarTheme,
    //bottomNavigationBarTheme: DarkThemeWidgets.bottomNavigationBarTheme,

    // Scaffold
    //scaffoldBackgroundColor: DarkColors.secondaryColor,

    //AppBar
    appBarTheme: LightThemeWidgets.appBarTheme,

    // Tabs
    iconTheme: LightThemeWidgets.iconThemeData,
    tabBarTheme: const TabBarTheme(
      labelColor: Colors.white, // Icon Color
    ),

    // Input
    inputDecorationTheme: LightThemeWidgets.inputDecorationTheme,

    /// Buttons
    elevatedButtonTheme: LightThemeWidgets.elevatedButtonThemeData,
    textButtonTheme: LightThemeWidgets.textButtonThemeData,
  );

  static ThemeData darkTheme = ThemeData(
    // General
    colorScheme: DarkColors.colorScheme,

    // Text
    textTheme: TextThemes.darkTextTheme,

    // NavigationBars
    navigationBarTheme: DarkThemeWidgets.navigationBarTheme,
    bottomNavigationBarTheme: DarkThemeWidgets.bottomNavigationBarTheme,

    // Scaffold
    //scaffoldBackgroundColor: DarkColors.secondaryColor,

    //AppBar
    appBarTheme: DarkThemeWidgets.appBarTheme,

    // Tabs
    iconTheme: DarkThemeWidgets.iconThemeData,
    tabBarTheme: const TabBarTheme(
      labelColor: Colors.white, // Icon Color
    ),

    // Input
    inputDecorationTheme: DarkThemeWidgets.inputDecorationTheme,

    /// Buttons
    elevatedButtonTheme: DarkThemeWidgets.elevatedButtonThemeData,
    textButtonTheme: DarkThemeWidgets.textButtonThemeData,
  );
}
