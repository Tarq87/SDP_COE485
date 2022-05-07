part of 'points_bloc.dart';

abstract class PointsEvent {}

class RequestPoints extends PointsEvent {
  final String username;

  RequestPoints({
    required this.username,
  });
}

class PointsError extends PointsEvent {}
