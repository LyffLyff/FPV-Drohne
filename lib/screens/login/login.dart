// ignore_for_file: use_build_context_synchronously

import 'package:drone_2_0/data/providers/auth_provider.dart';
import 'package:drone_2_0/data/providers/logging_provider.dart';
import 'package:drone_2_0/screens/login/registration.dart';
import 'package:drone_2_0/screens/login/reset_password.dart';
import 'package:drone_2_0/service/auth/auth_error_handler.dart';
import 'package:drone_2_0/service/auth/auth_service.dart';
import 'package:drone_2_0/screens/homepage/homepage.dart';
import 'package:drone_2_0/themes/theme_constants.dart';
import 'package:drone_2_0/widgets/animations/animation_routes.dart';
import 'package:drone_2_0/widgets/loading_icons.dart';
import 'package:drone_2_0/widgets/utils/error_bar.dart';
import 'package:drone_2_0/widgets/utils/helper_widgets.dart';
import 'package:drone_2_0/extensions/extensions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../widgets/input.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  static String id = 'LoginScreen';

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Return'),
      ),
      body: Container(
        margin: const EdgeInsets.all(Margins.stdMargin),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            Text(
              "LOGIN",
              style: context.textTheme.headlineLarge,
            ),
            const VerticalSpace(height: 128),
            StdInputField(
              width: MediaQuery.sizeOf(context).width,
              hideText: false,
              controller: _emailController,
              hintText: "Email",
              icon: Icons.person,
              onSubmitFunction: (String text) {},
            ),
            const VerticalSpace(height: 8),
            StdInputField(
              width: MediaQuery.sizeOf(context).width,
              hideText: true,
              controller: _passwordController,
              hintText: "Password",
              icon: Icons.password,
              onSubmitFunction: (String text) {
                print("hoe");
              },
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  pageRouteAnimation(const ResetPassword()),
                );
              },
              child: Align(
                alignment: Alignment.bottomRight,
                child: Text(
                  "Forgot Password?",
                  style: context.textTheme.labelSmall,
                ),
              ),
            ),
            const VerticalSpace(height: 8),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  _loginWithEmailAndPassword(
                      context, _emailController.text, _passwordController.text);
                },
                child: const Text('Login'),
              ),
            ),
            const VerticalSpace(height: 64),
            Row(
              children: [
                Expanded(
                    child: Divider(
                  thickness: 1,
                  color: context.colorScheme.onBackground,
                )),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    "Or Sign in with",
                    style: context.textTheme.displaySmall,
                  ),
                ),
                Expanded(
                    child: Divider(
                  thickness: 1,
                  color: context.colorScheme.onBackground,
                ))
              ],
            ),
            const VerticalSpace(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    _googleLogin(context);
                  },
                  child: const Image(
                    image: AssetImage(
                        "assets/images/company_logos/google_dark_normal.png"),
                    width: 32,
                    height: 32,
                  ),
                ),
              ],
            ),
            const Spacer(),
            TextButton(
              onPressed: () {
                Navigator.of(context).push(
                  pageRouteAnimation(const Registration()),
                );
              },
              child: Text("Don't have an account? Sign up",
                  style: context.textTheme.bodySmall),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}

void _loginWithEmailAndPassword(
    BuildContext context, String email, String password) async {
  final GlobalKey<State> loaderDialogue = GlobalKey<State>();
  LoaderDialog.showLoadingDialog(context, loaderDialogue);

  // fixing issue that autocompletes adds SPACES at the end -> making email "badly formatted"
  email = email.trimRight();

  final authStatus = await AuthService().login(
    email: email,
    password: password,
  );
  if (context.mounted) {
    if (authStatus == AuthStatus.successful) {
      _navigate(context: context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        defaultSnackbar(AuthExceptionHandler.generateErrorMessage(authStatus)),
      );
      Navigator.pop(context);
    }
  }
}

void _googleLogin(BuildContext context) async {
  final GlobalKey<State> loaderDialogue = GlobalKey<State>();
  LoaderDialog.showLoadingDialog(context, loaderDialogue);

  try {
    final UserCredential? credentials = await AuthService().signInWithGoogle();

    if (context.mounted) {
      if (credentials != null) {
        // initializing document for user
        User? user = credentials.user;
        context.read<AuthenticationProvider>().createAltLoginDocument(user!);

        _navigate(context: context);
      } else {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          defaultSnackbar("Google Sign In Error"),
        );
      }
    }
  } on PlatformException catch (e) {
    Logging.error(e);
  }
}

void _navigate({required BuildContext context}) async {
  await context.read<AuthenticationProvider>().initUser();
  // Use Navigator to navigate to the HomePage
  if (!context.mounted) {
    return;
  }
  Navigator.of(context).pushReplacement(MaterialPageRoute(
    builder: (context) => const HomePage(),
  ));
}

class LoaderDialog {
  static Future<void> showLoadingDialog(
      BuildContext context, GlobalKey key) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      barrierColor: const Color.fromARGB(255, 39, 39, 39).withAlpha(120),
      builder: (BuildContext context) {
        return Dialog.fullscreen(
          insetAnimationDuration: const Duration(milliseconds: 500),
          insetAnimationCurve: Curves.decelerate,
          key: key,
          backgroundColor: const Color.fromARGB(255, 39, 39, 39).withAlpha(120),
          child: const CircularLoadingIcon(),
        );
      },
    );
  }
}
