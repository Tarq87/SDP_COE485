class BusBoarding {
  String msg;
  bool validity;

  BusBoarding({required this.msg, required this.validity});

  factory BusBoarding.fromJson(Map<String, dynamic> json) {
    return BusBoarding(
      validity: json['status'],
      msg: json['msg'],
    );
  }
}
