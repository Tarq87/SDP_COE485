//imports
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sdp/data/models/update_tickets.dart';
import 'package:sdp/data/repositories/update_tickets_repository.dart';

// be carefull with part
part 'update_tickets_event.dart';
part 'update_tickets_state.dart';

class UpdateTicketsBloc extends Bloc<UpdateTicketsEvent, UpdateTicketsState> {
  final UpdateTicketsRepository? updateTicketsRepos;
  UpdateTickets? updateTicketsResponse;
  String username = '';

  UpdateTicketsBloc({
    this.updateTicketsRepos,
  }) : super(UpdateTicketsState(
          tickets_id: [],
          tickets_type: [],
          requesting: false,
          tickets_updated: false,
        )) {
    on<SendUpdateTickets>(((event, emit) async {
      username = event.username;
      emit(state.copyWith(
        requesting: true,
      ));
      // continue sending
      bool reqSent = await _triggerRequest();
      if (reqSent) {
        emit(state.copyWith(
          tickets_id: updateTicketsResponse!.tickets_id,
          tickets_type: updateTicketsResponse!.tickets_type,
          requesting: false,
          tickets_updated: true,
        ));
      } else {
        emit(state.copyWith(
          requesting: false,
          tickets_updated: false,
        ));
      }
    }));
  }

  Future<bool> _triggerRequest() async {
    try {
      updateTicketsResponse =
          await updateTicketsRepos?.sendUpdateTicketsRequest(username);
      print('########## UpdateTickets tickets_id and tickets_type ##########');
      if (updateTicketsResponse != null) {
        for (int? i = 0;
            i! <= (updateTicketsResponse!.tickets_id.length - 1);
            i++) {
          print(
              'Ticket ID:${updateTicketsResponse?.tickets_id[i]}, Ticket Type: ${updateTicketsResponse?.tickets_type[i]}\n');
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
    UpdateTicketsBloc().close();
    return super.close();
  }
}
