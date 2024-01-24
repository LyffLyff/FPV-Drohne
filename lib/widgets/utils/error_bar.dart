import 'package:drone_2_0/data/providers/logging_provider.dart';
import 'package:flutter/material.dart';

SnackBar defaultSnackbar(String msg, {Color color = Colors.red}) {
  Logging.error(msg);
  return SnackBar(
    content: Text(msg),
    backgroundColor: color,
  );
}
