//imports
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sdp/data/models/buses.dart';
import 'package:sdp/data/repositories/buses_repository.dart';

// be carefull with part
part 'buses_event.dart';
part 'buses_state.dart';

class BusesBloc extends Bloc<BusesEvent, BusesState> {
  final BusesRepository? busesRepos;
  Buses? busesResponse;

  BusesBloc({
    this.busesRepos,
  }) : super(BusesState(
          buses_id: [],
          lats: [],
          longs: [],
          requesting: false,
          busesReceived: false,
        )) {
    on<RequestBuses>(((event, emit) async {
      emit(state.copyWith(
        requesting: true,
      ));
      // continue sending
      bool reqSent = await _triggerRequest();
      if (reqSent) {
        emit(state.copyWith(
          buses_id: busesResponse!.buses_id,
          lats: busesResponse!.lats,
          longs: busesResponse!.longs,
          requesting: false,
          busesReceived: true,
        ));
      } else {
        emit(state.copyWith(
          requesting: false,
          busesReceived: false,
        ));
      }
    }));
  }

  Future<bool> _triggerRequest() async {
    try {
      busesResponse = await busesRepos?.sendBusesRequest();
      print('########## buses_id and Locations ##########');
      if (busesResponse != null) {
        for (int? i = 0; i! <= (busesResponse!.buses_id.length - 1); i++) {
          print(
              'Bus ID:${busesResponse?.buses_id[i]}, latitude: ${busesResponse?.lats[i]}, longitude: ${busesResponse?.longs[i]}\n');
        }
        print('# # # # # # # # # # # # # # # # # #');
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
    BusesBloc().close();
    return super.close();
  }
}
