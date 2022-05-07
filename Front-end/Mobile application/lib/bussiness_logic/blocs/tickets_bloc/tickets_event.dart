part of 'tickets_bloc.dart';

abstract class TicketsEvent {}

class TicketType extends TicketsEvent {
  final int type;

  TicketType({required this.type});
}

class RequestTicket extends TicketsEvent {
  final String username;

  RequestTicket({required this.username});
}

class TicketRequestSent extends TicketsEvent {}

class TicketError extends TicketsEvent {}

class TicketReceived extends TicketsEvent {}

class InitSelectedTicket extends TicketsEvent {}

class GenerateCode extends TicketsEvent {}

class codeGenerated extends TicketsEvent {}

class GeneratingCode extends TicketsEvent {}

class ticketExists extends TicketsEvent {}

class CheckSavedTicket extends TicketsEvent {}
