import 'package:drone_2_0/screens/homepage/homepage.dart';
import 'package:drone_2_0/screens/login/login.dart';
import 'package:drone_2_0/screens/pre_login/welcome_screen.dart';
import 'package:drone_2_0/themes/main_themes.dart';
import 'package:drone_2_0/themes/theme_manager.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import '../../data/providers/auth_provider.dart';
import '../../firebase_options.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  bool isInitialized = false;
  User? user;

  var logger = Logger(
    printer: PrettyPrinter(),
  );

  Future<List> initApp() async {
    // Initialize App
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
    final AuthProvider authProvider = AuthProvider();
    final ThemeManager themeManager = ThemeManager();
    User? user = authProvider.currentUser;
    await authProvider.initUser();

    await themeManager.initThemeSettings(user?.uid ?? "");

    return [user, authProvider, themeManager];
  }

  @override
  Future<void> initState() async {
    super.initState();
    initApp().then((data) {
      setState(() {
        isInitialized = true;
        user = data[0];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: lightTheme,
        darkTheme: darkTheme,
        themeMode: Provider.of<ThemeManager>(context).themeMode,
        title: "FPV-Drone",
        routes: {
          WelcomeScreen.id: (context) => const WelcomeScreen(),
          HomePage.id: (context) => const HomePage(),
          LoginScreen.id: (context) => const LoginScreen(),
        },
        home: user == null
            ? const WelcomeScreen()
            : FutureBuilder(
                future: null,
                builder: (BuildContext context,
                    AsyncSnapshot<List<dynamic>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // While fetching data, show a loading indicator.
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    logger.i(snapshot.error.toString());
                    return Text(snapshot.error.toString());
                  } else {
                    //final userData = snapshot.data?[0];

                    logger.i("Homepage Initialized");
                    return const HomePage();
                  }
                },
              ),
      ),
    );
  }
}
