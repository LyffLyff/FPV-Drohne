import 'package:drone_2_0/data/providers/logging_provider.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'dart:async';

class MQTTManager {
  late MqttServerClient _client;
  late final StreamController<Map<String, String>> _messageStreamController;
  Stream<Map<String, String>> get messageStream =>
      _messageStreamController.stream;

  late final String _serverIp;
  late final int _port;
  late final String _clientIdentifier;

  MQTTManager(this._serverIp, this._port, this._clientIdentifier) {
    _messageStreamController =
        StreamController<Map<String, String>>.broadcast();
  }

  Future<bool> connect() async {
    _client = MqttServerClient(_serverIp, _clientIdentifier,
        maxConnectionAttempts: 3);
    _client.port = _port;
    _client.logging(on: false);

    _client.onDisconnected = onDisconnected;
    _client.onConnected = onConnected;

    final MqttConnectMessage connMess = MqttConnectMessage()
        .withClientIdentifier(_clientIdentifier)
        .startClean();

    _client.connectionMessage = connMess;

    try {
      await _client.connect();

      // listening to received messages from the connected broker
      _client.updates?.listen((List<MqttReceivedMessage<MqttMessage>> event) {
        for (MqttReceivedMessage<MqttMessage> message in event) {
          if (message.payload is MqttPublishMessage) {
            final MqttPublishMessage publishMessage =
                message.payload as MqttPublishMessage;
            // convert databytes to string
            final String payload = MqttPublishPayload.bytesToStringAsString(
                publishMessage.payload.message);
            final String topic = message.topic;

            // Add the message to the stream
            _messageStreamController.add({topic: payload});
          }
        }
      });

      // listen to connection errors
      return true;
    } catch (e) {
      // Exception during connection or listening attempt
      Logging.error('MQTT EXCEPTION: $e');
    }
    return false;
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

  void onDisconnected() {
    Logging.info("MQTT: CLIENT DISCONNECTED");
  }

  void onConnected() {
    Logging.info("MQTT: CLIENT CONNECTED TO BROKER -> $_serverIp:$_port");
  }

  void disconnect() {
    _client.disconnect();
    _messageStreamController.close();
  }
}
