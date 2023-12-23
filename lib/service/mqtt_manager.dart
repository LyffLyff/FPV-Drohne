import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'dart:async';

class MQTTManager {
  late MqttServerClient _client;
  late StreamController<String> _messageStreamController;
  late Stream<String> messageStream;
  late String _server;
  late String _clientIdentifier;

  MQTTManager(this._server, this._clientIdentifier) {
    _messageStreamController = StreamController<String>.broadcast();
    messageStream = _messageStreamController.stream;
  }

  Future<void> connect() async {
    _client = MqttServerClient(_server, _clientIdentifier);
    _client.port = 1883; // Replace with your MQTT port
    _client.logging(on: true);

    final MqttConnectMessage connMess = MqttConnectMessage()
        .withClientIdentifier(_clientIdentifier)
        .startClean()
        .withWillQos(MqttQos.atLeastOnce);

    _client.connectionMessage = connMess;

    try {
      await _client.connect();
      print('Connected to MQTT broker');

      _client.updates?.listen((List<MqttReceivedMessage<MqttMessage>> c) {
        final MqttPublishMessage recMess = c[0].payload as MqttPublishMessage;
        final String message =
            MqttPublishPayload.bytesToStringAsString(recMess.payload.message!);
        _messageStreamController.add(message);
      });
    } catch (e) {
      print('Exception: $e');
    }
  }

  void disconnect() {
    _client.disconnect();
    _messageStreamController.close();
  }

  void subscribeToTopic(String topic) {
    if (_client.connectionStatus!.state == MqttConnectionState.connected) {
      _client.subscribe(topic, MqttQos.atMostOnce);
    }
  }

  void publishMessage(String topic, String message) {
    final MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();
    builder.addString(message);
    _client.publishMessage(topic, MqttQos.atLeastOnce, builder.payload!);
  }
}
