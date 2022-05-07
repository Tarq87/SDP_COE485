import 'dart:convert';

class UpdateTickets {
  List<String> tickets_id;
  List<int> tickets_type;

  UpdateTickets({
    required this.tickets_id,
    required this.tickets_type,
  });

  factory UpdateTickets.fromJson(String json) {
    // not decoded
    var tickets_id_json =
        jsonDecode(json)['ticket_id']; // contains the names list
    var tickets_type_json =
        jsonDecode(json)['ticket_type']; // contains the Longitudes list

    // names = tagsJson != null ? List.from(tagsJson) : null;

    return UpdateTickets(
      tickets_id: List<String>.from(tickets_id_json),
      tickets_type: List<int>.from(tickets_type_json),
    );
  }
}
