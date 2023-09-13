import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData(
  fontFamily: "RobotoFlex",
  brightness: Brightness.light, // Text Black -> White Mode
  useMaterial3: true,
  textTheme: const TextTheme(
    displayLarge: TextStyle(fontSize: 32)
  ),
  appBarTheme: const AppBarTheme(
    iconTheme: IconThemeData(
      color: Color.fromARGB(255, 87, 87, 87)
    ),
  ),
  colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
);


ThemeData darkTheme = ThemeData(
     brightness: Brightness.dark,
     
  );