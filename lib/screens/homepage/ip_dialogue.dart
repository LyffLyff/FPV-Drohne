import 'package:drone_2_0/extensions/extensions.dart';
import 'package:drone_2_0/widgets/input.dart';
import 'package:drone_2_0/widgets/utils/error_bar.dart';
import 'package:drone_2_0/widgets/utils/validators.dart';
import 'package:flutter/material.dart';

class IpDialogue extends StatelessWidget {
  final VoidCallback onDataEntered;
  final TextEditingController ipAdressController;

  const IpDialogue(
      {super.key,
      required this.onDataEntered,
      required this.ipAdressController});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Spacer(
          flex: 1,
        ),
        Text(
          "Enter Server Data",
          style: context.textTheme.headlineLarge,
        ),
        const Spacer(
          flex: 2,
        ),
        StdInputField(
          controller: ipAdressController,
          hintText: "IPv4 Adress of Server",
          hideText: false,
          width: MediaQuery.sizeOf(context).width,
        ),
        ElevatedButton(
          onPressed: () {
            if (!Validators.validateIpAdress(ipAdressController.text)) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(errorSnackbar("Badly formatted IP-Adress"));
            } else {
              onDataEntered();
            }
          },
          child: const Text("Enter Data"),
        ),
        const Spacer(
          flex: 2,
        ),
      ],
    );
  }
}
