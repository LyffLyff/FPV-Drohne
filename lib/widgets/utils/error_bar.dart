import 'package:flutter/material.dart';

SnackBar errorSnackbar(String errorMessage) {
  return SnackBar(
    content: Text(errorMessage),
    backgroundColor: Colors.redAccent.shade200,
  );
}
