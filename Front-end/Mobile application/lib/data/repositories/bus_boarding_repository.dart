import 'dart:convert';
import 'package:sdp/data/data_providers/bus_boarding_api.dart';
import 'package:sdp/data/models/bus_boarding.dart';

class BusBoardingRepository {
  BusBoardingRepository();
  final BusBoardingAPI api = BusBoardingAPI();

  Future<BusBoarding> sendBoardingRequest(
      String busID, String ticketID, double latitude, double longitude) async {
    String rawBoardingResponse =
        await api.requestBoarding(busID, ticketID, latitude, longitude);
    BusBoarding busBoarding =
        BusBoarding.fromJson(jsonDecode(rawBoardingResponse));
    return busBoarding;
  }
}
