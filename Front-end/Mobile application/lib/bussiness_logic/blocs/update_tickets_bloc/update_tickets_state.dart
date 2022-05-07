part of 'update_tickets_bloc.dart';

class UpdateTicketsState {
  List<String> tickets_id;
  List<int> tickets_type;
  bool requesting;
  bool tickets_updated;

  UpdateTicketsState({
    required this.tickets_id,
    required this.tickets_type,
    this.requesting = false,
    this.tickets_updated = false,
  });

  UpdateTicketsState copyWith({
    List<String>? tickets_id,
    List<int>? tickets_type,
    bool? requesting,
    bool? tickets_updated,
  }) {
    // if the no parameter passed in the copyWith
    // then the current state is passed
    return UpdateTicketsState(
      tickets_id: tickets_id ?? this.tickets_id,
      tickets_type: tickets_type ?? this.tickets_type,
      requesting: requesting ?? this.requesting,
      tickets_updated: tickets_updated ?? this.tickets_updated,
    );
  }
}
