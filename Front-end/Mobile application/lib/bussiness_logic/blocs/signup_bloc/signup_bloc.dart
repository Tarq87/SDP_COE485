import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sdp/bussiness_logic/blocs/form_submission_status.dart';
import '../../../data/models/signup.dart';
import '../../../data/repositories/signup_repository.dart';
// be careful with part and pat of
part 'signup_event.dart';
part 'signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  final SignupRepository? signupRepo;
  Signup? signupResponse;

  SignupBloc({this.signupRepo}) : super(SignupState()) {
    on<SignupUsernameChanged>(
        ((event, emit) => emit(state.copyWith(username: event.username))));
    on<SignupEmailChanged>(
        ((event, emit) => emit(state.copyWith(email: event.email))));
    on<SignupPasswordChanged>(
        ((event, emit) => emit(state.copyWith(password: event.password))));
    on<SignupError>(((event, emit) =>
        emit(state.copyWith(formStatus: SubmissionSuspended()))));
    on<SignupSubmitted>(((event, emit) async {
      emit(state.copyWith(formStatus: FormSubmitting()));

      try {
        signupResponse = await signupRepo?.sendSignupDetail(
            state.username, state.email, state.password);

        // check first if the login response is null since its nullable (-> ?)

        if (signupResponse != null) {
          if (signupResponse!.validity) {
            emit(state.copyWith(formStatus: SubmissionSuccess()));
            print(
                '\n### Signup Response ###\n Response msg: ${signupResponse?.id}\n Response Status: ${signupResponse?.validity}');
            emit(state.copyWith(formStatus: SubmissionSuspended()));
          } else {
            emit(state.copyWith(
                formStatus: SubmissionFailed(
                    exception: 'msg from backend: ${signupResponse!.id}')));
          }
        } else {
          emit(state.copyWith(
              formStatus: SubmissionFailed(
                  exception: 'Signup response is Null!! Check the backend')));
        }
      } catch (e) {
        emit(state.copyWith(formStatus: SubmissionFailed(exception: e)));
      }
    }));
  }
}
