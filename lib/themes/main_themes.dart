import 'package:flutter/material.dart';

const TextTheme _textTheme = TextTheme(
    // Titles
    titleLarge: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w900,
      fontStyle: FontStyle.normal
      ),
    titleMedium: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w500,
      fontStyle: FontStyle.normal
      ),
    titleSmall: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal
      ),
    
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
  textTheme: _textTheme,
  scaffoldBackgroundColor: Colors.white,

  //AppBar
  appBarTheme: const AppBarTheme(
    //color: Colors.white,
    shadowColor: Colors.blueGrey
  ),

  //Navigation Bar
  //bottomNavigationBarTheme: NavigationBarTheme(),

  //Buttons
  buttonTheme: const ButtonThemeData(
    shape: RoundedRectangleBorder(),
    textTheme: ButtonTextTheme.primary,
  ),
);

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primarySwatch: Colors.cyan,
  textTheme: _textTheme,
);
