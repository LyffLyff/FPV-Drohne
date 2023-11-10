
import 'package:drone_2_0/data/providers/auth_provider.dart';
import 'package:drone_2_0/data/providers/data_cache.dart';
import 'package:drone_2_0/service/local_storage_service.dart';
import 'package:drone_2_0/service/user_profile_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

TextEditingController textFieldController = TextEditingController();

Future<void> displayTextInputDialog(BuildContext context, int endTimestamp) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('TextField in Dialog'),
          content: TextField(
            controller: textFieldController,
            decoration: const InputDecoration(hintText: "Text Field in Dialog"),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('CANCEL'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                String newTitle = textFieldController.text;

                // update title on db
                UserProfileService().updateFlightDataProperty(context.read<AuthProvider>().userId, endTimestamp, "title", newTitle);

                // update title in local storage
                Provider.of<DataCache>(context, listen: false).updateFlightProperty(endTimestamp, "title", newTitle);

                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }