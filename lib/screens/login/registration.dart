import 'package:drone_2_0/data/providers/auth_provider.dart';
import 'package:drone_2_0/service/auth/auth_service.dart';
import 'package:drone_2_0/themes/theme_constants.dart';
import 'package:drone_2_0/widgets/input.dart';
import 'package:drone_2_0/widgets/utils/error_bar.dart';
import 'package:drone_2_0/widgets/utils/helper_widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:drone_2_0/extensions/extensions.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

class Registration extends StatefulWidget {
  const Registration({Key? key}) : super(key: key);

  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _sirNameController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();
  bool keyboardVisible = false;

  @override
  void initState() {
    super.initState();
    KeyboardVisibilityController().onChange.listen((bool visible) {
      setState(() {
        keyboardVisible = visible;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Return'),
      ),
      body: Container(
        margin: const EdgeInsets.all(Margins.stdMargin),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Visibility(visible: !keyboardVisible, child: const Spacer()),
            Visibility(
              visible: !keyboardVisible,
              child: Text(
                "SIGN UP",
                style: context.textTheme.headlineLarge,
              ),
            ),
            Visibility(
              visible: !keyboardVisible,
              child: const VerticalSpace(
                height: 128,
              ),
            ),
            StdInputField(
              width: MediaQuery.sizeOf(context).width,
              controller: _emailController,
              hintText: "Email",
              hideText: false,
              icon: Icons.person,
            ),
            const VerticalSpace(),
            StdInputField(
              width: MediaQuery.sizeOf(context).width,
              controller: _passwordController,
              hintText: "Password",
              hideText: true,
              icon: Icons.password,
            ),
            const VerticalSpace(),
            StdInputField(
              width: MediaQuery.sizeOf(context).width,
              controller: _userNameController,
              hintText: "Username",
              hideText: false,
              icon: Icons.perm_contact_cal,
            ),
            const VerticalSpace(),
            StdInputField(
              width: MediaQuery.sizeOf(context).width,
              controller: _nameController,
              hintText: "Name",
              hideText: false,
              icon: Icons.perm_contact_cal,
            ),
            const VerticalSpace(),
            StdInputField(
              width: MediaQuery.sizeOf(context).width,
              controller: _sirNameController,
              hintText: "Sirname",
              hideText: false,
              icon: Icons.perm_contact_cal,
            ),
            const VerticalSpace(height: 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  final message = await AuthService().registration(
                    email: _emailController.text,
                    password: _passwordController.text,
                    username: _userNameController.text,
                    name: _nameController.text + _sirNameController.text,
                    authProvider: context.read<AuthenticationProvider>(),
                  );

                  // ignore: use_build_context_synchronously
                  if (!context.mounted) return;

                  if (message!.contains('Success')) {
                    Navigator.of(context).pushReplacementNamed("LoginScreen");
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      showErrorSnackBar(message),
                    );
                  }
                },
                child: const Text('Create Account'),
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _userNameController.dispose();
    _sirNameController.dispose();
    super.dispose();
  }
}
