import 'package:drone_2_0/service/local_storage_service.dart';
import 'package:flutter/material.dart';

class DataCache with ChangeNotifier {
  List _previousFlights = [];
  int _previousFlightsAge =
      -1; // timestamp telling when the previous flights were last updated

  List get previousFlights => _previousFlights;
  int get previousFlightsAge => _previousFlightsAge;

  Future<void> initData() async {
    final LocalStorageService localStorage = LocalStorageService();

    // reading local data
    final data = await localStorage.readFile("flight_records.dat");
    _previousFlights = data;

    // reading age of data
    Map? dataAges = await localStorage.readFile("data_ages.dat");

    _previousFlightsAge = dataAges?["previousFlights"] ?? -1;
  }

  void setPreviousFlights(List data) {
    _previousFlights = data;

    // update last set date
    _previousFlightsAge = DateTime.now().millisecondsSinceEpoch;

    // save data to file
    LocalStorageService().writeFile(data, "flight_records.dat");
  }

  void addSingleFlight(Map<String, dynamic> newFlight, int timestamp) {
    _previousFlights.add(newFlight);
    _previousFlightsAge = timestamp;
  }
}
