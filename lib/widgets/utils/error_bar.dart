import 'package:flutter/material.dart';

SnackBar showErrorSnackBar(String errorMessage) {
  return SnackBar(
    content: Text(errorMessage),
    backgroundColor: Colors.redAccent.shade200,
    );
}
