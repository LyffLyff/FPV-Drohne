import 'package:drone_2_0/servide/auth/auth_service.dart';
import 'package:drone_2_0/widgets/input.dart';
import 'package:drone_2_0/widgets/utils/helper_widgets.dart';
import 'package:flutter/material.dart';
import '../../data/providers/user_model.dart';
import '../../servide/user_profile_service.dart';
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
    _emailController.text = context.read<UserProvider>().email;
    _userNameController.text = context.read<UserProvider>().username;
    return Consumer<UserProvider>(builder: (context, value, child) => Scaffold(
      appBar: AppBar(
        title: const Text("User Options"),
      ),
      body: Container(
        margin: const EdgeInsets.all(Margins.stdMargin),
        child: Column(
          children: [
            stdInputField(
              width: MediaQuery.of(context).size.width,
              controller: _emailController,
              hintText: "Email",
              hideText: false
            ),
            addVerticalSpace(20),
            stdInputField(
              width: MediaQuery.of(context).size.width,
              controller: _userNameController,
              hintText: "Username",
              hideText: false
            ),
            addVerticalSpace(20),
            stdInputField(
              width: MediaQuery.of(context).size.width,
              controller: _nameController,
              hintText: "Name",
              hideText: false
            ),
            addVerticalSpace(20),
            TextButton(child: Text("Save Userdata"), onPressed: () async {
              UserProfileService().editDocumentField(collection: "users", document: Provider.of<UserProvider>(context, listen: false).email, fieldTitle: "username", newFieldValue: _userNameController.text);
              UserProfileService().editDocumentField(collection: "users", document: Provider.of<UserProvider>(context, listen: false).email, fieldTitle: "name", newFieldValue: _nameController.text);
            })
          ],
        ),
      ),
    ),
    );
    }
}