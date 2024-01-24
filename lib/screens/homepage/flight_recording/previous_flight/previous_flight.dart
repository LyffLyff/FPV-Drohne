import 'package:drone_2_0/extensions/extensions.dart';
import 'package:drone_2_0/screens/homepage/flight_recording/previous_flight/flight_data_tab.dart';
import 'package:drone_2_0/screens/homepage/flight_recording/previous_flight/general.dart';
import 'package:flutter/material.dart';

class PreviousFlight extends StatefulWidget {
  final Map flightData;

  const PreviousFlight({
    super.key,
    required this.flightData,
  });

  @override
  State<PreviousFlight> createState() => _PreviousFlightState();
}

class _PreviousFlightState extends State<PreviousFlight> {
  int _selectedIndex = 0;

  late final List<Widget> _widgetOptions;

  List<ChartData> createDatalist(Map<String, dynamic> singleSensorData) {
    // Converting the Map of a single Sensor including timestamps and values to a displayable array of ChartData
    List<ChartData> datalist = [];
    for (int i = 0; i < singleSensorData["timestamps"]!.length; i++) {
      datalist.add(ChartData(
          singleSensorData["timestamps"]![i]!, singleSensorData["values"]?[i]));
    }
    return datalist;
  }

  int getStartTimestamp() {
    // converting milliSeconds since epoch to seconds
    return widget.flightData["startTimestamp"] ~/ 1000;
  }

  int getDurationInSeconds() {
    return (widget.flightData["endTimestamp"] -
            widget.flightData["startTimestamp"]) ~/
        1000;
  }

  @override
  void initState() {
    super.initState();
    _widgetOptions = <Widget>[
      GeneralFlightData(
        durationInSeconds: getDurationInSeconds(),
        timestamp: getStartTimestamp(),
        weatherIcon: widget.flightData["weather"] ?? "wi-day-sunny",
      ),
      FlightDataTab(
        chartTitle: 'Velocity',
        xAxisTitle: 'Timestamps',
        yAxisTitle: 'Velocity',
        flightDataValues: createDatalist(widget.flightData["data"]["velocity"]),
        measurementUnit: 'm/s\u00B2',
      ),
      FlightDataTab(
        chartTitle: '',
        xAxisTitle: '',
        yAxisTitle: '',
        flightDataValues: createDatalist(widget.flightData["data"]["height"]),
        measurementUnit: 'm',
      ),
      FlightDataTab(
        chartTitle: 'Temperature in °C',
        xAxisTitle: '°C',
        yAxisTitle: 'Seconds since Start',
        flightDataValues:
            createDatalist(widget.flightData["data"]["temperature"]),
        measurementUnit: '°C',
      ),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.flightData["title"]),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics),
            label: 'General',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.speed),
            label: 'Velocity',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.show_chart),
            label: 'Height',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.thermostat),
            label: 'Temperature',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
