import 'package:drone_2_0/data/providers/logging_provider.dart';
import 'package:drone_2_0/extensions/extensions.dart';
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
  double pitchOffset = -10;

  double ambientValue = 0.055;
  double diffuseValue = 0.995;
  double specularValue = 1;

  final double modelWidgetHeight = 400;

  double val = 0;

  //Adjustable Yaw Offset
  List<double> offsets = [0, 90, 180, 270];
  int offsetIndex = 0;

  bool initialized = false;
  late final MQTTManager mqttManager;
  late Scene _model;
  Object? _cube;

  void _onSceneCreated(Scene scene) {
    _model = scene;
    scene.light
        .setColor(Colors.white, ambientValue, diffuseValue, diffuseValue);
    scene.light.position.setFrom(Vector3(-500, 1400, -450));
    _cube = Object(
      fileName: 'assets/models/drone.obj',
      lighting: true,
      backfaceCulling: true,
      scale: Vector3.all(8),
      rotation: Vector3(pitchOffset, offsets[offsetIndex], 0),
    ); // X -> Nose up / down , Y -> Rotation in Plane (Camera Look away / to you), Z -> Wings up/down;
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
        _cube?.rotation.x = rotationData[ModelAxis.pitch.index] + pitchOffset;
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
          if (snapshot.connectionState != ConnectionState.waiting) {
            initialized = true;
          }
          return Column(
            children: [
              initialized
                  ? SizedBox(
                      width: MediaQuery.sizeOf(context).width,
                      height: modelWidgetHeight,
                      child: Cube(
                        interactive:
                            false, // only interaction through MQTT -> Pitch, Roll, Yaw
                        onSceneCreated: _onSceneCreated,
                      ),
                    )
                  : Visibility(
                      visible:
                          snapshot.connectionState == ConnectionState.waiting,
                      child: SizedBox(
                        height: modelWidgetHeight,
                        child: const AwaitingConnection(),
                      ),
                    ),
              const Divider(),
              DecoratedBox(
                decoration: BoxDecoration(
                    color: context.colorScheme.secondary,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(16)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () {
                        // incrementing offsetIndex
                        setState(() {
                          offsetIndex += 1;
                          offsetIndex %= offsets.length;
                          _cube?.rotation.y = offsets[offsetIndex];
                          updateModel();
                        });
                      },
                      icon: const Icon(Icons.rotate_left_rounded),
                    ),
                  ],
                ),
              ),
              Slider(
                label: 'Ambient',
                max: 2000,
                min: -1000,
                value: ambientValue,
                onChanged: (value) {
                  setState(() {
                    ambientValue = value;
                    print(value);
                    // Last = small
                    // Middle > 100
                    // First = value
                    _model.light.position.setFrom(Vector3(-500, 1400, -450));
                    updateModel();
                  });
                },
              ),
            ],
          );
        });
  }
}
