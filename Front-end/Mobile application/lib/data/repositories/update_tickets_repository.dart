import 'package:sdp/data/data_providers/update_tickets_api.dart';
import 'package:sdp/data/models/update_tickets.dart';

class UpdateTicketsRepository {
  UpdateTicketsRepository();
  final UpdateTicketsAPI api = UpdateTicketsAPI();

  Future<UpdateTickets> sendUpdateTicketsRequest(String username) async {
    String rawUpdateTicketsResponse = await api.requestUpdateTickets(username);
    UpdateTickets tickets = UpdateTickets.fromJson(rawUpdateTicketsResponse);
    return tickets;
  }
}
