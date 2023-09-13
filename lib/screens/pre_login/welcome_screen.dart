import 'package:drone_2_0/screens/login/create_account.dart';
import 'package:drone_2_0/screens/login/login.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  static String id = "Welcome";

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Scaffold(
        body: Center(
          child: Column(
            children: [
              const Image(image: AssetImage("assets/images/drone.png")),
              TextButton(
                child: Text("AlreadY have an account? Sign In"),
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder:  (context) => const LoginScreen()
                    ),
                  );
                },
              ),
              TextButton(
                child: Text("Register as new User"),
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder:  (context) => const CreateAccount()
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      )
    );
  }
}
