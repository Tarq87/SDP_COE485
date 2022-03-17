//imports
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:location/location.dart' as global;
import 'package:sdp/bussiness_logic/blocs/login_bloc/login2_bloc.dart';
import 'package:sdp/data/models/location.dart';
import 'package:sdp/data/repositories/location_repository.dart';
// be carefull with part
part 'location_event.dart';
part 'location_state.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  final LocationRepository? locationRepos;
  Location? locationResponse;

  LocationBloc({this.locationRepos})
      : super(LocationState(
          sender: "NoOne",
          latitude: 0.0,
          longitude: 0.0,
          speed: 0.0,
          locationLoaded: false,
          locationSent: false,
          locationInitialized: false,
        )) {
    on<ShareLocation>(((event, emit) async {
      print(' ############ Sendign Location to backend ###############');
      bool posLoaded = await _determineLiveLocation();
      if (posLoaded) {
        emit(state.copyWith(
          sender: Login2State().username,
          locationLoaded: true,
          locationSent: false,
        ));
        print(
            'From Location Bloc:\n >>> sender = ${state.sender}\n >>> latitude = ${state.latitude}\n >>> longitude = ${state.longitude}\n >>> speed = ${state.speed}');
        // continue to send location
        bool posSent = await triggerSending();
        if (posSent) {
          print(
              '##### Entering to change locationSent state in location bloc [Before change]  = ${state.locationSent}');
          emit(state.copyWith(locationSent: true));
          print(
              '##### Entering to change locationSent state in location bloc [after Change]  = ${state.locationSent}');
        } else {
          emit(state.copyWith(locationSent: false));
        }
        print(
            ' ########## From Location Bloc: locationSent state [the End] = ${state.locationSent} #########');
      } else {
        emit(state.copyWith(locationLoaded: false));
      }
    }));
    // only get
    on<GetLocation>(((event, emit) async {
      bool posLoaded = await _determineLiveLocation();
      if (posLoaded) {
        emit(state.copyWith(
          sender: Login2State().username,
          locationLoaded: true,
        ));
        print(
            'From Location Bloc:\n >>> sender = ${state.sender}\n >>> latitude = ${state.latitude}\n >>> longitude = ${state.longitude}\n >>> speed = ${state.speed}');
      } else {
        emit(state.copyWith(locationLoaded: false));
      }
    }));

    on<InitializeLocation>(((event, emit) {
      emit(state.copyWith(
        locationInitialized: true,
      ));
    }));
  }

  Future<bool> triggerSending() async {
    try {
      print('\n### Before Sending Location Block}');
      locationResponse = await locationRepos?.sendLocationDetail(
          state.sender, state.latitude, state.longitude, state.speed);

      // check first if the login response is null since its nullable (-> ?)
      print(
          "### ### ### After sending location and Checking if Location response is Null id = ${locationResponse?.id}, validity = ${locationResponse?.validity}");

      if (locationResponse != null) {
        if (locationResponse!.validity) {
          print(
              '\n### Location sent successfully ###\n Response Status: ${locationResponse?.validity}');
        } else {
          // we can add more state in the LoginState to explain why is the login response invalid (username does not exists? for example)
          //
          print(
              '\n### backend responded with false   ###\n Response Status: ${locationResponse?.validity}');
        }
        return true;
      } else {
        print('location response is Null!! Check the backend');
        return false;
      }
    } catch (e) {
      print(' Nooo an Error: $e');
      return false;
    }
  }

  /// Determine the current position of the device.
  ///
  /// When the location services are not enabled or permissions
  /// are denied the `Future` will return an error.
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
      state.speed = currentLocation.speed!;

      return true;
    } catch (e) {
      print('Error caused by live Listening: $e');
      return false;
    }
  }
}
