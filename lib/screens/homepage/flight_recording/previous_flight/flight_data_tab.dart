import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class FlightDataTab extends StatefulWidget {
  final String chartTitle;
  final String xAxisTitle;
  final String yAxisTitle;
  final String measurementUnit;

  final List<ChartData> flightDataValues;

  const FlightDataTab(
      {super.key,
      required this.chartTitle,
      required this.xAxisTitle,
      required this.yAxisTitle,
      required this.flightDataValues,
      required this.measurementUnit});

  @override
  State<FlightDataTab> createState() => _FlightDataTabState();
}

class _FlightDataTabState extends State<FlightDataTab> {
  late num maxValue;
  late num minValue;
  late num avg;

  @override
  void initState() {
    super.initState();
    _calculateDataProperties();
  }

  @override
  void didUpdateWidget(covariant FlightDataTab oldWidget) {
    // updating values when switchint pages -> initState only called on initial build
    if (widget.flightDataValues != oldWidget.flightDataValues) {
      _calculateDataProperties();
    }
    super.didUpdateWidget(oldWidget);
  }

  void _calculateDataProperties() {
    // Calculate max, min and average values
    try {
      maxValue = widget.flightDataValues
              .map((datapoint) => datapoint.y)
              .reduce((a, b) => a! > b! ? a : b) ??
          0;
      minValue = widget.flightDataValues
              .map((datapoint) => datapoint.y)
              .reduce((a, b) => a! < b! ? a : b) ??
          0;
      avg = num.parse((widget.flightDataValues
                  .map((datapoint) => datapoint.y)
                  .reduce((a, b) => a! + b!)! /
              widget.flightDataValues.length)
          .toStringAsFixed(3));
    } catch (e) {
      maxValue = minValue = avg = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SfCartesianChart(
          // Initialize category axis
          primaryXAxis: CategoryAxis(zoomFactor: 0.5),
          enableAxisAnimation: true,
          zoomPanBehavior: ZoomPanBehavior(

              /// To enable the pinch zooming as true.
              enablePinching: true,
              zoomMode: ZoomMode.x,
              enablePanning: true,
              enableMouseWheelZooming: false),
          indicators: <TechnicalIndicators>[
            MomentumIndicator(
              isVisible: true,
              period: 1,
              seriesName: 'help',
            )
          ],
          series: <ChartSeries>[
            // Initialize line series
            LineSeries<ChartData, num>(
              name: "help",
              dataSource: widget.flightDataValues,
              xValueMapper: (ChartData data, _) => data.x,
              yValueMapper: (ChartData data, _) => data.y,
            ),
            LineSeries<ChartData2, num>(
              dataSource: <ChartData2>[
                ChartData2(0, avg), // Start point at x = 0, y = 40
                ChartData2(30, avg.toDouble()), // End point at x = 30, y = 40
              ],
              xValueMapper: (ChartData2 data, _) => data.x,
              yValueMapper: (ChartData2 data, _) => data.y,
              // Customize line appearance as needed
              color: const Color.fromARGB(
                  255, 243, 33, 170), // Set your desired line color
              /*trendlines: [
                Trendline(type: TrendlineType.logarithmic),
              ],*/

              width: 1, // Adjust line width if necessary
            ),
          ],
        ),
        Text("Peak: $maxValue ${widget.measurementUnit}"),
        Text("Min: $minValue ${widget.measurementUnit}"),
        Text("Avg.: $avg ${widget.measurementUnit}"),
      ],
    );
  }
}

class ChartData {
  ChartData(this.x, this.y);
  final num x;
  final num? y;
}

class ChartData2 {
  ChartData2(this.x, this.y);

  final num x;
  final num y;
}
