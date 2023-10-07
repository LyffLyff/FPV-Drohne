import 'package:drone_2_0/data/providers/auth_provider.dart';
import 'package:drone_2_0/screens/login/registration.dart';
import 'package:drone_2_0/service/auth/auth_service.dart';
import 'package:drone_2_0/screens/homepage/homepage.dart';
import 'package:drone_2_0/themes/theme_constants.dart';
import 'package:drone_2_0/widgets/animations/animation_routes.dart';
import 'package:drone_2_0/widgets/loading_icons.dart';
import 'package:drone_2_0/widgets/utils/error_bar.dart';
import 'package:drone_2_0/widgets/utils/helper_widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../widgets/input.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  static String id = 'LoginScreen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Container(
        margin: const EdgeInsets.all(Margins.stdMargin),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              StdInputField(
                width: MediaQuery.of(context).size.width,
                hideText: false,
                controller: _emailController,
                hintText: "Email",
                icon: Icons.person,
              ),
              const VerticalSpace(),
              StdInputField(
                width: MediaQuery.of(context).size.width,
                hideText: true,
                controller: _passwordController,
                hintText: "Password",
                icon: Icons.password,
              ),
              const VerticalSpace(),
              ElevatedButton(
                onPressed: () async {
                  _loginAndNavigate(
                      context, _emailController.text, _passwordController.text);
                },
                child: const Text('Login'),
              ),
              const VerticalSpace(height: 10),
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    pageRouteAnimation(const Registration()),
                  );
                },
                child: const Text('Create Account >>'),
              ),
            ],
          ),
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

void _loginAndNavigate(
    BuildContext context, String email, String password) async {
  final GlobalKey<State> _LoaderDialog = GlobalKey<State>();
  LoaderDialog.showLoadingDialog(context, _LoaderDialog);

  final message = await AuthService().login(
    email: email,
    password: password,
  );
  if (context.mounted) {
    if (message!.contains('Success')) {
      // replace profile image download url

      await context.read<AuthProvider>().initUser();

      // Use Navigator to navigate to the HomePage
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => const HomePage(),
      ));
    } else {
      Navigator.pop(context);
      print("Error");
      ScaffoldMessenger.of(context).showSnackBar(
        showErrorSnackBar(message),
      );
    }
  }
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
          child: circularLoadingIcon(),
        );
      },
    );
  }
}
