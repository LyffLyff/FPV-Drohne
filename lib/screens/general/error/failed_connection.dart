import 'package:drone_2_0/extensions/extensions.dart';
import 'package:flutter/material.dart';

class ConnectionError extends StatelessWidget {
  const ConnectionError({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        backgroundColor: context.errorColor,
        icon: const Icon(
          Icons.wifi_tethering_error_rounded_rounded,
          size: 32,
        ),
        title: Text(
          'Connection Error :/',
          style: context.textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ));
  }
}
