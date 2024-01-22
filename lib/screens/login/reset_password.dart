import 'package:drone_2_0/data/providers/auth_provider.dart';
import 'package:drone_2_0/widgets/input.dart';
import 'package:drone_2_0/widgets/utils/error_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ResetPassword extends StatelessWidget {
  const ResetPassword({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController controller = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Reset Password"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            StdInputField(
                hintText: "Email-Address",
                width: MediaQuery.sizeOf(context).width,
                hideText: false,
                controller: controller),
            IconButton(
                onPressed: () async {
                  String message = await context
                      .read<AuthenticationProvider>()
                      .resetPassword(email: controller.text);
                  if (!context.mounted) {
                    return;
                  }
                  ScaffoldMessenger.of(context)
                      .showSnackBar(errorSnackbar(message));
                },
                icon: const Icon(Icons.send))
          ],
        ),
      ),
    );
  }
}
