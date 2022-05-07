class Tickets {
  String id;
  String message;
  bool validity;

  Tickets({required this.id, required this.validity, required this.message});

  factory Tickets.fromJson(Map<String, dynamic> json) {
    return Tickets(
      validity: json['status'],
      message: json['msg'],
      id: json['id'],
    );
  }
}
