import 'dart:async';

import 'package:drone_2_0/screens/homepage/homepage.dart';
import 'package:drone_2_0/themes/main_themes.dart';
import 'package:flutter/material.dart';
import 'package:drone_2_0/screens/login/login.dart';
import "package:firebase_core/firebase_core.dart";
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.android);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
late StreamSubscription<User?> user;
  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        print('User is signed in!');
      }
    });
  }

  @override
  void dispose() {
    user.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: darkTheme,
      title: 'My Drone.JPEG',

      initialRoute:
          FirebaseAuth.instance.currentUser == null ? HomePage.id : LoginScreen.id,

      ///key value pair
      routes: {
        HomePage.id: (context) => const LoginScreen(),
        LoginScreen.id: (context) => const HomePage(),
      },
      home: const LoginScreen(),
    );
  }
}