import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:geocoding/geocoding.dart' as geocoding;
import 'dart:async';
import 'package:location/location.dart';

class BusDriver extends StatefulWidget {
  BusDriver({Key? key}) : super(key: key);

  @override
  State<BusDriver> createState() => _BusDriverState();
}

class _BusDriverState extends State<BusDriver> with TickerProviderStateMixin {
  // ######### streaming part ##########
  String BUSID = '';

  String cloud = 'https://seniordesignproject.azurewebsites.net';
  String localhost = 'http://localhost:3000';

  late IO.Socket socket;

  @override
  void initState() {
    socket = IO.io(
        '$cloud',
        IO.OptionBuilder()
            .setTransports(['websocket']) // for Flutter or Dart VM
            .disableAutoConnect() // disable auto-connection
            //.setExtraHeaders({'foo': 'bar'}) // optional
            .build());
    socket.connect();
    setUpSocketListener();
    super.initState();
  }

  // ##########  getting Live Location part ###########
  String _latitude = '';
  String _longitude = '';
  String _altitude = '';
  String _speed = '';
  String _address = '';
  String _locationAccuracy = '';
  String _speedAccuracy = '';

  // should be initialized just in case
  late double latitude;
  late double longitude;
  late double altitude;
  late double speed;
  late double locationAccuracy;
  late double speedAccuracy;

  StreamSubscription<LocationData>? locationSubscription;

  bool waitOnce =
      false; // to start socket emiting after some time to accurately locate
  bool triggerWaitingOnce = true;

  /// Determine the current position of the device.
  ///
  /// When the location services are not enabled or permissions
  /// are denied the `Future` will return an error.
  Future<void> _determineLiveLocation() async {
    Location location = new Location();
    location.enableBackgroundMode(enable: true); // for use in background

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        print('Service is Not enabled');
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        print('Premission is not granted');
      }
    }

    locationSubscription =
        location.onLocationChanged.listen((LocationData currentLocation) async {
      if (currentLocation.latitude != null) {
        latitude = currentLocation
            .latitude!; // for sure the value is not null > need !
      }

      if (currentLocation.longitude != null) {
        longitude = currentLocation.longitude!;
      }

      if (currentLocation.altitude != null) {
        altitude = currentLocation.altitude!;
      }

      if (currentLocation.speed != null) {
        speed = currentLocation.speed!;
      }

      if (currentLocation.accuracy != null) {
        locationAccuracy = currentLocation.accuracy!;
      }

      if (currentLocation.accuracy != null) {
        speedAccuracy = currentLocation.speedAccuracy!;
      }
      try {
        List pm = await geocoding.placemarkFromCoordinates(latitude, longitude);
        if (mounted) {
          setState(() {
            _latitude = latitude.toString();
            _longitude = longitude.toString();
            _altitude = altitude.toString();
            _speed = speed.toString();
            _address = pm[0].toString();
            _locationAccuracy = locationAccuracy.toString();
            _speedAccuracy = speedAccuracy.toString();
          });
          // to wait for one time only
          if (triggerWaitingOnce) {
            triggerWaitingOnce = false;
            triggerWaiting();
            // will continue execution because there is no await
          }
          if (waitOnce) {
            sendLocation(); // sending location for every location change through socket io
          }
        }
      } catch (e) {
        print(
            '##########\n#########\n########Place From Coordinate functions error: $e\n##########\n#########\n########');
      }
    });
  }

  Future<void> triggerWaiting() async {
    int w = 5;
    print(
        ' >>>>>>>>>  Waiting for $w Seconds before sending location through socket io');
    await Future.delayed(
        Duration(seconds: w)); // wait to obtain more accurate location
    waitOnce = true;
  }

  cancelSubscription() {
    locationSubscription?.cancel;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bus Driver'),
        actions: <Widget>[],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Text(
              'Your last known location is:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Text(
              '\n***Latitude***',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            Text(
              ' $_latitude',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
            ),
            const Text(
              '\n***Longitude***',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            Text(
              '$_longitude',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
            ),
            const Text(
              '\n***Altitude***',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            Text(
              '$_altitude',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
            ),
            const Text(
              '\n***Speed***',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            Text(
              '$_speed',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
            ),
            const Text(
              '\n***Location accuracy in meters***',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            Text(
              '$_locationAccuracy',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
            ),
            const Text(
              '\n***Speed accuracy***',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            Text(
              '$_speedAccuracy',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
            ),
            const Text(
              '\n***Address***',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            Text(
              '$_address',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              height: 150,
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.only(bottom: 5),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 3,
                    offset: Offset(5, 5),
                    color: Color.fromARGB(204, 63, 102, 185).withOpacity(0.1),
                  ),
                  BoxShadow(
                    blurRadius: 3,
                    offset: Offset(-5, -5),
                    color: Color.fromARGB(204, 63, 102, 185).withOpacity(0.1),
                  ),
                ],
              ),
              child: Column(
                children: [
                  TextButton.icon(
                    onPressed: () {
                      _showMyDialog(context);
                    },
                    icon: Icon(Icons.input_outlined),
                    label: const Text(
                      'Enter Bus ID First',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () {
                      locationSubscription?.pause();
                      locationSubscription?.cancel;
                      locationSubscription = null;
                      socket.close();
                      waitOnce =
                          false; // reset flags to control socket emiting for more accurate location
                      triggerWaitingOnce = true;
                      print('>>>>> Bus location streaming cancelled');
                      _showSnackBar(
                          context, 'Bus location streaming cancelled');
                    },
                    icon: Icon(Icons.cancel),
                    label: const Text(
                      'Cancel bus location Streaming ',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  Text('Current Bus: $BUSID'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool isNumericUsing_tryParse(String? string) {
    // Null or empty string is not a number
    if (string == null || string.isEmpty) {
      return false;
    }

    // Try to parse input string to number.
    // Both integer and double work.
    // Use int.tryParse if you want to check integer only.
    // Use double.tryParse if you want to check double only.
    final number = num.tryParse(string);

    if (number == null) {
      return false;
    }

    return true;
  }

  Future<void> _showMyDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext c) {
        // be careful to change c to context
        return AlertDialog(
          title: const Text('Enter the bus ID'),
          content: SingleChildScrollView(
            child: TextFormField(
              decoration: InputDecoration(
                icon: Icon(Icons.bus_alert),
                hintText: 'Bus ID (i.e. Format xxxx)',
              ),
              validator: (value) => (isNumericUsing_tryParse(value))
                  ? null
                  : 'Only Numbers (i.e. xxxx)',
              onChanged: (value) {
                BUSID = value;
              },
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () async {
                Navigator.of(context).pop();
                locationSubscription?.cancel;
                _determineLiveLocation();
              },
            ),
          ],
        );
      },
    );
  }

  void sendLocation() {
    var locationJson = {
      "bus_id": BUSID,
      "location": {
        "type": "Point",
        "coordinates": [longitude, latitude],
      },
    };

    print(
        '########## Before Sending through socket From Bus driver screen ############\n bus_id: $BUSID, latitude: $latitude, longitude: $longitude');
    socket.emit(
      'bus-connection',
      locationJson,
    );
    socket.onConnectError((data) {
      print(' ********** >>>>>>>>>>>>> Connection Error: $data');
    });
    socket.on('connect', (_) => print('connect: ${socket.id}'));
  }

  void setUpSocketListener() {
    // for reciving live buses location later on
    socket.on('location-receive', (data) {
      print(
          ' ########### Bus driver socket io ###########\n From server: $data');
    });
    socket.on('location-error', (data) {
      print(
          ' ########### Bus driver socket io ###########\n From server: $data');
    });
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
