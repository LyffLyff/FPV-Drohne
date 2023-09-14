import 'package:flutter/material.dart';

const TextTheme _textTheme = TextTheme(
    displayLarge: TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.w400,
      ),
    displayMedium: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w400,
    )
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
  primarySwatch: Colors.teal,
  textTheme: _textTheme,
);
