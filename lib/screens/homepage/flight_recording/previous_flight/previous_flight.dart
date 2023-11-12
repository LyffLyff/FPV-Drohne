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

  List<ChartData> createDatalist(Map data, String dataKey) {
    // converting the map of the data to a list consisting of ChartData types
    List originalData = data[dataKey];
    List<ChartData> datalist = [];
    for (int i = 0; i < originalData.length; i++) {
      datalist.add(ChartData(i.toString(), originalData[i]));
    }
    return datalist;
  }

  int getStartTimestamp() {
    // converting milliSeconds since epoch to seconds
    return widget.flightData["startTimestamp"] ~/ 1000;
  }

  int getDurationInSeconds() {
    return (widget.flightData["endTimestamp"] - widget.flightData["startTimestamp"]) ~/ 1000;
  }

  @override
  void initState() {
    super.initState();
    _widgetOptions = <Widget>[
      GeneralFlightData(
        durationInSeconds: getDurationInSeconds(),
        timestamp: getStartTimestamp(),
      ),
      FlightDataTab(
        chartTitle: 'Velocity',
        xAxisTitle: 'Timestamps',
        yAxisTitle: 'Velocity',
        flightDataValues: createDatalist(widget.flightData, "velocityData"),
      ),
      FlightDataTab(
        chartTitle: '',
        xAxisTitle: '',
        yAxisTitle: '',
        flightDataValues: createDatalist(widget.flightData, "heightData"),
      ),
      FlightDataTab(
        chartTitle: '',
        xAxisTitle: '',
        yAxisTitle: '',
        flightDataValues: createDatalist(widget.flightData, "temperatureData"),
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
        title: const Text('12/23/23'),
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
        selectedItemColor: context.primaryColor,
        unselectedItemColor: context.disabledColor,
        onTap: _onItemTapped,
      ),
    );
  }
}
