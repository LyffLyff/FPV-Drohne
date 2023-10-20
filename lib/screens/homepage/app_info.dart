import 'package:drone_2_0/extensions/extensions.dart';
import 'package:flutter/material.dart';

class AppInfo extends StatelessWidget {
  const AppInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: context.canvasColor,
      padding: const EdgeInsets.all(10),
      child: const Column(
        children: [
          Image(
            image: AssetImage("assets/images/logo2.png"),
            fit: BoxFit.fitWidth,
          ),
          Image(
            image: AssetImage("assets/images/dronetech/noname.png"),
            fit: BoxFit.fitWidth,
          ),
        ],
      ),
    );
  }
}
