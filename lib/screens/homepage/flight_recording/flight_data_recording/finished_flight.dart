import 'package:drone_2_0/data/providers/auth_provider.dart';
import 'package:drone_2_0/data/providers/data_cache.dart';
import 'package:drone_2_0/extensions/extensions.dart';
import 'package:drone_2_0/screens/homepage/flight_recording/previous_flight/weather_selection.dart';
import 'package:drone_2_0/service/user_profile_service.dart';
import 'package:drone_2_0/widgets/input.dart';
import 'package:drone_2_0/widgets/utils/helper_widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class FinishedFlight extends StatelessWidget {
  final int endTimestamp;

  FinishedFlight({super.key, required this.endTimestamp});

  final TextEditingController textFieldController = TextEditingController();
  String _weatherIcon = "wi-cloud";

  void _saveFlightProperties(BuildContext context) {
    String newTitle = textFieldController.text;

    // update title on db
    UserProfileService().updateFlightDataProperty(
        context.read<AuthenticationProvider>().userId,
        endTimestamp,
        "title",
        newTitle);

    // update title in local storage
    Provider.of<DataCache>(context, listen: false)
        .updateFlightProperty(endTimestamp, "title", newTitle);

    // update weather icon on db
    UserProfileService().updateFlightDataProperty(
        context.read<AuthenticationProvider>().userId,
        endTimestamp,
        "weather",
        _weatherIcon);

    // update weather in local storage
    Provider.of<DataCache>(context, listen: false)
        .updateFlightProperty(endTimestamp, "weather", _weatherIcon);

    // hide dialogue
    Navigator.pop(context);
  }

  void _setWeatherSelection(String weatherIcon) {
    _weatherIcon = weatherIcon;
  }

  @override
  Widget build(BuildContext context) {
    // Init Title Controller
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(endTimestamp);
    textFieldController.text =
        "${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}:${dateTime.second.toString().padLeft(2, '0')}";

    return Scaffold(
      appBar: AppBar(
        title: const Text("Dispose Flight"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Spacer(),
            Text(
              "Flight's finished!",
              style: context.textTheme.headlineLarge,
            ),
            const Spacer(),
            StdInputField(
              controller: textFieldController,
              hideText: false,
              width: MediaQuery.sizeOf(context).width,
              hintText: 'Title',
            ),
            const VerticalSpace(),
            WeatherSelection(
              selectionCallback: _setWeatherSelection,
            ),
            const VerticalSpace(),
            ElevatedButton(
              child: Text('Save Flight', style: context.textTheme.displaySmall),
              onPressed: () {
                _saveFlightProperties(context);
              },
            ),
            const Spacer(
              flex: 3,
            ),
          ],
        ),
      ),
    );
  }
}
