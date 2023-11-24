import 'package:drone_2_0/extensions/extensions.dart';
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
    bool hasIcon = icon != null;
    return SizedBox(
        width: width,
        child: TextField(
            controller: controller,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: 16.0, horizontal: hasIcon ? 0 : 8),
              hintText: hintText,
              prefixIcon: hasIcon ? Icon(icon) : null,
              isCollapsed: true,  // fixing hintText not being centered correctly when prefixIcon exists
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
            style: context.textTheme.labelLarge));
  }
}
