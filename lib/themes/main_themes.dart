import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData(
  fontFamily: "RobotoFlex",
  brightness: Brightness.light, // Text Black -> White Mode
  useMaterial3: true,
  textTheme: const TextTheme(
    displayLarge: TextTheme(fontSize: 32) 
  appBarTheme: const AppBarTheme(
    iconTheme: IconThemeData(
      color: Colors.black
    ),
  ),
  colorScheme: ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 239, 239, 239)),
  );
)


ThemeData darkTheme = ThemeData(
     primaryColor: const Color.fromARGB(255, 255, 255, 255),
     colorScheme: ColorScheme.dark().copyWith(primary: Colors.primaries.first),
  );