// ignore_for_file: use_build_context_synchronously

import 'package:drone_2_0/data/providers/data_cache.dart';
import 'package:drone_2_0/data/providers/logging_provider.dart';
import 'package:drone_2_0/screens/homepage/app_info.dart';
import 'package:drone_2_0/screens/homepage/flight_recording/previous_flight/previous_flights.dart';
import 'package:drone_2_0/screens/homepage/help.dart';
import 'package:drone_2_0/screens/pre_login/welcome_screen.dart';
import 'package:drone_2_0/screens/settings/settings.dart';
import 'package:drone_2_0/screens/user_profile/user_profile.dart';
import 'package:drone_2_0/widgets/animations/animation_routes.dart';
import 'package:drone_2_0/widgets/profile_image.dart';
import 'package:drone_2_0/widgets/utils/helper_widgets.dart';
import 'package:drone_2_0/widgets/utils/radial_expansion.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import '../data/providers/auth_provider.dart';
import 'package:drone_2_0/extensions/extensions.dart';

class NavDrawer extends StatelessWidget {
  const NavDrawer({super.key});

  static double kMinRadius = 80.0;
  static double kMaxRadius = 160.0;

  @override
  Drawer build(BuildContext context) {
    void logout() async {
      // Google Sign Out
      try {
        await GoogleSignIn().disconnect();
      } catch (e) {
        Logging.debug('Failed to disconnect on signout');
      }

      // Clear Datacache -> preventing seeing false previousFlights
      Provider.of<DataCache>(context, listen: false).previousFlights.clear();

      // Auth Sign Out
      await FirebaseAuth.instance.signOut();
      Navigator.pushReplacementNamed(
        context,
        WelcomeScreen.id,
      );
    }

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: context.colorScheme.background,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
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
                    width: kMaxRadius / 1.6,
                    height: kMaxRadius / 1.6,
                    child: Hero(
                      tag: "profile_image",
                      child: RadialExpansion(
                        maxRadius: kMaxRadius,
                        child: profileImage(
                            context.read<AuthenticationProvider>().storageUrl,
                            context
                                .read<AuthenticationProvider>()
                                .profileImageDownloadURL),
                      ),
                    ),
                  ),
                ),
                const VerticalSpace(height: 10),
                SizedBox(
                  height: 25,
                  child: Text(
                    Provider.of<AuthenticationProvider>(context).username,
                    textAlign: TextAlign.start,
                    overflow: TextOverflow.fade,
                    softWrap: false,
                    style: context.textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.account_box),
            titleAlignment: ListTileTitleAlignment.center,
            title: Text(
              'Profile',
              style: context.textTheme.displayMedium,
            ),
            onTap: () => {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const UserProfile()),
              ),
            },
          ),
          ListTile(
            leading: const Icon(Icons.insights),
            titleAlignment: ListTileTitleAlignment.center,
            title: Text(
              'Previous Flights',
              style: context.textTheme.displayMedium,
            ),
            onTap: () => {
              Navigator.of(context).push(
                pageRouteAnimation(const PreviousFlights()),
              ),
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            titleAlignment: ListTileTitleAlignment.center,
            title: Text(
              'Settings',
              style: context.textTheme.displayMedium,
            ),
            onTap: () => {
              Navigator.of(context)
                  .push(pageRouteAnimation(const SettingsScreen())),
            },
          ),
          ListTile(
            leading: const Icon(Icons.info),
            titleAlignment: ListTileTitleAlignment.center,
            title: Text(
              'App Info',
              style: context.textTheme.displayMedium,
            ),
            onTap: () => {
              Navigator.of(context).push(pageRouteAnimation(const AppInfo())),
            },
          ),
          ListTile(
            leading: const Icon(Icons.question_answer_rounded),
            titleAlignment: ListTileTitleAlignment.center,
            title: Text(
              'Help / FAQ',
              style: context.textTheme.displayMedium,
            ),
            onTap: () => {
              Navigator.of(context)
                  .push(pageRouteAnimation(const HelpSection())),
            },
          ),
          ListTile(
            leading: const Icon(Icons.input),
            titleAlignment: ListTileTitleAlignment.center,
            title: Text(
              'Logout',
              style: context.textTheme.displayMedium,
            ),
            onTap: () => {logout()},
          ),
        ],
      ),
    );
  }
}
