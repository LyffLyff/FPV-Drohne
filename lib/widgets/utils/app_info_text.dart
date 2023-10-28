import 'package:drone_2_0/extensions/extensions.dart';
import 'package:flutter/material.dart';

class AppInfoText extends StatelessWidget {
  final String text;
  const AppInfoText({super.key, this.text = ""});



  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        text,
        textAlign: TextAlign.left,
        style: context.textTheme.bodyMedium,
      ),
    );
  }
}