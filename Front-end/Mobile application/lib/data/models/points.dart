class Points {
  int points;
  String msg;

  Points({
    required this.points,
    required this.msg,
  });

  factory Points.fromJson(Map<String, dynamic> json) {
    return Points(
      points: json['points'], // int represent total points for the user
      msg: json['msg'], // msg just in case
    );
  }
}
