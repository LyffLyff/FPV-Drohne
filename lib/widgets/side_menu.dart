import 'package:drone_2_0/screens/pre_login/welcome_screen.dart';
import 'package:drone_2_0/screens/settings/settings.dart';
import 'package:drone_2_0/screens/user_profile/user_profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/providers/user_model.dart';

class NavDrawer extends StatelessWidget {
  const NavDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    void logout() async {
      await FirebaseAuth.instance.signOut();
      // ignore: use_build_context_synchronously
      Navigator.pushReplacementNamed(context, WelcomeScreen.id);
    }

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).canvasColor,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  const CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(
                      'https://source.unsplash.com/200x200/?portrait',
                    ),
                  ),
                  Text(
                    Provider.of<UserProvider>(context).username,
                    textAlign: TextAlign.center,
                  ),
                ],
              )),
          ListTile(
            leading: const Icon(Icons.account_box),
            title: const Text('Profile'),
            onTap: () => {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const UserProfile()),
              ),
            },
          ),
          ListTile(
            leading: const Icon(Icons.input),
            title: const Text('Logout'),
            onTap: () => {logout()},
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () => {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const SettingsScreen(),
                ),
              ),
            },
          ),
        ],
      ),
    );
  }
}
