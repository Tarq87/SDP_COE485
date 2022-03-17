import 'dart:convert';
import 'package:sdp/data/data_providers/tickets_api.dart';
import 'package:sdp/data/models/tickets.dart';

class TicketsRepository {
  TicketsRepository();
  final TicketsAPI api = TicketsAPI();

  Future<Tickets> sendTicketRequest(String username, String ticketType) async {
    String rawTicketResponse = await api.requestTicket(username, ticketType);
    Tickets ticket = Tickets.fromJson(jsonDecode(rawTicketResponse));
    return ticket;
  }
}
