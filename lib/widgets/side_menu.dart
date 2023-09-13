import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drone_2_0/screens/homepage/homepage.dart';
import 'package:drone_2_0/screens/settings/settings.dart';
import 'package:drone_2_0/screens/user_profile/user_profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NavDrawer extends StatelessWidget {
  const NavDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    void logout() async {
      await FirebaseAuth.instance.signOut();
      // ignore: use_build_context_synchronously
      Navigator.pushReplacementNamed(context, HomePage.id);
    }

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).canvasColor,
              ),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: NetworkImage(
                      'https://source.unsplash.com/200x200/?portrait',
                    ),
                  ),
                  Text(
                    'Username',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
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
