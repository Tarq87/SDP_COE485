part of 'bus_boarding_bloc.dart';

class BusBoardingState {
  String busID;
  String ticketID;
  double latitude;
  double longitude;
  bool requesting;
  bool boardingStatus;
  bool locationObtained;
  bool boardingInitialized;

  BusBoardingState({
    this.busID = '',
    this.ticketID = '',
    this.latitude = 0.0,
    this.longitude = 0.0,
    this.requesting = false,
    this.boardingStatus = false,
    this.locationObtained = false,
    this.boardingInitialized = false,
  });

  BusBoardingState copyWith({
    String? busID,
    String? ticketID,
    double? latitude,
    double? longitude,
    bool? requesting,
    bool? boardingStatus,
    bool? locationObtained,
    bool? boardingInitialized,
  }) {
    // if the no parameter passed in the copyWith
    // then the current state is passed
    return BusBoardingState(
      busID: busID ?? this.busID,
      ticketID: ticketID ?? this.ticketID,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      requesting: requesting ?? this.requesting,
      boardingStatus: boardingStatus ?? this.boardingStatus,
      locationObtained: locationObtained ?? this.locationObtained,
      boardingInitialized: boardingInitialized ?? this.boardingInitialized,
    );
  }
}
