part of 'location_bloc.dart';

abstract class LocationEvent {}

class LocationChanged extends LocationEvent {}

class LocationSent extends LocationEvent {}

class LocationLocadedSuccess extends LocationEvent {}

class LocationLocadedFailed extends LocationEvent {}

class LocationError extends LocationEvent {}

class ShareLocation extends LocationEvent {}

class GetLocation extends LocationEvent {}

class InitializeLocation extends LocationEvent {}
