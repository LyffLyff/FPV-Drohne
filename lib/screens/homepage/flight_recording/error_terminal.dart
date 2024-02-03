import 'package:drone_2_0/screens/general/error/failed_connection.dart';
import 'package:drone_2_0/screens/homepage/flight_recording/flight_data_recording/awaiting_connection_dialogue.dart';
import 'package:drone_2_0/service/mqtt_manager.dart';
import 'package:flutter/widgets.dart';

class ErrorTerminal extends StatefulWidget {
  final MQTTManager mqttManager;

  const ErrorTerminal({super.key, required this.mqttManager});

  @override
  State<ErrorTerminal> createState() => _ErrorTerminalState();
}

class _ErrorTerminalState extends State<ErrorTerminal> {
  Future<void> initErrorTerminal() async {
    widget.mqttManager.subscribeToTopic("data/error_messages");
  }

  @override
  void initState() {
    super.initState();

    initErrorTerminal();
  }

  @override
  Widget build(BuildContext context) {
    String errorMessages = "";
    return Expanded(
        child: SingleChildScrollView(
      child: StreamBuilder<Object>(
        stream: widget.mqttManager.messageStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Text("$errorMessages\n>");
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const AwaitingConnection();
          } else {
            return const ConnectionError();
          }
        },
      ),
    ));
  }
}
