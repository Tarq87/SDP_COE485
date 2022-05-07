part of 'location_bloc.dart';

class LocationState {
  String sender;
  double latitude;
  double longitude;
  double speed;
  bool locationLoaded;
  bool locationSent;
  bool locationInitialized;

  LocationState({
    this.sender = '',
    this.latitude = 0.0,
    this.longitude = 0.0,
    this.speed = 0.0,
    this.locationLoaded = false,
    this.locationSent = false,
    this.locationInitialized = false,
  });

  LocationState copyWith(
      {String? sender,
      double? latitude,
      double? longitude,
      double? speed,
      bool? locationLoaded,
      bool? locationSent,
      bool? locationInitialized}) {
    // if the no parameter passed in the copyWith
    // then the current state is passed
    return LocationState(
      sender: sender ?? this.sender,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      speed: speed ?? this.speed,
      locationLoaded: locationLoaded ?? this.locationLoaded,
      locationSent: locationSent ?? this.locationSent,
      locationInitialized: locationInitialized ?? this.locationInitialized,
    );
  }
}
