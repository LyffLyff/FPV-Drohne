import 'package:drone_2_0/data/providers/data_cache.dart';
import 'package:drone_2_0/service/realtime_db_service.dart';
import 'package:drone_2_0/service/user_profile_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum FlightRecordingFinishType {
  manual, // pressed on "finish"-Button during recording
  drone, // drone stopped flying -> automatically stops recording
  error, // some kind of error occured
}

class FlightData {
  // General
  String title = "";
  String weather = "wi-cloud";
  int startTimestamp = 0;
  int endTimestamp = -1;
  String userId = "";
  FlightRecordingFinishType finishType = FlightRecordingFinishType.manual;
  bool flightStarted = false;

  // Data
  List<int> heightData = [];
  List<int> velocityData = [];
  List<double> temperatureData = [];
  List<int> timestampData =
      []; // a list with the timestamps for each "datapoint"

  void addDatapoint(int timestamp, int velocityReading,
      double temperatureReading, int heightReading) {
    timestampData.add(timestamp);
    velocityData.add(velocityReading);
    temperatureData.add(temperatureReading);
    heightData.add(heightReading);
  }

  void startFlight(String userId, int timestamp) {
    this.userId = userId;
    startTimestamp = timestamp;
    flightStarted = true;
  }

  bool finishFlight(int timestamp, FlightRecordingFinishType finishedManually,
      BuildContext context) {
    if (!flightStarted) {
      return false;
    }
    endTimestamp = timestamp;
    _uploadData(context);
    flightStarted = false;
    RealtimeDatabaseService().updateData("", {"is_connected": false});
    return true;
  }

  void _uploadData(BuildContext context) async {
    Map<String, dynamic> newFlightData = toMap();

    // add data to local cache + updating timestamps
    Provider.of<DataCache>(context, listen: false)
        .addSingleFlight(newFlightData, endTimestamp);

    // upload to db
    UserProfileService service = UserProfileService();
    await service.addFlightData("users", userId, endTimestamp, newFlightData);
  }

  Map<String, dynamic> toMap() {
    return {
      "weather": weather,
      "title": title,
      "startTimestamp": startTimestamp,
      "endTimestamp": endTimestamp,
      "heightData": heightData,
      "velocityData": velocityData,
      "temperatureData": temperatureData,
      "timestampData": timestampData,
    };
  }
}
