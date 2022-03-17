import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as global;

class MapSample extends StatefulWidget {
  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  // determine location part
  String _latitude = '';
  String _longitude = '';
  String _altitude = '';
  String _speed = '';
  String _address = '';
  String _locationAccuracy = '';
  String _speedAccuracy = '';

  double KFUPMLat = 26.30713914704697;
  double KFUPMLon = 50.14587577811144;

  // should be initialized just in case
  double latitude = 37.42796133580664;
  double longitude = -122.085749655962;
  late double altitude;
  late double speed;
  late double locationAccuracy;
  late double speedAccuracy;

  bool liveFlag = true;

  late CameraPosition _kMyLocation;

  /// Determine the current position of the device.
  ///
  /// When the location services are not enabled or permissions
  /// are denied the `Future` will return an error.
  Future<bool> _getMyLocation() async {
    global.Location location = new global.Location();
    location.enableBackgroundMode(enable: true); // for use in background

    bool _serviceEnabled;
    global.PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        print('Service is Not enabled');
        return false;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == global.PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != global.PermissionStatus.granted) {
        print('Premission is not granted');
        return false;
      }
    }

    try {
      // global is the prefix imported plugin
      global.LocationData currentLocation =
          await global.Location().getLocation();

      latitude =
          currentLocation.latitude!; // for sure the value is not null > need !
      longitude = currentLocation.longitude!;
      speed = currentLocation.speed!;

      _kMyLocation = CameraPosition(
          bearing: 192.8334901395799,
          target: LatLng(latitude, longitude),
          tilt: 59.440717697143555,
          zoom: 19.151926040649414);

      return true;
    } catch (e) {
      print('Error caused by live Listening: $e');
      return false;
    }
  }

  // Google Maps Example
  Completer<GoogleMapController> _controller = Completer();

  static final CameraPosition _kKFUPM = CameraPosition(
    target: LatLng(26.30713914704697, 50.14587577811144),
    zoom: 14.4746,
  );

  static final CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text('Google Maps'),
        actions: [],
      ),
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: _kKFUPM,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToMyLocation,
        label: Text('My location'),
        icon: Icon(Icons.directions),
      ),
    );
  }

  Future<void> _goToMyLocation() async {
    _getMyLocation();
    await Future.delayed(Duration(seconds: 1));
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kMyLocation));
  }
}
