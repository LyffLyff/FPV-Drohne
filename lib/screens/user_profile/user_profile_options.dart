import 'package:drone_2_0/widgets/input.dart';
import 'package:drone_2_0/widgets/utils/error_bar.dart';
import 'package:drone_2_0/widgets/utils/helper_widgets.dart';
import 'package:flutter/material.dart';
import '../../data/providers/user_provider.dart';
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
    _emailController.text = context.read<UserProvider>().email;
    _userNameController.text = context.read<UserProvider>().username;
    _nameController.text = context.read<UserProvider>().name;
    return Consumer<UserProvider>(
      builder: (context, value, child) => Scaffold(
        appBar: AppBar(
          title: const Text("User Options"),
        ),
        body: Container(
          margin: const EdgeInsets.all(Margins.stdMargin),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              /*stdInputField(
              width: MediaQuery.of(context).size.width,
              controller: _emailController,
              hintText: "Email",
              hideText: false
            ),*/
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
                    if (context.mounted) {
                      String message;
                      // Updating Username
                      message = await UserProfileService().editDocumentField(
                          collection: "users",
                          document:
                              Provider.of<UserProvider>(context, listen: false)
                                  .email,
                          fieldTitle: "username",
                          newFieldValue: _userNameController.text);
                      // ignore: use_build_context_synchronously
                      Provider.of<UserProvider>(context, listen: false)
                          .changeUsername(_userNameController.text);

                      // Updating Name
                      message = await UserProfileService().editDocumentField(
                          collection: "users",
                          document:
                              // ignore: use_build_context_synchronously
                              Provider.of<UserProvider>(context, listen: false)
                                  .email,
                          fieldTitle: "name",
                          newFieldValue: _nameController.text);
                      Provider.of<UserProvider>(context, listen: false)
                          .changeName(_nameController.text);
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
      ),
    );
  }
}
