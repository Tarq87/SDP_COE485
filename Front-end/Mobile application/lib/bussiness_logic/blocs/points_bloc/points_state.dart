part of 'points_bloc.dart';

class PointsState {
  int points;
  String msg;
  bool requesting;
  bool pointsUpdated;

  PointsState({
    this.points = 0,
    this.msg = '',
    this.requesting = false,
    this.pointsUpdated = false,
  });

  PointsState copyWith({
    int? points,
    String? msg,
    bool? requesting,
    bool? pointsUpdated,
  }) {
    // if the no parameter passed in the copyWith
    // then the current state is passed
    return PointsState(
      points: points ?? this.points,
      msg: msg ?? this.msg,
      requesting: requesting ?? this.requesting,
      pointsUpdated: pointsUpdated ?? this.pointsUpdated,
    );
  }
}
