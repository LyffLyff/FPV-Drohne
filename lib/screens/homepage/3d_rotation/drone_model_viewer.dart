import 'package:drone_2_0/data/providers/logging_provider.dart';
import 'package:drone_2_0/extensions/extensions.dart';
import 'package:drone_2_0/screens/homepage/flight_recording/flight_data_recording/awaiting_connection_dialogue.dart';
import 'package:drone_2_0/widgets/utils/helper_widgets.dart';
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
  double pitchOffset = -10;

  final double ambientValue = 0.055;
  final double diffuseValue = 0.995;
  final double specularValue = 1;

  // Slider
  double fov = 80;
  double yawOffset = 0; // Offset for Model to look at camera
  double sliderTextWidth = 92;

  final double modelWidgetHeight = 400;

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
    ); // X -> Nose up / down , Y -> Rotation in Plane (Camera way / to you), Z -> Wings up/down;
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
              initialized || true
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
              const VerticalSpace(
                height: 8,
              ),
              DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: context.colorScheme.primary),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            width: sliderTextWidth,
                            child: const Text(
                              "Scale:",
                              textAlign: TextAlign.end,
                            ),
                          ),
                          Expanded(
                            child: Slider(
                              label: 'Scale',
                              max: 150,
                              min: 50,
                              value: fov,
                              onChanged: (value) {
                                setState(() {
                                  fov = value;
                                  _model.camera.fov = fov;
                                  updateModel();
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: sliderTextWidth,
                            child: const Text(
                              "Rotation:",
                              textAlign: TextAlign.end,
                            ),
                          ),
                          Expanded(
                            child: Slider(
                              label: 'Yaw-Offset',
                              max: 180,
                              min: -180,
                              value: yawOffset,
                              onChanged: (value) {
                                setState(() {
                                  yawOffset = value;
                                  _cube?.rotation.y = yawOffset;
                                  updateModel();
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        });
  }
}
