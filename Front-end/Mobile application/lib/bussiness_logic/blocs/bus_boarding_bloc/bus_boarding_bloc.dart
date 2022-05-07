//imports
import 'dart:async';
// import 'dart:html';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:location/location.dart';
import 'package:sdp/data/models/bus_boarding.dart';
import 'package:sdp/data/repositories/bus_boarding_repository.dart';
import 'package:location/location.dart' as global;
import 'package:socket_io_client/socket_io_client.dart' as IO;
// import 'package:geocoding/geocoding.dart' as geocoding;

// be carefull with part
part 'bus_boarding_event.dart';
part 'bus_boarding_state.dart';

class BusBoardingBloc extends Bloc<BusBoardingEvent, BusBoardingState> {
  final BusBoardingRepository? busBoardingRepos;
  BusBoarding? boardingResponse;

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
/*
  late double altitude;
  late double speed;
  late double locationAccuracy;
  late double speedAccuracy;
  */

  // ######### streaming part ##########
  String username = '';

  String cloud = 'https://seniordesignproject.azurewebsites.net';
  String localhost = 'http://localhost:3000';

  late IO.Socket socket;

  StreamSubscription<global.LocationData>? locationSubscription;

  bool waitOnce =
      false; // to start socket emiting after some time to accurately locate
  bool triggerWaitingOnce = true;

  bool streamOnce = true;
  bool cancelOnce = true;

  String ticket_id = '';
  String bus_id = '';

  BusBoardingBloc({
    this.busBoardingRepos,
  }) : super(BusBoardingState(
          busID: '',
          ticketID: '',
          latitude: 0.0,
          longitude: 0.0,
          requesting: false,
          boardingStatus: false,
          locationObtained: false,
          boardingInitialized: false,
          socketOpened: false,
        )) {
    //2
    on<RequestBoarding>(((event, emit) async {
      // then chane state accordingly
      resetSocketFlags();

      if (event.ticketid != null) {
        ticket_id = event.ticketid!;
      }
      if (event.busid != null) {
        bus_id = event.busid!;
      }

      username = event.username!;

      emit(state.copyWith(
        boardingInitialized: true,
        requesting: true,
        boardingStatus: false,
        locationObtained: false,
      ));

      bool getLocation = await _determineCurrentLocation(); // 3

      if (getLocation) {
        latitude = state.latitude;
        longitude = state.longitude;
        emit(state.copyWith(
          ticketID: event.ticketid,
          busID: event.busid,
          latitude: state.latitude,
          longitude: state.longitude,
          locationObtained: true,
        ));
        // continue sending
        validateTicket(); // 4
        await setUpResponseListener(); // 5
      } else {
        emit(state.copyWith(
          locationObtained: false,
        ));
      }
    }));
    // 6
    on<boardingResponseReceived>(((event, emit) {
      if (event.status) {
        emit(state.copyWith(
          requesting: false,
          boardingStatus: boardingResponse!.validity,
        ));
      } else {
        emit(state.copyWith(
          requesting: false,
          boardingStatus: false,
        ));
      }
      emit(state.copyWith(
        boardingInitialized: false,
      ));
    }));

    // if the ticket is valid then this event should be fired
    // 7
    on<StartLocationStreaming>(((event, emit) async {
      _streamLiveLocation(); // this function starts listening to real time location and stream it after 5 seconds
      await socketDisconnectListener();
      // 8
    }));

    on<BoardingDone>(((event, emit) {
      print('######### Entering Boarding Done');
      emit(state.copyWith(
        locationObtained: true,
      ));
    }));
/*
    on<GetLocationBus>(((event, emit) async {
      bool flag = await _determineLiveLocation();
      if (flag) {
        emit(state.copyWith(
          locationObtained: true,
        ));
      } else {
        emit(state.copyWith(
          locationObtained: false,
        ));
      }
    }));
*/
    on<InitializeBoarding>(((event, emit) {
      emit(state.copyWith(
        boardingInitialized: true,
        boardingStatus: false,
      ));
    }));
    // 1
    on<OpenSocket>(((event, emit) {
      establishSocketConnection();
      emit(state.copyWith(socketOpened: true));
    }));
    on<CloseSocket>(((event, emit) {
      locationSubscription?.pause();
      locationSubscription?.cancel();
      locationSubscription = null;
      socket.disconnect();
      socket.close();
    }));
  }

  Future<bool> _determineCurrentLocation() async {
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

      state.latitude =
          currentLocation.latitude!; // for sure the value is not null > need !
      state.longitude = currentLocation.longitude!;

      return true;
    } catch (e) {
      print('Error caused by live Listening: $e');
      return false;
    }
  }

