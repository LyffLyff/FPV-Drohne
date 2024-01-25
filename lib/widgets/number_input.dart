import 'package:drone_2_0/extensions/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NumberInputField extends StatelessWidget {
  const NumberInputField({
    super.key,
    required this.hintText,
    required this.width,
    required this.controller,
    this.icon,
  });

  final String hintText;
  final double width;
  final TextEditingController controller;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    bool hasIcon = icon != null;
    return TextField(
      controller: controller,
      cursorColor: context.colorScheme.primary,
      decoration: InputDecoration(
        contentPadding:
            EdgeInsets.symmetric(vertical: 16.0, horizontal: hasIcon ? 0 : 8),
        hintText: hintText,
        prefixIcon: hasIcon ? Icon(icon) : null,
        isCollapsed:
            true, // fixing hintText not being centered correctly when prefixIcon exists
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(16),
          ),
        ),
      ),
      textInputAction: TextInputAction.next,
      keyboardType:
          const TextInputType.numberWithOptions(decimal: true, signed: true),
      onEditingComplete: () =>
          {SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge)},
      textAlignVertical: TextAlignVertical.center,
      autocorrect: false,
      style: context.textTheme.labelLarge,
    );
  }
}
