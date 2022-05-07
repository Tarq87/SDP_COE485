import 'package:http/http.dart' as http;

class StationsAPI {
  StationsAPI();
  String cloud = 'https://seniordesignproject.azurewebsites.net';
  String localhost = 'http://localhost:3000';

  Future<String> requestStations() async {
    final response = await http.get(
      // change the url to fit the request path for the backend
      Uri.parse('$cloud/requeststations'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
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
