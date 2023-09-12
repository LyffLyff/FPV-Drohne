import 'package:drone_2_0/screens/login/create_account.dart';
import 'package:drone_2_0/servide/auth/auth_service.dart';
import 'package:drone_2_0/screens/homepage/homepage.dart';
import 'package:drone_2_0/themes/theme_constants.dart';
import 'package:drone_2_0/widgets/utils/helper_widgets.dart';
import 'package:flutter/material.dart';
import '../../widgets/input.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  static String id = 'login';

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
        centerTitle: true,
      ),
      body: Container(
        margin: const EdgeInsets.all(Margins.stdMargin),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              stdInputField(
                  width: MediaQuery.of(context).size.width,
                  hideText: false,
                  controller: _emailController,
                  hintText: "Email"),
              addVerticalSpace(30),
              stdInputField(
                  width: MediaQuery.of(context).size.width,
                  hideText: true,
                  controller: _passwordController,
                  hintText: "Password"),
              addVerticalSpace(30),
              ElevatedButton(
                onPressed: () async {
                  print(
                      'Email: ${_emailController.text}, Password: ${_passwordController.text}');
                  final message = await AuthService().login(
                    email: _emailController.text,
                    password: _passwordController.text,
                  );

                  if (message!.contains('Success')) {
                    
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => const HomePage()));
                  }
                },
                child: const Text('Login'),
              ),
              addVerticalSpace(30),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => const CreateAccount(),
                    ),
                  );
                },
                child: const Text('Create Account'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
