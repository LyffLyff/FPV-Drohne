import 'package:drone_2_0/screens/homepage/flight_recording/previous_flight/flight_data_tab.dart';
import 'package:drone_2_0/screens/homepage/flight_recording/previous_flight/general.dart';
import 'package:flutter/material.dart';

class PreviousFlight extends StatefulWidget {
  final Map flightData;

  const PreviousFlight({super.key, required this.flightData});

  @override
  State<PreviousFlight> createState() => _PreviousFlightState();
}

class _PreviousFlightState extends State<PreviousFlight> {
  int _selectedIndex = 0;

  late final List<Widget> _widgetOptions;

  @override
  void initState() {
    super.initState();
    _widgetOptions = <Widget>[
      const GeneralFlightData(
        durationInSeconds: 0,
        timestamp: 0,
      ),
      FlightDataTab(
        chartTitle: '',
        xAxisTitle: '',
        yAxisTitle: '',
        flightDataValues: [ChartData("", 3)],
      ),
      FlightDataTab(
        chartTitle: '',
        xAxisTitle: '',
        yAxisTitle: '',
        flightDataValues: [ChartData("", 2)],
      ),
      FlightDataTab(
        chartTitle: '',
        xAxisTitle: '',
        yAxisTitle: '',
        flightDataValues: [ChartData("", 4)],
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
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'General',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'Velocity',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'Height',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'Temperature',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
