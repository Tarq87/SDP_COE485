import 'package:sdp/data/data_providers/stations_api.dart';
import 'package:sdp/data/models/stations.dart';

class StationsRepository {
  StationsRepository();
  final StationsAPI api = StationsAPI();

  Future<Stations> sendStationsRequest() async {
    String rawStationsResponse = await api.requestStations();
    Stations stations = Stations.fromJson(rawStationsResponse);
    return stations;
  }
}
