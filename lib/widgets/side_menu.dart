import 'package:drone_2_0/screens/pre_login/welcome_screen.dart';
import 'package:drone_2_0/screens/settings/settings.dart';
import 'package:drone_2_0/screens/user_profile/user_profile.dart';
import 'package:drone_2_0/widgets/animations/animation_routes.dart';
import 'package:drone_2_0/widgets/profile_image.dart';
import 'package:drone_2_0/widgets/utils/helper_widgets.dart';
import 'package:drone_2_0/widgets/utils/radial_expansion.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/providers/auth_provider.dart';

class NavDrawer extends StatelessWidget {
  const NavDrawer({super.key});

  static double kMinRadius = 80.0;
  static double kMaxRadius = 160.0;

  @override
  Drawer build(BuildContext context) {
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
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      // Navigate to a different screen when the image is tapped
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const UserProfile(), // Replace with the screen you want to navigate to
                        ),
                      );
                    },
                    child: SizedBox(
                      width: kMaxRadius / 2.0,
                      height: kMaxRadius / 2.0,
                      child: Hero(
                        tag: "profile_image",
                        child: RadialExpansion(
                          maxRadius: kMaxRadius,
                          child: profileImage(context.read<AuthProvider>().storageUrl, context.read<AuthProvider>().profileImageDownloadURL),
                        ),
                      ),
                    ),
                  ),
                  const VerticalSpace(height: 10),
                  Text(
                    Provider.of<AuthProvider>(context).username,
                    textAlign: TextAlign.start,
                    style: Theme.of(context).textTheme.bodyMedium,
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
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () => {
              Navigator.of(context)
                  .push(pageRouteAnimation(const SettingsScreen())),
            },
          ),
          ListTile(
            leading: const Icon(Icons.input),
            title: const Text('Logout'),
            onTap: () => {logout()},
          ),
        ],
      ),
    );
  }
}
