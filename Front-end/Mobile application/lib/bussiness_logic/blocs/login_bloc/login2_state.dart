part of 'login2_bloc.dart';

class Login2State {
  final String username;
  bool get isValidUsername => username.length >= 3;

  final String password;
  bool get isValidPassword => password.length >= 8;

  final FormSubmissionStatus formStatus;

  bool loginDetailLoaded;

  Login2State({
    this.username = '',
    this.password = '',
    this.formStatus = const InitialFormStatus(),
    this.loginDetailLoaded = false,
  });

  Login2State copyWith({
    String? username,
    String? password,
    FormSubmissionStatus? formStatus,
    bool? loginDetailLoaded,
  }) {
    // if the no parameter passed in the copyWith
    // then the current state is passed
    return Login2State(
      username: username ?? this.username,
      password: password ?? this.password,
      formStatus: formStatus ?? this.formStatus,
      loginDetailLoaded: loginDetailLoaded ?? this.loginDetailLoaded,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'password': password,
      'formStatus': formStatus,
    };
  }

  factory Login2State.fromMap(Map<String, dynamic> map) {
    return Login2State(
      username: map['username'] ?? '',
      password: map['password'] ?? '',
      formStatus: map['formStatus'] ?? InitialFormStatus(),
    );
  }

  String toJson() => json.encode(toMap());

  factory Login2State.fromJson(String source) =>
      Login2State.fromMap(json.decode(source));
}
