import 'package:flutter/material.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image(
          image: AssetImage(
              "assets/images/drone.png"),
          fit: BoxFit.fill,
        ),
        Text("Welcome to the FPV-Drone App")
      ],
    );
  }
}
