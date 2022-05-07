import 'dart:convert';
import 'package:sdp/data/data_providers/location_api.dart';
import 'package:sdp/data/models/location.dart';

class LocationRepository {
  LocationRepository();
  final LocationAPI api = LocationAPI();

  Future<Location> sendLocationDetail(
      String sender, double latitude, double longitude, double speed) async {
    print('#### From LocationRepository: before requesting #### ');
    String rawLcationResp =
        await api.provideLocation(sender, latitude, longitude, speed);
    print('#### From LocationRepository: After requesting #### ');
    Location location = Location.fromJson(jsonDecode(rawLcationResp));
    return location;
  }
}
