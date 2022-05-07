import 'dart:convert';

import 'package:http/http.dart' as http;

class UpdateTicketsAPI {
  UpdateTicketsAPI();
  String cloud = 'https://seniordesignproject.azurewebsites.net';
  String localhost = 'http://localhost:3000';

  Future<String> requestUpdateTickets(String username) async {
    final response = await http.post(
      // change the url to fit the request path for the backend
      Uri.parse('$cloud/updatetickets'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'user_id': username,
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
