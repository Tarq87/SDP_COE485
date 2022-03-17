class Login {
  final String id;
  late final bool validity;

  Login({this.id = '', this.validity = false});

  Login copyWith({
    String? id,
    bool? validity,
  }) {
    // if the no parameter passed in the copyWith
    // then the current state is passed
    return Login(
      id: id ?? this.id,
      validity: validity ?? this.validity,
    );
  }

  factory Login.fromJson(Map<String, dynamic> json) {
    return Login(
      id: json['id'],
      validity: json['status'],
    );
  }
}
