import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sdp/bussiness_logic/blocs/form_submission_status.dart';
import 'package:sdp/bussiness_logic/blocs/signup_bloc/signup_bloc.dart';

class SignupScreen extends StatefulWidget {
  SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formSignupKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            title: Text('Sign UP'),
            actions: <Widget>[],
            backgroundColor: Color.fromARGB(204, 63, 102, 185).withOpacity(0.9),
          ),
          body: Column(
            children: [
              _signupForm(),
              SizedBox(
                height: 8,
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/login');
                },
                child: Text("Already have an account? Login"),
              ),
            ],
          )),
    );
  }

  bool enterSuspendedOnce = true;
  bool enterErrorOnce = true;

  Widget _signupForm() {
    return BlocListener<SignupBloc, SignupState>(
        listener: (context, state) {
          final formStatus = state.formStatus;
          if (formStatus is SubmissionFailed &&
              enterSuspendedOnce &&
              enterErrorOnce) {
            enterErrorOnce = false;
            _showSnackBar(context, formStatus.exception.toString());
            context.read<SignupBloc>().add(
                SignupError()); // signup error changes form status to suspended to suspend the signup untill changeing input
          } else if (formStatus is SubmissionSuspended && enterSuspendedOnce) {
            enterSuspendedOnce = false;
            print('Signup is suspended. please Try again');
            _showSnackBar(context, 'Signup is suspended. please Try again');
          } else if (formStatus is SubmissionSuccess) {
            _showSnackBar(context, 'Please Login for Verification');
            Navigator.pushNamed(context, '/login');
          }
        },
        child: Form(
          key: _formSignupKey,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _usernameField(),
                _emailField(),
                _passwordField(),
                _loginButton(),
              ],
            ),
          ),
        ));
  }

  Widget _usernameField() {
    return BlocBuilder<SignupBloc, SignupState>(builder: (context, state) {
      return TextFormField(
        decoration: InputDecoration(
          icon: Icon(Icons.person),
          hintText: 'Username',
        ),
        validator: (value) => state.isValidUsername
            ? null
            : 'Username is too short (shoud be >= 3 charachters)',
        onChanged: (value) => context.read<SignupBloc>().add(
              SignupUsernameChanged(username: value),
            ),
      );
    });
  }

  Widget _emailField() {
    return BlocBuilder<SignupBloc, SignupState>(builder: (context, state) {
      return TextFormField(
        decoration: InputDecoration(
          icon: Icon(Icons.email),
          hintText: 'email',
        ),
        validator: (value) => state.isValidEmail ? null : 'Invalid email',
        onChanged: (value) => context.read<SignupBloc>().add(
              SignupEmailChanged(email: value),
            ),
      );
    });
  }

  Widget _passwordField() {
    return BlocBuilder<SignupBloc, SignupState>(builder: (context, state) {
      return TextFormField(
        obscureText: true,
        decoration: InputDecoration(
          icon: Icon(Icons.security),
          hintText: 'Password',
        ),
        validator: (value) => state.isValidPassword
            ? null
            : 'Password is too short ( should be >= 8 charachters)',
        onChanged: (value) => context.read<SignupBloc>().add(
              SignupPasswordChanged(password: value),
            ),
      );
    });
  }

  Widget _loginButton() {
    return BlocBuilder<SignupBloc, SignupState>(builder: (context, state) {
      return state.formStatus is FormSubmitting
          ? CircularProgressIndicator()
          : ElevatedButton(
              onPressed: () {
                if (_formSignupKey.currentState!.validate()) {
                  enterSuspendedOnce = true;
                  enterErrorOnce = true;
                  context.read<SignupBloc>().add(
                      SignupSubmitted()); // signup submitting emit state Formsubmitting and start requesting signup
                }
              },
              child: Text('Signup'),
            );
    });
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
