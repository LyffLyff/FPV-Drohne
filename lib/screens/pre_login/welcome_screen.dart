import 'package:drone_2_0/screens/login/registration.dart';
import 'package:drone_2_0/screens/login/login.dart';
import 'package:drone_2_0/themes/theme_constants.dart';
import 'package:drone_2_0/themes/theme_manager.dart';
import 'package:drone_2_0/widgets/utils/helper_widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../widgets/animations/animation_routes.dart';
import 'package:drone_2_0/extensions/extensions.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  static String id = "Welcome";

  @override
  Widget build(BuildContext context) {
    final logoPath = context.read<ThemeManager>().getLogoPath();
    precacheImage(AssetImage(logoPath), context);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(Margins.stdMargin),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              FadeInImage(
                image: AssetImage(context.read<ThemeManager>().getLogoPath()),
                fit: BoxFit.fill,
                placeholder:
                    AssetImage(context.read<ThemeManager>().getLogoPath()),
              ),
              const Divider(),
              const VerticalSpace(height: 8),
              Text(
                "Welcome to the \nFPV-Drone Application :)",
                textAlign: TextAlign.center,
                style: context.textTheme.bodyMedium,
              ),
              const VerticalSpace(height: 18),
              ElevatedButton(
                child: const Text("Already have an account? Sign In"),
                onPressed: () {
                  Navigator.of(context)
                      .push(pageRouteAnimation(const LoginScreen()));
                },
              ),
              ElevatedButton(
                child: const Text("Register as new User"),
                onPressed: () {
                  Navigator.of(context)
                      .push(pageRouteAnimation(const Registration()));
                },
              ),
              const Spacer(
                flex: 2,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
