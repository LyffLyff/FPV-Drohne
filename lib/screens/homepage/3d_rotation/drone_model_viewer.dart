import 'package:drone_2_0/screens/homepage/flight_recording/flight_data_recording/awaiting_connection_dialogue.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cube/flutter_cube.dart';
import 'package:drone_2_0/service/mqtt_manager.dart';

enum ModelAxis { yaw, roll, pitch }

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
  bool initialized = false;
  late final MQTTManager mqttManager;
  late Scene _model;
  Object? _cube;

  void _onSceneCreated(Scene scene) {
    _model = scene;
    _cube = Object(
      fileName: 'assets/models/drone.obj',
      lighting: true,
      scale: Vector3.all(8),
      rotation: Vector3(0, 0, 0),
    ); // X -> Upside Down, Y -> Rotation in Plane (Camera Look away / to you), Z -> Upside Down;
    _model.world.add(_cube!);
  }

  void updateModel() {
    _cube?.updateTransform();
    _model.update();
  }

  Future<bool> _rotationManagerInit() async {
    bool error = await mqttManager.connect();
    if (!error) {
      mqttManager.subscribeToTopic("data/rotation");
      mqttManager.messageStream.listen((event) {
        List<double> rotationData = [];
        event.values.first.split(" ").forEach((element) {
          // converting split list of strings to the rotation values as floating point
          rotationData.add(double.parse(element));
        });
        _cube?.rotation.z = rotationData[ModelAxis.pitch.index];
        _cube?.rotation.y = rotationData[ModelAxis.yaw.index];
        _cube?.rotation.x = rotationData[ModelAxis.roll.index];
        updateModel();
      });
    }
    return error;
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
                    _cube?.rotation.z = newVal;
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
