import 'package:drone_2_0/screens/homepage/homepage.dart';
import 'package:drone_2_0/screens/login/login.dart';
import 'package:drone_2_0/screens/pre_login/welcome_screen.dart';
import 'package:drone_2_0/service/auth/auth_service.dart';
import 'package:drone_2_0/themes/main_themes.dart';
import 'package:drone_2_0/themes/theme_manager.dart';
import 'package:flutter/material.dart';
import "package:firebase_core/firebase_core.dart";
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'data/providers/auth_provider.dart';
import 'data/providers/user_model.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.immersiveSticky); // hide System NavigationBar
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (_) => UserProvider(),
      ),
      ChangeNotifierProvider(
        create: (_) => AuthProvider(),
      ),
      ChangeNotifierProvider(
        create: (_) => ThemeManager(),
      )
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: Provider.of<ThemeManager>(context).themeMode,
      title: 'My Drone.JPEG',
      routes: {
        WelcomeScreen.id: (context) => const WelcomeScreen(),
        HomePage.id: (context) => const HomePage(),
        LoginScreen.id: (context) => const LoginScreen(),
      },
      home: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          User? user = authProvider.getUser;
          if (user != null) {
            return FutureBuilder<Map<String, dynamic>?>(
              future: AuthService().fetchUserData(email: user.email ?? ""),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  // While fetching data, show a loading indicator.
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  // Handle error, e.g., show an error message.
                  return Text("Error: ${snapshot.error}");
                } else {
                  // Data has been fetched, update user info and navigate.
                  final userData = snapshot.data;
                  if (!Provider.of<ThemeManager>(context, listen: false).isInitialized) {
                      Provider.of<ThemeManager>(context, listen: true).initThemeSettings(user.email ?? "");
                  }
                  SchedulerBinding.instance.addPostFrameCallback((_) {
                    Provider.of<UserProvider>(context, listen: false)
                        .changeUserEmail(user.email ?? "?");
                    Provider.of<UserProvider>(context, listen: false)
                        .changeUsername(userData?["username"]);
                    Provider.of<UserProvider>(context, listen: false)
                        .changeName(userData?["name"]);
                  });
                  return const HomePage();
                }
              },
            );
          } else {
            // User is not logged in, navigate to the Login screen.
            return const WelcomeScreen();
          }
        },
      ),
    );
  }
}
