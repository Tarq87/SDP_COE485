part of 'buses_bloc.dart';

abstract class BusesEvent {}

class RequestBuses extends BusesEvent {}

class BusesError extends BusesEvent {}

class BusesObtained extends BusesEvent {}
