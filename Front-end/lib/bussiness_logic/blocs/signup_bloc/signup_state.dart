part of 'signup_bloc.dart';

class SignupState {
  final String username;
  bool get isValidUsername => username.length >= 3;

  final String email;
  bool get isValidEmail =>
      email.contains('@'); // return false if no @ in the email

  final String password;
  bool get isValidPassword => password.length >= 8;

  final FormSubmissionStatus formStatus;

  SignupState({
    this.username = '',
    this.email = '',
    this.password = '',
    this.formStatus = const InitialFormStatus(),
  });

  SignupState copyWith({
    String? username,
    String? email,
    String? password,
    FormSubmissionStatus? formStatus,
  }) {
    // if the no parameter passed in the copyWith
    // then the current state is passed
    return SignupState(
      username: username ?? this.username,
      email: email ?? this.email,
      password: password ?? this.password,
      formStatus: formStatus ?? this.formStatus,
    );
  }
}
