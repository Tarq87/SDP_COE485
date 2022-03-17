part of 'tickets_bloc.dart';

class TicketsState {
  String user;
  String id;
  String type;
  bool validity;
  bool requestingTicket;
  bool ticketReceived;
  bool generateCode;
  bool generatingCode;
  bool codeGenerated;
  bool ticketExists;
  bool ticketLoaded;

  TicketsState({
    this.user = '',
    this.id = '',
    this.type = '',
    this.validity = false,
    this.requestingTicket = false,
    this.ticketReceived = false,
    this.generateCode = false,
    this.generatingCode = false,
    this.codeGenerated = false,
    this.ticketExists = false,
    this.ticketLoaded = false,
  });

  TicketsState copyWith({
    String? user,
    String? id,
    String? type,
    bool? validity,
    bool? requestingTicket,
    bool? ticketReceived,
    bool? generateCode,
    bool? generatingCode,
    bool? codeGenerated,
    bool? ticketExists,
    bool? ticketLoaded,
  }) {
    // if the no parameter passed in the copyWith
    // then the current state is passed
    return TicketsState(
      user: user ?? this.user,
      id: id ?? this.id,
      type: type ?? this.type,
      validity: validity ?? this.validity,
      requestingTicket: requestingTicket ?? this.requestingTicket,
      ticketReceived: ticketReceived ?? this.ticketReceived,
      generateCode: generateCode ?? this.generateCode,
      generatingCode: generatingCode ?? this.generatingCode,
      codeGenerated: codeGenerated ?? this.codeGenerated,
      ticketExists: ticketExists ?? this.ticketExists,
      ticketLoaded: ticketLoaded ?? this.ticketLoaded,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'user': user,
      'id': id,
      'type': type,
      'validity': validity,
      'requestingTicket': requestingTicket,
      'ticketReceived': ticketReceived,
      'generateCode': generateCode,
      'generatingCode': generatingCode,
      'codeGenerated': codeGenerated,
      'ticketExists': ticketExists,
    };
  }

  factory TicketsState.fromMap(Map<String, dynamic> map) {
    return TicketsState(
      user: map['user'] ?? '',
      id: map['id'] ?? '',
      type: map['type'] ?? '',
      validity: map['validity'] ?? false,
      requestingTicket: map['requestingTicket'] ?? false,
      ticketReceived: map['ticketReceived'] ?? false,
      generateCode: map['generateCode'] ?? false,
      generatingCode: map['generatingCode'] ?? false,
      codeGenerated: map['codeGenerated'] ?? false,
      ticketExists: map['ticketExists'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory TicketsState.fromJson(String source) =>
      TicketsState.fromMap(json.decode(source));
}
