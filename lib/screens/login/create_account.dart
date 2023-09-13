import 'package:drone_2_0/service/auth/auth_service.dart';
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
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width - 10,
              child: TextField(
                controller: _emailController,
                decoration: const InputDecoration(hintText: 'Email'),
              ),
            ),
            addVerticalSpace(20),
            SizedBox(
              width: MediaQuery.of(context).size.width - 10,
              child: TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  hintText: 'Password',
                ),
              ),
            ),
            addVerticalSpace(20),
            SizedBox(
              width: MediaQuery.of(context).size.width - 10,
              child: TextField(
                controller: _userNameController,
                decoration: const InputDecoration(hintText: 'Username'),
              ),
            ),
            addVerticalSpace(20),
            SizedBox(
              width: MediaQuery.of(context).size.width - 10,
              child: TextField(
                controller: _nameController,
                decoration: const InputDecoration(hintText: 'Name'),
              ),
            ),
            addVerticalSpace(20),
            SizedBox(
              width: MediaQuery.of(context).size.width - 10,
              child: TextField(
                controller: _sirNameController,
                decoration: const InputDecoration(hintText: 'Sirname'),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                final message = await AuthService().registration(
                  email: _emailController.text,
                  password: _passwordController.text,
                  username: _userNameController.text,
                  name: _nameController.text + _sirNameController.text,
                );
                if (message!.contains('Success')) {
                  Navigator.of(context).pushReplacementNamed("login");
                }
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(message),
                  ),
                );
              },
              child: const Text('Create Account'),
            ),
          ],
        ),
      ),
    );
  }
}