import 'dart:convert';
import 'package:http/http.dart' as http;

class SignupAPI {
  SignupAPI();
  String cloud = 'https://seniordesignproject.azurewebsites.net';
  String localhost = 'http://localhost:3000';

  Future<String> requestLogin(
      String username, String email, String password) async {
    final response = await http.post(
      // change the url to fit the request path for the backend
      Uri.parse('$cloud/signup'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'name': username,
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      return response.body;
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      return '';
    }
  }
}
