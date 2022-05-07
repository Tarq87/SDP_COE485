/*
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:location/location.dart';
import 'package:sdp/bussiness_logic/blocs/location_bloc/location_bloc.dart';
import 'package:sdp/data/repositories/location_repository.dart';

class CheckLiveLocation extends StatefulWidget {
  CheckLiveLocation({Key? key}) : super(key: key);

  @override
  State<CheckLiveLocation> createState() => _CheckLiveLocationState();
}

class _CheckLiveLocationState extends State<CheckLiveLocation> {
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

  bool liveFlag = true;

  StreamSubscription<LocationData>? locationSubscription;

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
        }
      } catch (e) {
        print(
            '##########\n#########\n########Place From Coordinate functions error: $e\n##########\n#########\n########');
      }
    });
  }

  cancelSubscription() {
    locationSubscription?.cancel;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocProvider(
        create: (context) =>
            LocationBloc(locationRepos: context.read<LocationRepository>()),
        child: Scaffold(
          appBar: AppBar(
            title: Text('Location'),
            actions: cancelSubscription(),
          ),
          backgroundColor: Color(0xfffdfdfdf),
          body: BlocListener<LocationBloc, LocationState>(
            listener: (context, state) {
              print(
                  '###### From location_screen widget: A Location state Has been changed ######');
              // if finish loading location and the locatinSent is true
              // display location sent otherwise the the location not loaded
              // or not sent
              if (state.locationLoaded && state.locationSent) {
                locationSubscription?.resume();
                _showSnackBar(context, 'Location has been sent');
              }
            },
            child: SingleChildScrollView(
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
                    style:
                        TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
                  ),
                  const Text(
                    '\n***Longitude***',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '$_longitude',
                    style:
                        TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
                  ),
                  const Text(
                    '\n***Altitude***',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '$_altitude',
                    style:
                        TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
                  ),
                  const Text(
                    '\n***Speed***',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '$_speed',
                    style:
                        TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
                  ),
                  const Text(
                    '\n***Location accuracy in meters***',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '$_locationAccuracy',
                    style:
                        TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
                  ),
                  const Text(
                    '\n***Speed accuracy***',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '$_speedAccuracy',
                    style:
                        TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
                  ),
                  const Text(
                    '\n***Address***',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '$_address',
                    style:
                        TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      BlocBuilder<LocationBloc, LocationState>(
                        builder: (context, state) {
                          return Container(
                            alignment: Alignment.center,
                            child: FloatingActionButton(
                              tooltip: 'Get GPS Position',
                              onPressed: () {
                                locationSubscription?.cancel;
                                _determineLiveLocation();
                              },
                              child: Icon(Icons.change_circle_outlined),
                            ),
                          );
                        },
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      BlocBuilder<LocationBloc, LocationState>(
                        builder: (context, state) {
                          return Container(
                            alignment: Alignment.center,
                            child: FloatingActionButton(
                              tooltip: 'Share Location',
                              onPressed: () {
                                context
                                    .read<LocationBloc>()
                                    .add(ShareLocation());
                              },
                              child: Icon(Icons.share_location_outlined),
                            ),
                          );
                        },
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      BlocBuilder<LocationBloc, LocationState>(
                        builder: (context, state) {
                          return Container(
                            alignment: Alignment.center,
                            child: FloatingActionButton(
                              tooltip: 'Check status',
                              onPressed: () {
                                print(
                                    ' #### Entering BlocBuidler in location Screen. Location state.locationSent = ${state.locationSent}');

                                _showSnackBar(context,
                                    'locationSent status = ${state.locationSent}');
                              },
                              child: Icon(Icons.question_answer_outlined),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}


*/