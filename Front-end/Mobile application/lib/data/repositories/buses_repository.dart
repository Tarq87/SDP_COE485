import 'package:sdp/data/data_providers/buses_api.dart';
import 'package:sdp/data/models/buses.dart';

class BusesRepository {
  BusesRepository();
  final BusesAPI api = BusesAPI();

  Future<Buses> sendBusesRequest() async {
    print('>>>>>>>>>> inside the Buses repository');
    String rawBusesResponse = await api.requestBuses();
    Buses buses = Buses.fromJson(rawBusesResponse);
    return buses;
  }
}
