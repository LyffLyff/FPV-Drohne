import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

const TextTheme _textTheme = TextTheme(
  // Titles
  titleLarge: TextStyle(
      fontSize: 32, fontWeight: FontWeight.w900, fontStyle: FontStyle.normal),
  titleMedium: TextStyle(
      fontSize: 24, fontWeight: FontWeight.w800, fontStyle: FontStyle.normal),
  titleSmall: TextStyle(
      fontSize: 16, fontWeight: FontWeight.w500, fontStyle: FontStyle.normal),

  // Displays
  displayLarge: TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w400,
  ),
  displayMedium: TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w400,
  ),
  displaySmall: TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w300,
  ),

  // Body
  bodyLarge: TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w400,
  ),
  bodyMedium: TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w400,
  ),
  bodySmall: TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w100,
  ),
);

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light, // Text Black -> White Mode
  primarySwatch: Colors.indigo,
  primaryColor: Colors.white,
  textTheme: _textTheme,
  scaffoldBackgroundColor: Colors.white,

  navigationBarTheme: const NavigationBarThemeData(
    backgroundColor: Colors.black,
  ),

  //AppBar
  appBarTheme: AppBarTheme(
    color: Colors.black,
    foregroundColor: Colors.black,
    shadowColor: Colors.blueGrey,
    titleTextStyle: _textTheme.titleMedium?.copyWith(
      color: Colors.black
    ),
  ),

  //Navigation Bar
  bottomAppBarTheme: BottomAppBarTheme(color: Colors.grey.shade900),

  // Appbar
  //Buttons
  buttonTheme: const ButtonThemeData(
    shape: RoundedRectangleBorder(),
    textTheme: ButtonTextTheme.primary,
  ),
);

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primarySwatch: Colors.cyan,
  primaryColor: Colors.black,
  textTheme: _textTheme,

  navigationBarTheme: const NavigationBarThemeData(
    backgroundColor: Colors.black,
  ),

  scaffoldBackgroundColor: Colors.grey.shade800,

  //AppBar
  appBarTheme: AppBarTheme(
    foregroundColor: Colors.white,
    backgroundColor: Colors.grey.shade900,
    //color: Colors.white,
    titleTextStyle: _textTheme.titleMedium,
  ),
);
