import 'package:flutter/material.dart';

class VerticalSpace extends StatelessWidget {
  const VerticalSpace({
    super.key,
    this.height = 20,
  });

  final int height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height.toDouble(),
    );
  }
}

class HorizontalSpace extends StatelessWidget {
  const HorizontalSpace({
    super.key,
    this.width = 20,
  });

  final int width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: width.toDouble(),
    );
  }
}