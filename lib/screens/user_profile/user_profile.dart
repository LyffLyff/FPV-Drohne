import 'package:drone_2_0/screens/user_profile/user_profile_options.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../themes/theme_constants.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  static String id = "UserProfile";

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("User Profile"),
        actions: [
          IconButton(
              tooltip: "Exit Application",
              onPressed: () {
                debugPrint("Exiting Application");
                SystemNavigator.pop();
              },
              icon: const Icon(Icons.exit_to_app)),
        ],
      ),
      body: Container(
        margin: const EdgeInsets.all(Margins.stdMargin),
        child: Column(
          children: [
          Center(
            child: CircleAvatar(
              radius: MediaQuery.of(context).size.width / 4,
              backgroundImage: const NetworkImage(
                'https://source.unsplash.com/200x200/?portrait',
              ),
            ),
          ),
          const Divider(
            height: 10,
            thickness: 5,
            indent: 0,
            endIndent: 0,
            color: Colors.black,
          ),
          const Text("Username"),
          const Text("Email"),
           TextButton(
            child: const Text("Edit Userdata"),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => UserProfileOptions())
              );
            },
          )
        ]),
      ),
    );
  }
}
