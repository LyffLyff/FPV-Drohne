import 'package:drone_2_0/extensions/extensions.dart';
import 'package:flutter/material.dart';

class SpecialScreen extends StatelessWidget {
  const SpecialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Spacer(),
          Text(
            "RUN!!!",
            style: context.textTheme.headlineLarge,
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: Image.asset(
              "assets/videos/secret.gif",
              fit: BoxFit.fill,
              filterQuality: FilterQuality.medium,
            ),
          ),
          const Spacer(
            flex: 2,
          ),
        ],
      ),
    );
  }
}
