class BusBoarding {
  String id;
  bool validity;

  BusBoarding({required this.id, required this.validity});

  factory BusBoarding.fromJson(Map<String, dynamic> json) {
    return BusBoarding(
      id: json['id'],
      validity: json['status'],
    );
  }
}
