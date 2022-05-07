part of 'bus_boarding_bloc.dart';

abstract class BusBoardingEvent {}

class RequestBoarding extends BusBoardingEvent {
  final String? ticketid;
  final String? busid;
  final String? username;

  RequestBoarding({
    required this.ticketid,
    required this.busid,
    required this.username,
  });
}

class BoardingError extends BusBoardingEvent {}

class BoardingDone extends BusBoardingEvent {}

class GetLocationBus extends BusBoardingEvent {}

class InitializeBoarding extends BusBoardingEvent {}

class StartLocationStreaming extends BusBoardingEvent {}

class boardingResponseReceived extends BusBoardingEvent {
  final bool status;

  boardingResponseReceived({required this.status});
}

class OpenSocket extends BusBoardingEvent {}

class CloseSocket extends BusBoardingEvent {}
