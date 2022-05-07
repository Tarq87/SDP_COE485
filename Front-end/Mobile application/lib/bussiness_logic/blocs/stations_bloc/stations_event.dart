part of 'stations_bloc.dart';

abstract class StationsEvent {}

class RequestStations extends StationsEvent {}

class StationsError extends StationsEvent {}

class StationsObtained extends StationsEvent {}
