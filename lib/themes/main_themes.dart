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

    // Text
    textTheme: TextThemes.lightTextTheme,

    //AppBar
    appBarTheme: LightThemeWidgets.appBarTheme,

    //Navigation Bar
    bottomAppBarTheme: BottomAppBarTheme(color: Colors.grey.shade900),

     // Elevated Button
    elevatedButtonTheme: LightThemeWidgets.elevatedButtonThemeData,
  );

  static ThemeData darkTheme = ThemeData(
    // General
    brightness: Brightness.dark,
    primarySwatch: createMaterialColor(DarkColors.primaryColor),
    primaryColor: DarkColors.primaryColor,
    hintColor: DarkColors.accentColor,

    // Text
    textTheme: TextThemes.darkTextTheme,

    // NavigationBar
    navigationBarTheme: DarkThemeWidgets.navigationBarTheme,

    // Scaffold
    //scaffoldBackgroundColor: DarkColors.scaffoldBackgroundColor,

    //AppBar
    appBarTheme: DarkThemeWidgets.appBarTheme,

    // Elevated Button
    elevatedButtonTheme: DarkThemeWidgets.elevatedButtonThemeData,
  );
}
