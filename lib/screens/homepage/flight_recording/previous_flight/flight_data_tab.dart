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
    maxValue = widget.flightDataValues
            .map((datapoint) => datapoint.y)
            .reduce((a, b) => a! > b! ? a : b) ??
        0;
    minValue = widget.flightDataValues
            .map((datapoint) => datapoint.y)
            .reduce((a, b) => a! < b! ? a : b) ??
        0;
    avg = widget.flightDataValues
            .map((datapoint) => datapoint.y)
            .reduce((a, b) => a! + b!)! ~/ widget.flightDataValues.length;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SfCartesianChart(
            // Initialize category axis
            primaryXAxis: CategoryAxis(),
            series: <ChartSeries>[
              // Initialize line series
              LineSeries<ChartData, String>(
                  dataSource: widget.flightDataValues,
                  xValueMapper: (ChartData data, _) => data.x,
                  yValueMapper: (ChartData data, _) => data.y)
            ]),
        Text("Peak: $maxValue ${widget.measurementUnit}"),
        Text("Min: $minValue ${widget.measurementUnit}"),
        Text("Avg.: $avg ${widget.measurementUnit}"),
      ],
    );
  }
}

class ChartData {
  ChartData(this.x, this.y);
  final String x;
  final num? y;
}
