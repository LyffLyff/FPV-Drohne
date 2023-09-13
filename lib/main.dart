import 'dart:async';

import 'package:drone_2_0/screens/homepage/homepage.dart';
import 'package:drone_2_0/screens/user_profile/user_profile.dart';
import 'package:drone_2_0/screens/welcome_screen.dart';
import 'package:drone_2_0/themes/main_themes.dart';
import 'package:flutter/material.dart';
import 'package:drone_2_0/screens/login/login.dart';
import "package:firebase_core/firebase_core.dart";
import 'package:firebase_auth/firebase_auth.dart';
import 'package:drone_2_0/servide/auth/auth_service.dart';
import 'data/providers/user_model.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.android);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
          )
      ],
      child: const MyApp(),
    )
  );
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
    user = FirebaseAuth.instance.authStateChanges().listen((user) async {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        print('User is signed in!');
        Provider.of<UserProvider>(context, listen: false).changeUserEmail(user.email ?? "");
        Provider.of<UserProvider>(context, listen: false).changeUsername(await AuthService().fetchUserData(email: user.email ?? "") ?? "");
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
          FirebaseAuth.instance.currentUser == null ? WelcomeScreen.id : HomePage.id,

      ///key value pair
      routes: {
        WelcomeScreen.id: (context) => const WelcomeScreen(),
        HomePage.id: (context) => const HomePage(),
        LoginScreen.id: (context) => const LoginScreen(),
        UserProfile.id: (context) => const UserProfile(),
      },
      home: const WelcomeScreen(),
    );
  }
}