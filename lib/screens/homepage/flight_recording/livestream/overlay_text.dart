import 'package:drone_2_0/themes/theme_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

TextStyle _overlayStyle = const TextStyle(
  fontFamily: "VCR_OSD_Mono",
  color: Colors.white,
);

TextStyle _lightOverlayText = _overlayStyle.copyWith(
  color: Colors.black,
);

class OverlayText extends StatelessWidget {
  final String text;
  const OverlayText({super.key, required this.text});

  TextStyle getStyle(bool isDark) {
    return isDark ? _overlayStyle : _lightOverlayText;
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: getStyle(Provider.of<ThemeManager>(context).isDark),
    );
  }
}
