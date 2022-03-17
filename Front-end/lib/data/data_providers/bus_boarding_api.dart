import 'dart:convert';
import 'package:http/http.dart' as http;

class BusBoardingAPI {
  BusBoardingAPI();
  Future<String> requestBoarding(
      String busID, String ticketID, double latitude, double longitude) async {
    final response = await http.post(
      // change the url to fit the request path for the backend
      Uri.parse('http://localhost:3000/checkticket'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'ticket_id': ticketID,
        'Bus_id': busID,
        'longitude': longitude,
        'latitude': latitude,
      }),
    );

    if (response.statusCode == 200) {
      // If the server did return a 200 CREATED response,
      // then parse the JSON.
      return response.body;
    } else {
      // If the server did not return a 200 CREATED response,
      // then throw an exception.
      return "";
    }
  }
}
