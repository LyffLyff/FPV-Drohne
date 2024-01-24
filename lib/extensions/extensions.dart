import 'package:flutter/material.dart';

extension BuildContextExtensions on BuildContext {
  ThemeData get theme => Theme.of(this);

  TextTheme get textTheme => theme.textTheme;

  ColorScheme get colorScheme => theme.colorScheme;

  AppBarTheme get appBarTheme => theme.appBarTheme;

  Color get primaryColor => theme.primaryColor;
  Color get canvasColor => theme.canvasColor;
  Color get disabledColor => theme.disabledColor;
  Color get hoverColor => theme.hoverColor;
  Color get backgroundColor => theme.scaffoldBackgroundColor;
  Color get errorColor => theme.colorScheme.error;
}
