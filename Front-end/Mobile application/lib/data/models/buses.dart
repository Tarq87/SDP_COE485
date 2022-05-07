import 'dart:convert';

class Buses {
  List<String> buses_id;
  List<double> lats;
  List<double> longs;

  Buses({required this.buses_id, required this.lats, required this.longs});

  factory Buses.fromJson(String json) {
    // not decoded
    var buses_idJSON = jsonDecode(json)['bus_id']; // contains the buses id list
    var LongsJSON =
        jsonDecode(json)['longitude']; // contains the Longitudes list
    var LatsJSON = jsonDecode(json)['latitude']; // contains the Longitudes list

    return Buses(
      buses_id: List<String>.from(buses_idJSON),
      longs: List<double>.from(LongsJSON),
      lats: List<double>.from(LatsJSON),
    );
  }
}
