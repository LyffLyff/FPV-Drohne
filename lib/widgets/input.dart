import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class StdInputField extends StatelessWidget {
  const StdInputField({
    super.key,
    required this.hintText,
    required this.width,
    required this.hideText,
    required this.controller,
    this.icon,
  });

  final String hintText;
  final bool hideText;
  final double width;
  final TextEditingController controller;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
    width: width,
    child: TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: Icon(icon),
        ),
      obscureText: hideText,
      onEditingComplete: () => {
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky)
      },
      textAlignVertical: TextAlignVertical.center,
      autocorrect: false,
      
      style: const TextStyle(
        fontSize: 16
      )
    )
  );
  }
}
