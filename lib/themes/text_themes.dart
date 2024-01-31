import 'package:drone_2_0/themes/colors.dart';
import 'package:flutter/material.dart';

TextStyle _stdTextTheme = const TextStyle(
  fontFamily: "Switzer",
);

TextStyle _stdHeadline = const TextStyle(
  fontFamily: "Raleway",
);

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
    headlineLarge: _stdHeadline.copyWith(
      fontSize: 48,
    ),
    headlineMedium: _stdHeadline.copyWith(
      fontSize: 32,
    ),
    headlineSmall: _stdHeadline.copyWith(
      fontSize: 24,
    ),
  );

  static TextTheme lightTextTheme = TextTheme(
    // Titles
    titleLarge: darkTextTheme.titleLarge?.copyWith(
      color: LightColors.textColor,
    ),
    titleMedium: darkTextTheme.titleMedium?.copyWith(
      color: LightColors.textColor,
    ),
    titleSmall: darkTextTheme.titleSmall?.copyWith(
      color: LightColors.textColor,
    ),

    // Displays
    displayLarge: darkTextTheme.displayLarge?.copyWith(
      fontSize: 24,
      fontWeight: FontWeight.w400,
      color: DarkColors.textColor,
    ),
    displayMedium: darkTextTheme.displayMedium?.copyWith(
      fontSize: 18,
      fontWeight: FontWeight.w400,
      color: DarkColors.textColor,
    ),
    displaySmall: darkTextTheme.displaySmall?.copyWith(
      fontSize: 12,
      fontWeight: FontWeight.w300,
      color: DarkColors.textColor,
    ),

    // Body
    bodyLarge: darkTextTheme.bodyLarge?.copyWith(
      fontSize: 24,
      fontWeight: FontWeight.w700,
      color: DarkColors.textColor,
    ),
    bodyMedium: darkTextTheme.bodyMedium?.copyWith(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: DarkColors.textColor,
    ),
    bodySmall: darkTextTheme.bodySmall?.copyWith(
      fontSize: 12,
      fontWeight: FontWeight.w200,
      color: DarkColors.textColor,
    ),

    // Headline
    headlineLarge: darkTextTheme.headlineLarge?.copyWith(
      fontFamily: "Raleway",
      fontSize: 48,
    ),
    headlineMedium: darkTextTheme.headlineLarge?.copyWith(
      fontFamily: "Raleway",
      fontSize: 32,
    ),
    headlineSmall: darkTextTheme.headlineLarge?.copyWith(
      fontFamily: "Raleway",
      fontSize: 24,
    ),
  );
}
