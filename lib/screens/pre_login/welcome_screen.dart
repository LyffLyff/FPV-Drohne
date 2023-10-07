import 'package:drone_2_0/screens/login/registration.dart';
import 'package:drone_2_0/screens/login/login.dart';
import 'package:drone_2_0/themes/theme_constants.dart';
import 'package:drone_2_0/widgets/utils/helper_widgets.dart';
import 'package:flutter/material.dart';
import '../../widgets/animations/animation_routes.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  static String id = "Welcome";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.all(Margins.stdMargin),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const VerticalSpace(height: 40),
              const Image(
                  image: AssetImage("assets/images/logo.png"),
                  fit: BoxFit.fill),
              const Divider(),
              const VerticalSpace(),
              Align(
                  alignment: Alignment.center,
                  child: Text("Welcome to the \nFPV-Drone Application :)",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.displayMedium)),
              const VerticalSpace(),
              ElevatedButton(
                child: const Text("Already have an account? Sign In"),
                onPressed: () {
                  Navigator.of(context).push(pageRouteAnimation(const LoginScreen()));
                },
              ),
              ElevatedButton(
                child: const Text("Register as new User"),
                onPressed: () {
                  Navigator.of(context).push(pageRouteAnimation(const Registration()));
                },
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
