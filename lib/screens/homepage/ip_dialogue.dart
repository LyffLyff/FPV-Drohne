import 'package:drone_2_0/data/shared_preferences.dart';
import 'package:drone_2_0/extensions/extensions.dart';
import 'package:drone_2_0/widgets/number_input.dart';
import 'package:drone_2_0/widgets/utils/error_bar.dart';
import 'package:drone_2_0/widgets/utils/helper_widgets.dart';
import 'package:drone_2_0/widgets/utils/validators.dart';
import 'package:flutter/material.dart';

class IpDialogue extends StatefulWidget {
  final Function(String, String, String) onDataEntered;
  final TextEditingController ipAdressController;
  final TextEditingController mqttPortController;
  final TextEditingController videoPortController;

  const IpDialogue({
    super.key,
    required this.onDataEntered,
    required this.ipAdressController,
    required this.mqttPortController,
    required this.videoPortController,
  });

  @override
  State<IpDialogue> createState() => _IpDialogueState();
}

class _IpDialogueState extends State<IpDialogue> {
  Future<void> _loadServerData() async {
    // Load Server Data from previous Sessions
    final SharedPrefs sharedPrefs = SharedPrefs();
    widget.ipAdressController.text =
        await sharedPrefs.loadSavedText("serverIp");
    widget.mqttPortController.text =
        await sharedPrefs.loadSavedText("mqttPort");
    widget.videoPortController.text =
        await sharedPrefs.loadSavedText("videoPort");
  }

  @override
  void initState() {
    super.initState();
    _loadServerData();
  }

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
          "Server Data",
          style: context.textTheme.headlineLarge,
          textAlign: TextAlign.center,
        ),
        const Spacer(
          flex: 2,
        ),
        NumberInputField(
          controller: widget.ipAdressController,
          hintText: "IPv4 Adress, e.g. 192.168.8.101",
          width: MediaQuery.sizeOf(context).width,
        ),
        const VerticalSpace(),
        NumberInputField(
          controller: widget.mqttPortController,
          hintText: "MQTT Port",
          width: MediaQuery.sizeOf(context).width,
        ),
        const VerticalSpace(),
        NumberInputField(
          controller: widget.videoPortController,
          hintText: "Livestream Port",
          width: MediaQuery.sizeOf(context).width,
        ),
        const VerticalSpace(
          height: 32,
        ),
        ElevatedButton(
          onPressed: () {
            if (!Validators.validateIpAdress(widget.ipAdressController.text)) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(defaultSnackbar("Badly formatted IP-Adress"));
            } else {
              widget.onDataEntered(
                  widget.ipAdressController.text,
                  widget.mqttPortController.text,
                  widget.videoPortController.text);
            }
          },
          child: const Text("Connect to Server...."),
        ),
        const Spacer(
          flex: 2,
        ),
      ],
    );
  }
}
