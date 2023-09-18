import 'package:drone_2_0/service/auth/auth_service.dart';
import 'package:drone_2_0/themes/theme_constants.dart';
import 'package:drone_2_0/widgets/input.dart';
import 'package:drone_2_0/widgets/utils/error_bar.dart';
import 'package:drone_2_0/widgets/utils/helper_widgets.dart';
import 'package:flutter/material.dart';

class CreateAccount extends StatefulWidget {
  const CreateAccount({Key? key}) : super(key: key);

  @override
  _CreateAccountState createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _sirNameController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Account'),
      ),
      body: Container(
        margin: const EdgeInsets.all(Margins.stdMargin),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            stdInputField(
              width: MediaQuery.of(context).size.width,
              controller: _emailController,
              hintText: "Email",
              hideText: false,
              icon: Icons.person,
            ),
            addVerticalSpace(),
            stdInputField(
              width: MediaQuery.of(context).size.width,
              controller: _passwordController,
              hintText: "Password",
              hideText: true,
              icon: Icons.password,
            ),
            addVerticalSpace(),
            stdInputField(
              width: MediaQuery.of(context).size.width,
              controller: _userNameController,
              hintText: "Username",
              hideText: false,
              icon: Icons.perm_contact_cal,
            ),
            addVerticalSpace(),
            stdInputField(
              width: MediaQuery.of(context).size.width,
              controller: _nameController,
              hintText: "Name",
              hideText: false,
              icon: Icons.perm_contact_cal,
            ),
            addVerticalSpace(),
            stdInputField(
              width: MediaQuery.of(context).size.width,
              controller: _sirNameController,
              hintText: "Sirname",
              hideText: false,
              icon: Icons.perm_contact_cal,
            ),
            addVerticalSpace(height: 10),
            ElevatedButton(
              onPressed: () async {
                final message = await AuthService().registration(
                  email: _emailController.text,
                  password: _passwordController.text,
                  username: _userNameController.text,
                  name: _nameController.text + _sirNameController.text,
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
          ],
        ),
      ),
    );
  }
}
