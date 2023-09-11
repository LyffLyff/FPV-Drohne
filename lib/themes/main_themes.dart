import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData(
  fontFamily: "RobotoFlex",
  brightness: Brightness.light, // Text Black -> White Mode
  useMaterial3: true,
  textTheme: const TextTheme(
    displayLarge: TextStyle(fontSize: 32)
  ),
  appBarTheme: AppBarTheme(
    iconTheme: IconThemeData(
      color: const Color.fromARGB(255, 87, 87, 87)
    ),
  ),
  colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
);


ThemeData darkTheme = ThemeData(
     primaryColor: const Color.fromARGB(255, 255, 255, 255),
     colorScheme: ColorScheme.dark().copyWith(primary: Colors.primaries.first),
  );