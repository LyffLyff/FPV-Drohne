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
              contentPadding: const EdgeInsets.symmetric(vertical: 8.0),
              hintText: hintText,
              prefixIcon: Icon(icon),
              isCollapsed: true,
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(16),
                ),
              ),
            ),
            obscureText: hideText,
            textInputAction: TextInputAction.next,
            onEditingComplete: () =>
                {SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge)},
            textAlignVertical: TextAlignVertical.center,
            autocorrect: false,
            style: Theme.of(context).textTheme.displayMedium));
  }
}
