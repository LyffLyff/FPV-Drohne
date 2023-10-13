import 'package:drone_2_0/themes/colors.dart';
import 'package:flutter/material.dart';

class TextThemes {
  static TextTheme darkTextTheme = TextTheme(
    // Titles
    titleLarge: TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.w900,
      fontStyle: FontStyle.normal,
      color: DarkColors.textColor,
    ),
    titleMedium: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w800,
      fontStyle: FontStyle.normal,
      color: DarkColors.textColor,
    ),
    titleSmall: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      fontStyle: FontStyle.normal,
      color: DarkColors.textColor,
    ),

    // Displays
    displayLarge: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w400,
      color: DarkColors.textColor,
    ),
    displayMedium: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w400,
      color: DarkColors.textColor,
    ),
    displaySmall: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w300,
      color: DarkColors.textColor,
    ),

    // Body
    bodyLarge: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w400,
      color: DarkColors.textColor,
    ),
    bodyMedium: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w400,
      color: DarkColors.textColor,
    ),
    bodySmall: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w100,
      color: DarkColors.textColor,
    ),
  );
  static TextTheme lightTextTheme = TextTheme(
    // Titles
    titleLarge: TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.w900,
      fontStyle: FontStyle.normal,
      color: LightColors.textColor,
    ),
    titleMedium: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w800,
      fontStyle: FontStyle.normal,
      color: LightColors.textColor,
    ),
    titleSmall: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      fontStyle: FontStyle.normal,
      color: LightColors.textColor,
    ),

    // Displays
    displayLarge: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w400,
      color: LightColors.textColor,
    ),
    displayMedium: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w400,
      color: LightColors.textColor,
    ),
    displaySmall: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w300,
      color: LightColors.textColor,
    ),

    // Body
    bodyLarge: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w400,
      color: LightColors.textColor,
    ),
    bodyMedium: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w400,
      color: LightColors.textColor,
    ),
    bodySmall: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w100,
      color: LightColors.textColor,
    ),
  );
}
