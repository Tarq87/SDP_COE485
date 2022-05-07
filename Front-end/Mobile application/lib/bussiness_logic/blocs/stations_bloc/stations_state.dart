part of 'stations_bloc.dart';

class StationsState {
  List<String> names;
  List<double> lats;
  List<double> longs;
  bool requesting;
  bool stationsReceived;

  StationsState({
    required this.names,
    required this.lats,
    required this.longs,
    this.requesting = false,
    this.stationsReceived = false,
  });

  StationsState copyWith({
    List<String>? names,
    List<double>? lats,
    List<double>? longs,
    bool? requesting,
    bool? stationsReceived,
  }) {
    // if the no parameter passed in the copyWith
    // then the current state is passed
    return StationsState(
      names: names ?? this.names,
      lats: lats ?? this.lats,
      longs: longs ?? this.longs,
      requesting: requesting ?? this.requesting,
      stationsReceived: stationsReceived ?? this.stationsReceived,
    );
  }
}
