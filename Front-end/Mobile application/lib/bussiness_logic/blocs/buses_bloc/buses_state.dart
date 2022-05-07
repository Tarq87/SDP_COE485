part of 'buses_bloc.dart';

class BusesState {
  List<String> buses_id;
  List<double> lats;
  List<double> longs;
  bool requesting;
  bool busesReceived;

  BusesState({
    required this.buses_id,
    required this.lats,
    required this.longs,
    this.requesting = false,
    this.busesReceived = false,
  });

  BusesState copyWith({
    List<String>? buses_id,
    List<double>? lats,
    List<double>? longs,
    bool? requesting,
    bool? busesReceived,
  }) {
    // if the no parameter passed in the copyWith
    // then the current state is passed
    return BusesState(
      buses_id: buses_id ?? this.buses_id,
      lats: lats ?? this.lats,
      longs: longs ?? this.longs,
      requesting: requesting ?? this.requesting,
      busesReceived: busesReceived ?? this.busesReceived,
    );
  }
}
