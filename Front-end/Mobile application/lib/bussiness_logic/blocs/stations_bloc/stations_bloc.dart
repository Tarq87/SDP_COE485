//imports
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sdp/data/models/stations.dart';
import 'package:sdp/data/repositories/stations_repository.dart';

// be carefull with part
part 'stations_event.dart';
part 'stations_state.dart';

class StationsBloc extends Bloc<StationsEvent, StationsState> {
  final StationsRepository? stationsRepos;
  Stations? stationsResponse;

  StationsBloc({
    this.stationsRepos,
  }) : super(StationsState(
          names: [],
          lats: [],
          longs: [],
          requesting: false,
          stationsReceived: false,
        )) {
    on<RequestStations>(((event, emit) async {
      emit(state.copyWith(
        requesting: true,
      ));
      // continue sending
      bool reqSent = await _triggerRequest();
      if (reqSent) {
        emit(state.copyWith(
          names: stationsResponse!.names,
          lats: stationsResponse!.lats,
          longs: stationsResponse!.longs,
          requesting: false,
          stationsReceived: true,
        ));
      } else {
        emit(state.copyWith(
          requesting: false,
          stationsReceived: false,
        ));
      }
    }));
  }

  Future<bool> _triggerRequest() async {
    try {
      stationsResponse = await stationsRepos?.sendStationsRequest();
      print('########## Stations names and Locations ##########');
      if (stationsResponse != null) {
        for (int? i = 0; i! <= (stationsResponse!.names.length - 1); i++) {
          print(
              'Station name:${stationsResponse?.names[i]}, latitude: ${stationsResponse?.lats[i]}, longitude: ${stationsResponse?.longs[i]}\n');
        }
        print('####################');
        return true;
      } else {
        print('Null Response!!');
        print('####################');
        return false;
      }
    } catch (e) {
      print(' Nooo an Error: $e');
      return false;
    }
  }

  Future<void> close() {
    StationsBloc().close();
    return super.close();
  }
}
