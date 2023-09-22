import 'package:drone_2_0/screens/homepage/homepage.dart';
import 'package:drone_2_0/screens/login/login.dart';
import 'package:drone_2_0/screens/pre_login/welcome_screen.dart';
import 'package:drone_2_0/service/auth/auth_service.dart';
import 'package:drone_2_0/themes/main_themes.dart';
import 'package:drone_2_0/themes/theme_manager.dart';
import 'package:flutter/material.dart';
import "package:firebase_core/firebase_core.dart";
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'data/providers/auth_provider.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';
import 'package:logger/logger.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.immersiveSticky); // hide System NavigationBar

  // Initialize App
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  AuthProvider authProvider = AuthProvider();
  User? user = authProvider.getUser;
  await authProvider.fetchProfileDownloadURL();

  final Map<String, dynamic>? userData =
      await AuthService().fetchUserData(userId: user?.uid ?? "");
  final ThemeManager themeManager = ThemeManager();
  await themeManager.initThemeSettings(user?.uid ?? "");
  /*final UserProvider userProvider = UserProvider();
  userProvider.setCurrentUser(user!);
  userProvider.changeUserId(user.uid);
  userProvider.changeName(userData?["name"]);
  userProvider.changeUsername(userData?["username"]);
  userProvider.changeUserEmail(user.email ?? "");*/

  runApp(MultiProvider(
    providers: [
      /*ChangeNotifierProvider(
        create: (_) => userProvider,
      ),*/
      ChangeNotifierProvider(
        create: (_) => authProvider,
      ),
      ChangeNotifierProvider(
        create: (_) => themeManager,
      )
    ],
    child: MyApp(
      userData: userData,
      user: user,
    ),
  ));
}

class MyApp extends StatelessWidget {
  final Map<String, dynamic>? userData;
  final User? user;
  var logger = Logger(
    printer: PrettyPrinter(),
  );

  MyApp({super.key, required this.userData, required this.user});

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
    );
  }
}
