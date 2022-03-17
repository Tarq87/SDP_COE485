import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sdp/bussiness_logic/blocs/form_submission_status.dart';
import '../../../data/models/login.dart';
import '../../../data/repositories/login_repository.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
// be careful with part and pat of
part 'login2_event.dart';
part 'login2_state.dart';

class Login2Bloc extends Bloc<Login2Event, Login2State> {
  final LoginRepository? authRepo;
  Login? loginResponse;

  Login2Bloc({this.authRepo})
      : super(Login2State(
          username: '',
          password: '',
          formStatus: InitialFormStatus(),
          loginDetailLoaded: false,
        )) {
    on<LoginUsernameChanged>(
        ((event, emit) => emit(state.copyWith(username: event.username))));
    on<LoginPasswordChanged>(
        ((event, emit) => emit(state.copyWith(password: event.password))));
    on<LoginError>(((event, emit) =>
        emit(state.copyWith(formStatus: SubmissionSuspended()))));
    on<LoginSubmitted>(((event, emit) async {
      emit(state.copyWith(formStatus: FormSubmitting()));

      try {
        loginResponse =
            await authRepo?.sendLoginDetail(state.username, state.password);

        // check first if the login response is null since its nullable (-> ?)

        if (loginResponse != null) {
          if (loginResponse!.validity) {
            emit(state.copyWith(formStatus: SubmissionSuccess()));
            print(
                '\n### Login Response ###\n Response ID: ${loginResponse?.id}\n Response Status: ${loginResponse?.validity}');

            // saveLoginDetail(state); causign problem
          } else {
            // we can add more state in the LoginState to explain why is the login response invalid (username does not exists? for example)
            //
            emit(state.copyWith(
                formStatus: SubmissionFailed(
                    exception: 'invalid username or passowrd')));
          }
        } else {
          emit(state.copyWith(
              formStatus: SubmissionFailed(
                  exception: 'Login response is Null!! Check the backend')));
        }
      } catch (e) {
        emit(state.copyWith(formStatus: SubmissionFailed(exception: e)));
        // For testing only
        await Future.delayed(Duration(seconds: 3));
        emit(state.copyWith(
            formStatus: SubmissionFailed(exception: 'Logging for Testing')));
        await Future.delayed(Duration(seconds: 2));
        emit(state.copyWith(formStatus: SubmissionSuccess()));
      }
    }));
    // ignore
    on<CheckSavedLogin>(((event, emit) async {
      // Obtain shared preferences.
      final prefs = await SharedPreferences.getInstance();
      final String? username = prefs.getString('username');
      final String? password = prefs.getString('password');
      if (username != null && password != null) {
        emit(state.copyWith(
          username: username,
          password: password,
          loginDetailLoaded: true,
        ));
        print('####### username: $username, password: $password ########');
      }
    }));
  }

  Future<void> saveLoginDetail(Login2State state) async {
    // Obtain shared preferences.
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', state.username);
    await prefs.setString('password', state.password);
  }

  @override
  Login2State? fromJson(Map<String, dynamic> json) {
    return Login2State.fromMap(json);
  }

  @override
  Map<String, dynamic>? toJson(Login2State state) {
    return state.toMap();
  }
}
