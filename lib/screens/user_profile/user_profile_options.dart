import 'package:drone_2_0/data/providers/auth_provider.dart';
import 'package:drone_2_0/widgets/input.dart';
import 'package:drone_2_0/widgets/utils/error_bar.dart';
import 'package:drone_2_0/widgets/utils/helper_widgets.dart';
import 'package:flutter/material.dart';
import '../../service/user_profile_service.dart';
import '../../themes/theme_constants.dart';
import 'package:provider/provider.dart';

class UserProfileOptions extends StatefulWidget {
  const UserProfileOptions({super.key});

  @override
  State<UserProfileOptions> createState() => _UserProfileOptionsState();
}

class _UserProfileOptionsState extends State<UserProfileOptions> {
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _emailController.text = context.read<AuthProvider>().email;
    _userNameController.text = context.read<AuthProvider>().username;
    _nameController.text = context.read<AuthProvider>().fullName;
    return Scaffold(
      appBar: AppBar(
        title: const Text("User Options"),
      ),
      body: Container(
        margin: const EdgeInsets.all(Margins.stdMargin),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            stdInputField(
                icon: Icons.person_rounded,
                width: MediaQuery.of(context).size.width,
                controller: _emailController,
                hintText: "Email",
                hideText: false),
            addVerticalSpace(),
            stdInputField(
                icon: Icons.person,
                width: MediaQuery.of(context).size.width,
                controller: _userNameController,
                hintText: "Username",
                hideText: false),
            addVerticalSpace(),
            stdInputField(
                icon: Icons.person_rounded,
                width: MediaQuery.of(context).size.width,
                controller: _nameController,
                hintText: "Name",
                hideText: false),
            addVerticalSpace(),
            ElevatedButton(
                child: const Text("Save Userdata"),
                onPressed: () async {
                  final userProvider =
                      Provider.of<AuthProvider>(context, listen: false);
                  if (context.mounted) {
                    var message = await _saveUserdata(
                        userProvider,
                        _emailController.text,
                        _userNameController.text,
                        _nameController.text);
                    if (!message.contains("Success")) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        showErrorSnackBar(message),
                      );
                    }
                  }
                  // Back to UserProfile
                  Navigator.pop(context);
                })
          ],
        ),
      ),
    );
  }
}

Future<String> _saveUserdata(AuthProvider userProvider, String newEmail,
    String newUsername, String newName) async {
  String message;

  // Updating Email
  await userProvider.updateEmail(newEmail);
  //-- This operation is sensitive and requires recent authentication. Log in again before retrying this request.

  // Updating UserData in UserObject
  await userProvider.updateName(newName);
  await userProvider.updateUsername(newUsername);

  // Updating UserData in FireStore
  return UserProfileService()
      .setMultipleUserValues(userId: userProvider.userId, newUserdata: {
    "username": newUsername,
    "fullName": newName,
  });
}
