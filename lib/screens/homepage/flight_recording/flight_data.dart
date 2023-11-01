class FlightData {
  List<double> heightData = [];
  List<double> velocityData = [];
  List<double> temperatureData = [];
  List<int> timestampData =
      []; // a list with the timestamps for each "datapoint"

  void addDatapoint() {
    
  }

  Map<String, dynamic> toMap() {
    return {
      "heightData": heightData,
      "velocityData": velocityData,
      "temperatureData": temperatureData,
      "timestampData": timestampData,
    };
  }

  void uploadData() {
    
  }
}
