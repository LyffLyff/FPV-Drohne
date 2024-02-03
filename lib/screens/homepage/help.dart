import 'package:drone_2_0/extensions/extensions.dart';
import 'package:flutter/material.dart';

class HelpSection extends StatefulWidget {
  const HelpSection({super.key});

  @override
  State<HelpSection> createState() => _HelpSectionState();
}

class _HelpSectionState extends State<HelpSection> {
  Map<String, String> data = {
    "Drone always offline":
        """This error occurs when the specified 'isOnline'-Flag hasn't been set by the ground stations script.

So, either the ground stations hasn't been set-up correctly or there is a problem with the script not interfacing correctly with the database""",
    "Stuck on Load":
        """When the app is stuck on the 'Awaiting Connection'-Screen there is a problem connecting with the MQTT-Server which serves the flight-data from the ground station.
This could be caused by setting the wrong Server-IP-Adress or Port when initially starting the flight recording.

Try to leave the 'Port'-Fields to set the default Port for the Servers and check if the IP-Adress matches with the one from the ground station.
    """,
    "App Crashes":
        """When the App stays stuck on a certain screen or closes unexpectedly, there most likely occurred a crash due to a bug in the code.
If you encounter such a problem be sure to tell us when and how this error happend to you via our teams E-mail "team.fpv.drohne@gmail.com"
    """,
    "Open Source?":
        """All code from this diploma project, including this application aswell as the custom flight controller code on the drone itself is publicly available and can be accessed via the following links:

App: 
https://github.com/LyffLyff/FPV-Drohne

Embedded Code: 
https://github.com/FrogMoment/FPV_Drohne_202324
    """,
  };

  late List<bool> expandedTiles;

  IconData getIcon(int idx) {
    return expandedTiles[idx]
        ? Icons.arrow_drop_down_circle
        : Icons.arrow_drop_down;
  }

  @override
  void initState() {
    super.initState();

    expandedTiles = List<bool>.filled(
      data.length,
      false,
      growable: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Close"),
      ),
      body: ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          return ExpansionTile(
            title: Text(
              data.keys.elementAt(index),
              style: context.textTheme.headlineMedium,
            ),
            trailing: Icon(getIcon(index)),
            children: <Widget>[
              ListTile(
                  title: Text(
                data.values.elementAt(index),
                style: context.textTheme.bodySmall,
              )),
            ],
            onExpansionChanged: (bool isExpanded) {
              setState(() {
                expandedTiles[index] = isExpanded;
              });
            },
          );
        },
      ),
    );
  }
}
