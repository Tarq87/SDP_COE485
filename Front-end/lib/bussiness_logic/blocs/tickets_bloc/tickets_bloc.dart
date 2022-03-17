//imports
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sdp/bussiness_logic/blocs/login_bloc/login2_bloc.dart';
import 'package:sdp/data/models/tickets.dart';
import 'package:sdp/data/repositories/tickets_repository.dart';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

// be carefull with part
part 'tickets_event.dart';
part 'tickets_state.dart';

class TicketsBloc extends Bloc<TicketsEvent, TicketsState> {
  final TicketsRepository? ticketsRepos;
  Tickets? ticketResponse;

  TicketsBloc({this.ticketsRepos})
      : super(TicketsState(
          user: '',
          id: '',
          type: '',
          validity: false,
          requestingTicket: false,
          ticketReceived: false,
          generateCode: false,
          generatingCode: false,
          codeGenerated: false,
          ticketExists: false,
          ticketLoaded: false,
        )) {
    on<RequestTicket>(((event, emit) async {
      emit(state.copyWith(
        user: event.username,
        requestingTicket: true,
      ));
      bool reqSent = await _triggerRequest();
      emit(state.copyWith(requestingTicket: false));
      if (reqSent) {
        emit(state.copyWith(
          id: ticketResponse!.id,
          validity:
              ticketResponse!.validity, // new tickets sO IT SOPPOSED TO BE TRUE
          ticketReceived: true,
          ticketExists: true,
        ));
        // if ticket received, save its detail
        // saveTicketDetail(state); Ignore for now
      } else {
        emit(state.copyWith(
          id: '',
          validity: false,
          ticketReceived: false,
          ticketExists: false,
        ));
      }
      print(
          '####### user: ${state.user}, ticketID: ${state.id}, type: ${state.type}, validity: ${state.validity} ########');
    }));
    on<TicketType>(((event, emit) {
      // obtain the type from the UI
      emit(state.copyWith(type: event.type));
    }));
    on<GenerateCode>(((event, emit) {
      // obtain the type from the UI
      emit(state.copyWith(
          generateCode: true, codeGenerated: false, ticketReceived: false));
    }));
    on<GeneratingCode>(((event, emit) {
      emit(state.copyWith(
          generateCode: false, codeGenerated: false, generatingCode: true));
    }));
    on<codeGenerated>(((event, emit) {
      emit(state.copyWith(
          generateCode: false, codeGenerated: true, generatingCode: false));
    }));
    // ignore for now
    on<CheckSavedTicket>(((event, emit) async {
      // Obtain shared preferences.
      final prefs = await SharedPreferences.getInstance();
      final String? id = prefs.getString('ticketID');
      final String? type = prefs.getString('type');
      final bool? validity = prefs.getBool('validity');
      if (type != null && id != null && validity != null) {
        emit(state.copyWith(
          id: id,
          type: type,
          validity: validity,
          ticketExists: true,
          ticketLoaded: true,
        ));
        print(
            '####### user: ${state.user}, ticketID: ${state.id}, type: ${state.type}, validity: ${state.validity} ########');
      } else {
        emit(state.copyWith(
          ticketExists: false,
          ticketLoaded: false,
        ));
      }
    }));
  }

  Future<bool> _triggerRequest() async {
    try {
      ticketResponse =
          await ticketsRepos?.sendTicketRequest(state.user, state.type);

      if (ticketResponse != null) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(' Nooo an Error: $e');
      return false;
    }
  }

  Future<void> saveTicketDetail(TicketsState state) async {
    // Obtain shared preferences.
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('ticketID', state.id);
    await prefs.setString('type', state.type);
    await prefs.setBool('validity', state.validity);
  }

  @override
  TicketsState? fromJson(Map<String, dynamic> json) {
    return TicketsState.fromMap(json);
  }

  @override
  Map<String, dynamic>? toJson(TicketsState state) {
    return state.toMap();
  }
}
