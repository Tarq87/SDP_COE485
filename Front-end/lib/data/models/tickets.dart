class Tickets {
  String id;
  bool validity;

  Tickets({required this.id, required this.validity});

  factory Tickets.fromJson(Map<String, dynamic> json) {
    return Tickets(
      id: json['id'],
      validity: json['status'],
    );
  }
}
