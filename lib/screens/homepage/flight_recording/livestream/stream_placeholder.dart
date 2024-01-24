import 'package:flutter/material.dart';

class LivestreamPlaceholder extends StatelessWidget {
  const LivestreamPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return const DecoratedBox(
        decoration:
            BoxDecoration(shape: BoxShape.rectangle, color: Colors.black),
        child: Center(child: Text("Error Opening Livestream :(")));
  }
}
