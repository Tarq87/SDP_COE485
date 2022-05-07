part of 'update_tickets_bloc.dart';

abstract class UpdateTicketsEvent {}

class SendUpdateTickets extends UpdateTicketsEvent {
  final String username;

  SendUpdateTickets({required this.username});
}

class UpdateTicketsError extends UpdateTicketsEvent {}

class TicketsUpdated extends UpdateTicketsEvent {}
