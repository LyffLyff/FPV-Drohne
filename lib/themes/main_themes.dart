import 'package:drone_2_0/themes/colors.dart';
import 'package:drone_2_0/themes/dark_mode_widget_themes.dart';
import 'package:drone_2_0/themes/light_mode_widget_themes.dart';
import 'package:drone_2_0/themes/text_themes.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light, // Text Black -> White Mode
    primarySwatch: createMaterialColor(LightColors.primaryColor),
    primaryColor: LightColors.primaryColor,
    hintColor: LightColors.accentColor,

    // Text
    textTheme: TextThemes.lightTextTheme,

    //AppBar
    appBarTheme: LightThemeWidgets.appBarTheme,

    //Navigation Bar
    bottomAppBarTheme:
        BottomAppBarTheme(color: Colors.grey.shade900.withOpacity(0.5)),
    bottomNavigationBarTheme: DarkThemeWidgets.bottomNavigationBarTheme,

    // Scaffold
    scaffoldBackgroundColor: LightColors.backgroundColor,

    // Elevated Button
    elevatedButtonTheme: LightThemeWidgets.elevatedButtonThemeData,

    // Tabs
    iconTheme: LightThemeWidgets.iconThemeData,

    tabBarTheme: const TabBarTheme(indicatorColor: Colors.black),
  );

  static ThemeData darkTheme = ThemeData(
    // General
    brightness: Brightness.dark,
    primarySwatch: createMaterialColor(DarkColors.primaryColor),
    primaryColor: DarkColors.primaryColor,
    hintColor: DarkColors.accentColor,

    // Text
    textTheme: TextThemes.darkTextTheme,

    // NavigationBars
    navigationBarTheme: DarkThemeWidgets.navigationBarTheme,
    bottomNavigationBarTheme: DarkThemeWidgets.bottomNavigationBarTheme,

    // Scaffold
    scaffoldBackgroundColor: DarkColors.secondaryColor,

    //AppBar
    appBarTheme: DarkThemeWidgets.appBarTheme,

    // Elevated Button
    elevatedButtonTheme: DarkThemeWidgets.elevatedButtonThemeData,

    // Tabs
    iconTheme: DarkThemeWidgets.iconThemeData,
    tabBarTheme: const TabBarTheme(
      labelColor: Colors.white, // Icon Color
    ),
  );
}
