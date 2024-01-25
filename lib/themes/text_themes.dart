import 'package:drone_2_0/themes/colors.dart';
import 'package:flutter/material.dart';

TextStyle _stdTextTheme = const TextStyle(fontFamily: "Switzer");

class TextThemes {
  static TextTheme darkTextTheme = TextTheme(
    // Titles
    titleLarge: _stdTextTheme.copyWith(
      fontSize: 32,
      fontWeight: FontWeight.w900,
      fontStyle: FontStyle.normal,
      color: DarkColors.textColor,
    ),
    titleMedium: _stdTextTheme.copyWith(
      fontSize: 24,
      fontWeight: FontWeight.w800,
      fontStyle: FontStyle.normal,
      color: DarkColors.textColor,
    ),
    titleSmall: _stdTextTheme.copyWith(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      fontStyle: FontStyle.normal,
      color: DarkColors.textColor,
    ),

    // Displays
    displayLarge: _stdTextTheme.copyWith(
      fontSize: 24,
      fontWeight: FontWeight.w400,
      color: DarkColors.textColor,
    ),
    displayMedium: _stdTextTheme.copyWith(
      fontSize: 18,
      fontWeight: FontWeight.w400,
      color: DarkColors.textColor,
    ),
    displaySmall: _stdTextTheme.copyWith(
      fontSize: 12,
      fontWeight: FontWeight.w300,
      color: DarkColors.textColor,
    ),

    // Body
    bodyLarge: _stdTextTheme.copyWith(
      fontSize: 24,
      fontWeight: FontWeight.w700,
      color: DarkColors.textColor,
    ),
    bodyMedium: _stdTextTheme.copyWith(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: DarkColors.textColor,
    ),
    bodySmall: _stdTextTheme.copyWith(
      fontSize: 12,
      fontWeight: FontWeight.w200,
      color: DarkColors.textColor,
    ),

    // Headline
    headlineLarge: const TextStyle(
      fontFamily: "Raleway",
      fontSize: 48,
    ),
    headlineMedium: const TextStyle(
      fontFamily: "Raleway",
      fontSize: 32,
    ),
    headlineSmall: const TextStyle(
      fontFamily: "Raleway",
      fontSize: 24,
    ),
  );

  static TextTheme lightTextTheme = TextTheme(
    // Titles
    titleLarge: _stdTextTheme.copyWith(
      fontSize: 32,
      fontWeight: FontWeight.w900,
      fontStyle: FontStyle.normal,
      color: LightColors.textColor,
    ),
    titleMedium: _stdTextTheme.copyWith(
      fontSize: 24,
      fontWeight: FontWeight.w800,
      fontStyle: FontStyle.normal,
      color: LightColors.textColor,
    ),
    titleSmall: _stdTextTheme.copyWith(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      fontStyle: FontStyle.normal,
      color: LightColors.textColor,
    ),

    // Displays
    displayLarge: _stdTextTheme.copyWith(
      fontSize: 24,
      fontWeight: FontWeight.w400,
      color: LightColors.textColor,
    ),
    displayMedium: _stdTextTheme.copyWith(
      fontSize: 18,
      fontWeight: FontWeight.w400,
      color: LightColors.textColor,
    ),
    displaySmall: _stdTextTheme.copyWith(
      fontSize: 12,
      fontWeight: FontWeight.w300,
      color: LightColors.textColor,
    ),

    // Body
    bodyLarge: _stdTextTheme.copyWith(
      fontSize: 24,
      fontWeight: FontWeight.w700,
      color: LightColors.textColor,
    ),
    bodyMedium: _stdTextTheme.copyWith(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: LightColors.textColor,
    ),
    bodySmall: _stdTextTheme.copyWith(
      fontSize: 12,
      fontWeight: FontWeight.w200,
      color: LightColors.textColor,
    ),
  );
}
