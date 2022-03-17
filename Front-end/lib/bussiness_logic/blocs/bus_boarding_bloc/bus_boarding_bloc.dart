//imports
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sdp/data/models/bus_boarding.dart';
import 'package:sdp/data/repositories/bus_boarding_repository.dart';
import 'package:location/location.dart' as global;

// be carefull with part
part 'bus_boarding_event.dart';
part 'bus_boarding_state.dart';

class BusBoardingBloc extends Bloc<BusBoardingEvent, BusBoardingState> {
  final BusBoardingRepository? busBoardingRepos;
  BusBoarding? boardingResponse;

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
        )) {
    on<RequestBoarding>(((event, emit) async {
      // then chane state accordingly

      emit(state.copyWith(
        boardingInitialized: true,
      ));
      emit(state.copyWith(
        busID: '10',
        requesting: true,
        boardingStatus: false,
        locationObtained: false,
      ));

      bool getLocation = await _determineLiveLocation();

      if (getLocation) {
        emit(state.copyWith(
          ticketID: event.ticketid,
          latitude: state.latitude,
          longitude: state.longitude,
          locationObtained: true,
        ));
        // continue sending
        bool reqSent = await _triggerRequest();
        if (reqSent) {
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
      } else {
        emit(state.copyWith(
          locationObtained: false,
        ));
      }
      emit(state.copyWith(
        boardingInitialized: false,
      ));
    }));

    on<BoardingDone>(((event, emit) {
      print('######### Entering Boarding Done');
      emit(state.copyWith(
        locationObtained: true,
      ));
    }));

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

    on<InitializeBoarding>(((event, emit) {
      emit(state.copyWith(
        boardingInitialized: true,
        boardingStatus: false,
      ));
    }));
  }

  Future<bool> _triggerRequest() async {
    try {
      boardingResponse = await busBoardingRepos?.sendBoardingRequest(
        state.busID,
        state.ticketID,
        state.latitude,
        state.longitude,
      );

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

  Future<void> close() {
    BusBoardingBloc().close();
    return super.close();
  }
}
