import 'package:drone_2_0/data/providers/logging_provider.dart';
import 'package:drone_2_0/screens/homepage/flight_recording/flight_data_recording/awaiting_connection_dialogue.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cube/flutter_cube.dart';
import 'package:drone_2_0/service/mqtt_manager.dart';

enum ModelAxis { pitch, roll, yaw }

class DroneModelViewer extends StatefulWidget {
  final String? title;
  final String ipAdress;
  final int port;

  const DroneModelViewer({
    Key? key,
    this.title,
    required this.ipAdress,
    required this.port,
  }) : super(key: key);

  @override
  DroneModelViewerState createState() => DroneModelViewerState();
}

class DroneModelViewerState extends State<DroneModelViewer> {
  double xRotation = 0; // PITCH
  double yRotation = 0; // YAW
  double zRotation = 0; // ROLL
  double yawOffset = 20; // Offset for Model to look at camera
  bool initialized = false;
  late final MQTTManager mqttManager;
  late Scene _model;
  Object? _cube;

  void _onSceneCreated(Scene scene) {
    _model = scene;
    _cube = Object(
      fileName: 'assets/models/drone.obj',
      lighting: true,
      backfaceCulling: true,
      scale: Vector3.all(8),
      rotation: Vector3(yawOffset, 0, 0),
    ); // X -> Upside Down, Y -> Rotation in Plane (Camera Look away / to you), Z -> Upside Down;
    _model.world.add(_cube!);
  }

  void updateModel() {
    _cube?.updateTransform();
    _model.update();
  }

  Future<bool> _rotationManagerInit() async {
    bool connection = await mqttManager.connect();

    if (connection) {
      mqttManager.subscribeToTopic("data/rotation");
      Logging.info("Subscribed to Rotation Topic");
      mqttManager.messageStream.listen((event) {
        List<double> rotationData = [];
        event.values.first.split(" ").forEach((element) {
          // converting split list of strings to the rotation values as floating point
          rotationData.add(double.parse(element));
        });
        Logging.info(rotationData);
        _cube?.rotation.z = rotationData[ModelAxis.roll.index];
        _cube?.rotation.y = rotationData[ModelAxis.yaw.index] + yawOffset;
        _cube?.rotation.x = rotationData[ModelAxis.pitch.index];
        updateModel();
      });
    }
    return connection;
  }

  @override
  void initState() {
    super.initState();
    mqttManager = MQTTManager(widget.ipAdress, widget.port, "3D-Model-Viewer");
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
        future: initialized ? null : _rotationManagerInit(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const AwaitingConnection();
          }
          initialized = true;
          return Column(
            children: [
              SizedBox(
                width: MediaQuery.sizeOf(context).width,
                height: 400,
                child: Cube(
                  interactive:
                      false, // only interaction through MQTT -> Pitch, Roll, Yaw
                  onSceneCreated: _onSceneCreated,
                ),
              ),
              Slider.adaptive(
                value: yRotation,
                min: -180.0,
                max: 180.0,
                onChanged: (newVal) {
                  setState(() {
                    yRotation = newVal;
                    _cube?.rotation.y = newVal;
                    _cube?.updateTransform();
                    _model.update();
                  });
                },
              )
            ],
          );
        });
  }
}
