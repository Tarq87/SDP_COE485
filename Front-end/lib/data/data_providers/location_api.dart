import 'dart:convert';
import 'package:http/http.dart' as http;

class LocationAPI {
  LocationAPI();
  Future<String> provideLocation(
      String sender, double latitude, double longitude, double speed) async {
    print("### ###  from location API before post ");

    final response = await http.post(
      // change the url to fit the request path for the backend
      Uri.parse(
          'https://f7ad29d2-4b8a-499e-823c-f5c0f681b012.mock.pstmn.io/users'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'sender': sender, // bus or passenger
        'latitude': latitude,
        'longitude': longitude,
        'speed': speed,
      }),
    );

    print(" From Location API: after post response body =  ${response.body}");

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
