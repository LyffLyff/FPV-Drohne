import 'package:flutter/material.dart';
import 'package:flutter_cube/flutter_cube.dart';
import 'package:drone_2_0/service/mqtt_manager.dart';

class DroneModelViewer extends StatefulWidget {
  const DroneModelViewer({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  DroneModelViewerState createState() => DroneModelViewerState();
}

class DroneModelViewerState extends State<DroneModelViewer> {
  double yRotation = 0;
  double xRotation = 0;
  late final MQTTManager mqttManager;
  late Scene _model;
  Object? _cube;

  void _onSceneCreated(Scene scene) {
    _model = scene;
    _cube = Object(
      fileName: 'assets/models/drone.obj',
      lighting: true,
      scale: Vector3.all(10),
      rotation: Vector3(xRotation, yRotation, 0),
    ); // X -> Upside Down, Y -> Rotation in Plane (Camera Look away / to you), Z -> Upside Down;
    _model.world.add(_cube!);
  }

  @override
  void initState() {
    super.initState();

    mqttManager = MQTTManager("192.168.0.105", 1883, "3D-Model-Viewer");
  }

  @override
  Widget build(BuildContext context) {
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
          min: 0.0,
          max: 360.0,
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
  }
}
