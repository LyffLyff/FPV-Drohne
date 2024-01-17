import 'package:flutter/material.dart';

class LivestreamPlaceholder extends StatelessWidget {
  const LivestreamPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: MediaQuery.sizeOf(context).width,
        height: 300,
        child: const DecoratedBox(
            decoration:
                BoxDecoration(shape: BoxShape.rectangle, color: Colors.black),
            child: Center(child: Text("Error Opening Livestream :("))),
      ),
    );
  }
}
