import 'package:drone_2_0/service/local_storage_service.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class DataCache with ChangeNotifier {
  List _previousFlights = [];
  Map _dataAges = {
    "previousFlights": -1,
  };

  List get previousFlights => _previousFlights;
  Map get dataAges => _dataAges;

  Future<void> initData() async {
    final LocalStorageService localStorage = LocalStorageService();

    // reading local data
    final data = await localStorage.readFile("flight_records.dat") ?? [];
    _previousFlights = data;

    // reading age of data
    Map? dataAges = await localStorage.readFile("data_ages.dat");

    if (dataAges != null) {
      _dataAges = dataAges;
    }
  }

  void setPreviousFlights(List data) {
    _previousFlights = data;

    // update last set date
    _dataAges["previousFlights"] = DateTime.now().millisecondsSinceEpoch;

    // save data to file
    writeFlightRecords(data);
  }

  void addSingleFlight(Map<String, dynamic> newFlight, int timestamp) {
    _previousFlights.add(newFlight);
    _dataAges["previousFlights"] = timestamp;
  }

  void writeFlightRecords(List data) {
    LocalStorageService().writeFile(data, "flight_records.dat");
    LocalStorageService().writeFile(_dataAges, "data_ages.dat");
  }

  void updateFlightProperty(int timestamp, String propertyKey, dynamic value) {
    for (int i = _previousFlights.length - 1; i >= 0; i--) {
      Logger().i(_previousFlights[i]["endTimestamp"] == timestamp);
      if (_previousFlights[i]["endTimestamp"] == timestamp) {
        _previousFlights[i][propertyKey] = value;
        writeFlightRecords(_previousFlights);
        return;
      }
    }
    Logger().e("Could not find corresponding Flight to update property");
  }
}
