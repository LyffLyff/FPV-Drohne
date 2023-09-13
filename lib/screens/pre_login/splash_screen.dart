import 'package:drone_2_0/screens/pre_login/welcome_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/providers/user_model.dart';
import '../../service/auth/auth_service.dart';
import '../homepage/homepage.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  static String id = "SplashScreen";

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      print('User is signed in!');

      // Initialize Usermodel
      Future.microtask(() => {
        Provider.of<UserProvider>(context, listen: false)
          .changeUserEmail(user.email ?? ""),
        }
      );
      Future.microtask(() async => {
        Provider.of<UserProvider>(context, listen: false).changeUsername(
          await AuthService().fetchUserData(email: user.email ?? "") ?? ""),
      }
      );

      //Navigate to Home Screen
      Future.microtask(() => {
        Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const HomePage()),
        ),
        }
      );
    } else {
      print("No logged in User");
      Future.microtask(() => {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const WelcomeScreen()),
            ),
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Image(
        image: AssetImage("assets/images/drone.png"),
      ),
    );
  }
}
