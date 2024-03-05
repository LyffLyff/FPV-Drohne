import 'package:drone_2_0/data/providers/data_cache.dart';
import 'package:drone_2_0/data/providers/logging_provider.dart';
import 'package:drone_2_0/screens/homepage/homepage.dart';
import 'package:drone_2_0/screens/login/login.dart';
import 'package:drone_2_0/screens/pre_login/welcome_screen.dart';
import 'package:drone_2_0/data/app_settings.dart';
import 'package:drone_2_0/themes/main_themes.dart';
import 'package:drone_2_0/themes/theme_manager.dart';
import 'package:drone_2_0/widgets/loading_icons.dart';
import 'package:flutter/material.dart';
import "package:firebase_core/firebase_core.dart";
import 'package:firebase_auth/firebase_auth.dart';
import 'data/providers/auth_provider.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  defaultAppSettings();

  // Initialize App
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  AuthenticationProvider authProvider = AuthenticationProvider();
  User? user = authProvider.currentUser;
  await authProvider.initUser();

  final ThemeManager themeManager = ThemeManager();
  await themeManager.initThemeSettings(user?.uid ?? "");

  // initialize colors after theme loaded
  appNavigationColorSettings(themeManager.isDark);

  // init cached data
  final DataCache dataCache = DataCache();
  await dataCache.initData();

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (_) => authProvider,
      ),
      ChangeNotifierProvider(
        create: (_) => themeManager,
      ),
      ChangeNotifierProvider(
        create: (_) => dataCache,
      ),
    ],
    child: MyApp(
      user: user,
    ),
  ));
}

class MyApp extends StatelessWidget {
  final User? user;

  const MyApp({super.key, required this.user});

  void cachingImages(BuildContext context) {
    // preventing pop-in of assets
    precacheImage(
        const AssetImage("assets/images/dronetech/logo_light.png"), context);
    precacheImage(
        const AssetImage("assets/images/dronetech/logo_dark.png"), context);
    precacheImage(
        const AssetImage("assets/images/dronetech/icon.png"), context);
  }

  @override
  Widget build(BuildContext context) {
    cachingImages(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: Provider.of<ThemeManager>(context).themeMode,
      title: 'FPV-Drone-Application',
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
                  return const CircularLoadingIcon();
                } else if (snapshot.hasError) {
                  Logging.error(snapshot.error.toString(), fatal: true);
                  return Text(snapshot.error.toString());
                } else {
                  //final userData = snapshot.data?[0];
                  Logging.info("Homepage Initialized");
                  return const SafeArea(child: HomePage());
                }
              },
            ),
    );
  }
}
