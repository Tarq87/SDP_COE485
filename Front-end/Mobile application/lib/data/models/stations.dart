import 'dart:convert';

class Stations {
  List<String> names;
  List<double> lats;
  List<double> longs;

  Stations({required this.names, required this.lats, required this.longs});

  factory Stations.fromJson(String json) {
    // not decoded
    var namesJSON = jsonDecode(json)['name']; // contains the names list
    var LongsJSON =
        jsonDecode(json)['longitude']; // contains the Longitudes list
    var LatsJSON = jsonDecode(json)['latitude']; // contains the Longitudes list

    // names = tagsJson != null ? List.from(tagsJson) : null;

    return Stations(
      names: List<String>.from(namesJSON),
      longs: List<double>.from(LongsJSON),
      lats: List<double>.from(LatsJSON),
    );
  }
}
