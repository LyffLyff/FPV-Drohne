import 'package:flutter/material.dart';

extension BuildContextExtensions on BuildContext {
  ThemeData get theme => Theme.of(this);

  TextTheme get textTheme => theme.textTheme;

  ColorScheme get colorScheme => theme.colorScheme;

  AppBarTheme get appBarTheme => theme.appBarTheme;

  Color get errorColor => theme.colorScheme.error;
}
