import 'package:http/http.dart' as http;

class BusesAPI {
  BusesAPI();
  String cloud = 'https://seniordesignproject.azurewebsites.net';
  String localhost = 'http://localhost:3000';

  Future<String> requestBuses() async {
    final response = await http.get(
      // change the url to fit the request path for the backend
      Uri.parse('$cloud/requestbuses'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    print('>>>>>>>>> Raw Response from Get method: ${response.body}');

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
