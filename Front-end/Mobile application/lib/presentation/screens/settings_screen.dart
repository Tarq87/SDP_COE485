import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:location/location.dart';
import 'package:sdp/bussiness_logic/blocs/login_bloc/login2_bloc.dart';
import 'package:sdp/bussiness_logic/blocs/settings_bloc/settings_bloc.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SettingsFourPage extends StatefulWidget {
  @override
  _SettingsFourPageState createState() => _SettingsFourPageState();
}

class _SettingsFourPageState extends State<SettingsFourPage> {
  bool value = false;

  // ######### streaming part ##########
  String username = '';

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
            .setExtraHeaders({'foo': 'bar'}) // optional
            .build());
    socket.connect();
    setUpSocketListener();
    super.initState();
  }

  // ##########  getting Live Location part ###########
  // shall be used for printing if needed

  /*
  String _latitude = '';
  String _longitude = '';
  String _altitude = '';
  String _speed = '';
  String _address = '';
  String _locationAccuracy = '';
  String _speedAccuracy = '';

  */

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

  bool streamOnce = true;
  bool cancelOnce = true;

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
        // List pm = await geocoding.placemarkFromCoordinates(latitude, longitude);
        if (mounted) {
/*          
          setState(() {
            _latitude = latitude.toString();
            _longitude = longitude.toString();
            _altitude = altitude.toString();
            _speed = speed.toString();
            _address = pm[0].toString();
            _locationAccuracy = locationAccuracy.toString();
            _speedAccuracy = speedAccuracy.toString();
          });
  */
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

  void sendLocation() {
    var locationJson = {
      "user_id": username,
      "longitude": longitude,
      "latitude": latitude,
    };
    print(
        '########## Before Sending through socket ############\n user_id: $username, latitude: $latitude, longitude: $longitude');
    socket.emit(
      'user-connection',
      locationJson,
    );
    socket.onConnectError((data) {
      print('Connection Error: $data');
    });
  }

  void setUpSocketListener() {
    // for reciving live buses location later on
    socket.on('location-receive', (data) {
      print(data);
    });
    socket.on('location-error', (data) {
      print(
          ' ########### Bus driver socket io ###########\n From server: $data');
    });
  }

  Future<void> resetSocketFlags() async {
    await Future.delayed(Duration(seconds: 3));
    streamOnce = true;
    cancelOnce = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        actions: <Widget>[],
        backgroundColor: Color.fromARGB(204, 63, 102, 185).withOpacity(0.9),
      ),
      body: BlocListener<SettingsBloc, SettingsState>(
        listener: (context, state) async {
          if (streamOnce && state.shareLocation) {
            streamOnce = false;
            username = context.read<Login2Bloc>().state.username;
            _determineLiveLocation();
            await Future.delayed(Duration(seconds: 1));
            _showSnackBar(context, 'Sharing location enabled');
          } else if (cancelOnce && !state.shareLocation) {
            cancelOnce = false;
            locationSubscription?.pause();
            locationSubscription?.cancel;
            locationSubscription = null;
            socket.close();
            waitOnce =
                false; // reset flags to control socket emiting for more accurate location
            triggerWaitingOnce = true;
            print('>>>>> Bus location streaming cancelled');
            await Future.delayed(Duration(seconds: 1));
            resetSocketFlags(); // reseting flags(streamOnce and cancelOnce) after 5 seconds for re sending location
            _showSnackBar(context, 'Location streaming cancelled');
          }
        },
        child: Container(
          padding: EdgeInsets.only(left: 16, top: 25, right: 16),
          child: ListView(
            children: [
              /*
                  SizedBox(
                    height: 40,
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.person,
                        color: Colors.green,
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                        "Account",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Divider(
                    height: 15,
                    thickness: 2,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ChangePassword(context, "Change password"),
                  ChangePassword(context, "Content settings"),
                  ChangePassword(context, "Social Media"),
                  ChangePassword(context, "Language"),
                  ChangePassword(context, "Privacy and Policy"),
                  SizedBox(
                    height: 40,
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.privacy_tip,
                        color: Colors.green,
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                        "Privacy",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Divider(
                    height: 15,
                    thickness: 2,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  */
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Share Location',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[600]),
                  ),
                  BlocBuilder<SettingsBloc, SettingsState>(
                    builder: (context, state) {
                      return Transform.scale(
                          scale: 0.7,
                          child: CupertinoSwitch(
                              activeColor: Colors.blue,
                              value: state.shareLocation,
                              onChanged: (bool newValue) {
                                context.read<SettingsBloc>().add(
                                    AdjustSettings(shareLocation: newValue));
                              }));
                    },
                  )
                ],
              ),
              SizedBox(
                height: 50,
              ),
            ],
          ),
        ),
      ),
    );
  }

  GestureDetector ChangePassword(BuildContext context, String title) {
    return GestureDetector(
      onTap: () {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(title),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Enter Your New Password"),
                    TextFormField(
                      decoration: InputDecoration(
                        icon: Icon(Icons.security),
                        hintText: 'Password',
                      ),
                    )
                  ],
                ),
                actions: [
                  ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text("Close")),
                ],
              );
            });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
