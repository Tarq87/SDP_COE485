part of 'login2_bloc.dart';

abstract class Login2Event {}

class LoginUsernameChanged extends Login2Event {
  final String username;

  LoginUsernameChanged({required this.username});
}

class LoginPasswordChanged extends Login2Event {
  final String password;

  LoginPasswordChanged({required this.password});
}

class LoginSubmitted extends Login2Event {}

class LoginError extends Login2Event {}

class CheckSavedLogin extends Login2Event {}

class init extends Login2Event {}
