class Signup {
  final String id;
  late final bool validity;

  Signup({this.id = '', this.validity = false});

  Signup copyWith({
    String? id,
    bool? validity,
  }) {
    // if the no parameter passed in the copyWith
    // then the current state is passed
    return Signup(
      id: id ?? this.id,
      validity: validity ?? this.validity,
    );
  }

  factory Signup.fromJson(Map<String, dynamic> json) {
    return Signup(
      validity: json['status'],
      id: json['msg'],
    );
  }
}
