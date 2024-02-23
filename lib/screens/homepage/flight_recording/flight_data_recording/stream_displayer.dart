import 'package:drone_2_0/extensions/extensions.dart';
import 'package:drone_2_0/widgets/utils/helper_widgets.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'chart_data.dart';

class StreamDisplay extends StatelessWidget {
  final List<ChartData> dataArray;
  final num lastMeasurement;
  final String title;
  final String xAxisName;
  final String yAxisName;
  final String unit;
  final double maxY;
  final double minY;

  const StreamDisplay(
      {super.key,
      required this.title,
      required this.xAxisName,
      required this.yAxisName,
      required this.dataArray,
      required this.lastMeasurement,
      required this.unit,
      required this.maxY,
      required this.minY});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SfCartesianChart(
          // Chart title
          title:
              ChartTitle(text: title, textStyle: context.textTheme.bodyMedium),

          // Style
          enableAxisAnimation: false,
          primaryXAxis: NumericAxis(
            name: xAxisName,
            title: AxisTitle(text: xAxisName),
          ),
          primaryYAxis: NumericAxis(
            minimum: minY,
            maximum: maxY,
            name: yAxisName,
            title: AxisTitle(text: yAxisName),
          ),

          // Data
          series: <CartesianSeries>[
            LineSeries<ChartData, num>(
              dataSource: dataArray,
              xValueMapper: (ChartData time, _) => time.x,
              yValueMapper: (ChartData yValue, _) => yValue.y,
              markerSettings: const MarkerSettings(
                isVisible: false,
              ),
            ),
          ],
        ),
        const VerticalSpace(),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
              color: Colors.grey.shade900,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(16)),
          child: Center(
            child: RichText(
              text: TextSpan(
                style: context.textTheme.headlineLarge,
                children: <TextSpan>[
                  TextSpan(
                      text: dataArray.isNotEmpty
                          ? dataArray[dataArray.length - 1].y.toStringAsFixed(2)
                          : "-"),
                  TextSpan(
                    text: " $unit",
                    style: context.textTheme.headlineMedium,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
