import 'package:flutter/material.dart';

class CircularLoadingIcon extends StatelessWidget {
  final double length;
  const CircularLoadingIcon({super.key, this.length = 40});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: length,
        height: length,
        child: const CircularProgressIndicator.adaptive(),
      ),
    );
  }
}
