// ignore_for_file: constant_identifier_names, non_constant_identifier_names

import 'package:drone_2_0/widgets/utils/helper_widgets.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class FlightRecords extends StatefulWidget {
  const FlightRecords({super.key});

  @override
  State<FlightRecords> createState() => _FlightRecordsState();
}

class _FlightRecordsState extends State<FlightRecords> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "Current Speed",
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const VerticalSpace(),
        SfRadialGauge(
          enableLoadingAnimation: true,
          axes: <RadialAxis>[
            RadialAxis(
              minimum: 0,
              maximum: 45,
              ranges: <GaugeRange>[
                GaugeRange(
                    startValue: 0,
                    endValue: 15,
                    color: Colors.green,
                    startWidth: 10,
                    endWidth: 10),
                GaugeRange(
                    startValue: 15,
                    endValue: 25,
                    color: Colors.orange,
                    startWidth: 10,
                    endWidth: 10),
                GaugeRange(
                    startValue: 25,
                    endValue: 45,
                    color: Colors.red,
                    startWidth: 10,
                    endWidth: 10)
              ],
              pointers: const <GaugePointer>[
                NeedlePointer(value: 21),
              ],
              annotations: <GaugeAnnotation>[
                GaugeAnnotation(
                    widget: Text(1.toString(),
                        style: const TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold)),
                    angle: 90,
                    positionFactor: 0.5)
              ],
            ),
          ],
        ),
        const Text(
          "Velocity in m/s",
          //style: Theme.of(context).textTheme.displayMedium,
        ),
      ],
    );
  }
}
