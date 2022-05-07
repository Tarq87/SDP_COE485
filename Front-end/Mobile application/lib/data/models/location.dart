class Location {
  String id;
  bool validity;

  Location({required this.id, required this.validity});

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      id: json['id'],
      validity: json['status'],
    );
  }
}
