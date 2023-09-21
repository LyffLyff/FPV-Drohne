import 'package:drone_2_0/data/providers/auth_provider.dart';
import 'package:drone_2_0/screens/login/create_account.dart';
import 'package:drone_2_0/service/auth/auth_service.dart';
import 'package:drone_2_0/screens/homepage/homepage.dart';
import 'package:drone_2_0/themes/theme_constants.dart';
import 'package:drone_2_0/widgets/animations/animation_routes.dart';
import 'package:drone_2_0/widgets/utils/error_bar.dart';
import 'package:drone_2_0/widgets/utils/helper_widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/providers/user_provider.dart';
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
              stdInputField(
                width: MediaQuery.of(context).size.width,
                hideText: false,
                controller: _emailController,
                hintText: "Email",
                icon: Icons.person,
              ),
              addVerticalSpace(),
              stdInputField(
                width: MediaQuery.of(context).size.width,
                hideText: true,
                controller: _passwordController,
                hintText: "Password",
                icon: Icons.password,
              ),
              addVerticalSpace(),
              ElevatedButton(
                onPressed: () async {
                  _loginAndNavigate(
                      context, _emailController.text, _passwordController.text);
                },
                child: const Text('Login'),
              ),
              addVerticalSpace(height: 10),
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    pageRouteAnimation(const CreateAccount()),
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
}

void _loginAndNavigate(
    BuildContext context, String email, String password) async {
  final GlobalKey<State> _LoaderDialog = GlobalKey<State>();
  LoaderDialog.showLoadingDialog(context, _LoaderDialog);

  final message = await AuthService().login(
    email: email,
    password: password,
  );

  if (context.mounted) Navigator.of(context, rootNavigator: true).pop();

  if (message!.contains('Success')) {
    Map<String, dynamic>? userData =
        await AuthService().fetchUserData(userId: Provider.of<AuthProvider>(context, listen: false).getUserId ?? "");

    if (context.mounted) {
      Provider.of<UserProvider>(context, listen: false)
          .changeUsername(userData?["username"]);
      Provider.of<UserProvider>(context, listen: false)
          .changeUserEmail(userData?["email"]);
      Provider.of<UserProvider>(context, listen: false)
          .changeName(userData?["name"]);

      // Use Navigator to navigate to the HomePage
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => const HomePage(),
      ));
    }
  } else {
    print("Error");
    ScaffoldMessenger.of(context).showSnackBar(
      showErrorSnackBar(message),
    );
  }
}

class LoaderDialog {
  static Future<void> showLoadingDialog(
      BuildContext context, GlobalKey key) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.blue.withAlpha(120),
      builder: (BuildContext context) {
        return Dialog(
            key: key,
            backgroundColor: Colors.transparent,
            child: Image.asset(
              'assets/loading/double_ring_200px.gif',
            ));
      },
    );
  }
}
