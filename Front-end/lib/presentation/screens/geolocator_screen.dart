import 'dart:async';
import 'package:geocoding/geocoding.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class CheckLocation extends StatefulWidget {
  CheckLocation({Key? key}) : super(key: key);

  @override
  State<CheckLocation> createState() => _CheckLocationScreen();
}

class _CheckLocationScreen extends State<CheckLocation> {
  String _latitude = '';
  String _longitude = '';
  String _altitude = '';
  String _speed = '';
  String _address = '';
  String _accuracy = '';

  Future<void> _updatePosition() async {
    Position pos = await _determinePosition();
    List pm = await placemarkFromCoordinates(pos.latitude, pos.longitude);
    LocationAccuracyStatus accuracy = await Geolocator.getLocationAccuracy();
    setState(() {
      _latitude = pos.latitude.toString();
      _longitude = pos.longitude.toString();
      _altitude = pos.altitude.toString();
      _speed = pos.speed.toString();
      _address = pm[0].toString();
      _accuracy = accuracy.toString();
    });
  }

  /// Determine the current position of the device.
  ///
  /// When the location services are not enabled or permissions
  /// are denied the `Future` will return an error.
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xfffdfdfdf),
        appBar: AppBar(
          title: Text('Location Details'),
          actions: <Widget>[],
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
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
                '\n***Location accuracy***',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              Text(
                '$_accuracy',
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
              Container(
                alignment: Alignment.center,
                child: FloatingActionButton(
                  tooltip: 'Get GPS Position',
                  onPressed: () {
                    _updatePosition();
                  },
                  child: Icon(Icons.change_circle_outlined),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