// old bus boarding live location before socket io
/*
  Future<bool> _triggerRequest() async {
    try {
      boardingResponse = await busBoardingRepos?.sendBoardingRequest(
        state.busID,
        state.ticketID,
        state.latitude,
        state.longitude,
      );
      print(
          '###### Bus Boarding response ######\n status:${boardingResponse?.validity}, message: ${boardingResponse?.msg} \n #########################');

      if (boardingResponse != null) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(' Nooo an Error: $e');
      return false;
    }
  }

  Future<bool> _determineLiveLocation() async {
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

      state.latitude =
          currentLocation.latitude!; // for sure the value is not null > need !
      state.longitude = currentLocation.longitude!;

      return true;
    } catch (e) {
      print('Error caused by live Listening: $e');
      return false;
    }
  }
*/
  void establishSocketConnection() {
    socket = IO.io(
        '$cloud',
        IO.OptionBuilder()
            .setTransports(['websocket']) // for Flutter or Dart VM
            .disableAutoConnect() // disable auto-connection
            .setExtraHeaders({'foo': 'bar'}) // optional
            .build());
    socket.connect();
  }

  /// Determine the current position of the device.
  ///
  /// When the location services are not enabled or permissions
  /// are denied the `Future` will return an error.
  Future<bool> _streamLiveLocation() async {
    Location location = new Location();
    location.enableBackgroundMode(enable: true); // for use in background

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        print('Service is Not enabled');
        return false;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        print('Premission is not granted');
        return false;
      }
    }

    locationSubscription = location.onLocationChanged.listen(
      (LocationData currentLocation) async {
        if (currentLocation.latitude != null) {
          latitude = currentLocation
              .latitude!; // for sure the value is not null > need !
        }

        if (currentLocation.longitude != null) {
          longitude = currentLocation.longitude!;
        }
/*
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
  */
        try {
/*
          List pm =
              await geocoding.placemarkFromCoordinates(latitude, longitude);

          _latitude = latitude.toString();
          _longitude = longitude.toString();
          _altitude = altitude.toString();
          _speed = speed.toString();
          _address = pm[0].toString();
          _locationAccuracy = locationAccuracy.toString();
          _speedAccuracy = speedAccuracy.toString();

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
        } catch (e) {
          print(
              '##########\n#########\n########Place From Coordinate functions error: $e\n##########\n#########\n########');
        }
      },
    );
    return true;
  }

  Future<void> triggerWaiting() async {
    int w = 5;
    print(
        ' >>>>>>>>>  Waiting for $w Seconds before sending location through socket io');
    await Future.delayed(
        Duration(seconds: w)); // wait to obtain more accurate location
    waitOnce = true;
  }

  void validateTicket() {
    // at this point ticket_id and Bus_id are should not be  empty
    var locationJson = {
      'ticket_id': ticket_id,
      'bus_id': bus_id,
      'longitude': longitude,
      'latitude': latitude,
    };
    print(
        '########## Before validating ticket through socket ############\n ticket id: $ticket_id, bus id: $bus_id, latitude: $latitude, longitude: $longitude');
    socket.emit(
      'user-stream-validate',
      locationJson,
    );
    socket.onConnectError((data) {
      print('Connection Error: $data');
    });
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
      'user-stream-location',
      locationJson,
    );

    socket.onConnectError((data) {
      print('Connection Error: $data');
    });
  }

  Future<void> setUpResponseListener() async {
    // for reciving live buses location later on
    socket.on('user-stream-feedback', (data) {
      // should receive the boardingResponse
      try {
        print('data Before fetching to the busBoarding model: $data');
        boardingResponse = BusBoarding.fromJson(data);
        print(
            '###### Bus Boarding response ######\n status:${boardingResponse?.validity}, message: ${boardingResponse?.msg} \n #########################');
        if (boardingResponse != null) {
          add(boardingResponseReceived(status: true));
        } else {
          add(boardingResponseReceived(status: false));
        }
      } catch (e) {
        print(' Nooo an Error: $e');
        add(boardingResponseReceived(status: false));
      }
    });
  }

  Future<void> socketDisconnectListener() async {
    socket.on('user-stream-off', (data) {
      // should cancel the socket
      print(
          '>>>>>>>>> From socket Disconnect Listener BusBoarding Bloc: $data');
      if (data == "true") {
        locationSubscription?.pause();
        locationSubscription?.cancel();
        socket.disconnect();
        socket.close();
      }
      print(
          ' ########### From Boarding Bloc socket io ###########\n From server: $data');
    });
  }

  Future<void> resetSocketFlags() async {
    triggerWaitingOnce = true;
    waitOnce = false;
    streamOnce = true;
    cancelOnce = true;
  }

  Future<void> close() {
    BusBoardingBloc().close();
    return super.close();
  }
}
