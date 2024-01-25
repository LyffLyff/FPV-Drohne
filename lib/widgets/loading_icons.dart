import 'package:drone_2_0/extensions/extensions.dart';
import 'package:flutter/material.dart';

class CircularLoadingIcon extends StatelessWidget {
  final double length;
  const CircularLoadingIcon({super.key, this.length = 48});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: length,
        height: length,
        child: CircularProgressIndicator.adaptive(
          backgroundColor: context.colorScheme.onPrimary,
        ),
      ),
    );
  }
}
