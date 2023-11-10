import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class FlightDataTab extends StatelessWidget {
  final String chartTitle;
  final String xAxisTitle;
  final String yAxisTitle;

  final List<ChartData> flightDataValues;

  const FlightDataTab(
      {super.key,
      required this.chartTitle,
      required this.xAxisTitle,
      required this.yAxisTitle,
      required this.flightDataValues});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SfCartesianChart(
            // Initialize category axis
            primaryXAxis: CategoryAxis(),
            series: <ChartSeries>[
              // Initialize line series
              LineSeries<ChartData, String>(
                  dataSource: flightDataValues,
                  xValueMapper: (ChartData data, _) => data.x,
                  yValueMapper: (ChartData data, _) => data.y)
            ]),
        const Text("Peak: "),
        const Text("Min: "),
        const Text("Avg.: "),
      ],
    );
  }
}


class ChartData {
        ChartData(this.x, this.y);
        final String x;
        final num? y;
    }