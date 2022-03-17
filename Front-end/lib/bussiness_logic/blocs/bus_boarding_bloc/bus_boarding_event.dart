part of 'bus_boarding_bloc.dart';

abstract class BusBoardingEvent {}

class RequestBoarding extends BusBoardingEvent {
  final String? ticketid;

  RequestBoarding({
    required this.ticketid,
  });
}

class BoardingError extends BusBoardingEvent {}

class BoardingDone extends BusBoardingEvent {}

class GetLocationBus extends BusBoardingEvent {}

class InitializeBoarding extends BusBoardingEvent {}
