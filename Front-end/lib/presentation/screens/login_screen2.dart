import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sdp/bussiness_logic/blocs/form_submission_status.dart';
import 'package:sdp/bussiness_logic/blocs/login_bloc/login2_bloc.dart';

class LoginView extends StatefulWidget {
  LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  bool loginOnce = true;
  bool sendOnce = true;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Login'),
          actions: <Widget>[],
          backgroundColor: Color.fromARGB(204, 63, 102, 185).withOpacity(0.9),
        ),
        body: BlocBuilder<Login2Bloc, Login2State>(
          builder: (context, state) {
            // for logging in automatically
            /*
            if (loginOnce) {
              context.read<Login2Bloc>().add(CheckSavedLogin());
              loginOnce = false;
            }
            if (state.loginDetailLoaded && sendOnce) {
              sendOnce = false;
              context.read<Login2Bloc>().add(LoginSubmitted());
              return Text(
                "Logging in...",
                style: TextStyle(
                    fontSize: 30.0, color: Color.fromARGB(255, 16, 206, 47)),
              );
            } else if (state.loginDetailLoaded) {
              return Text(
                "Logging in...",
                style: TextStyle(
                    fontSize: 30.0, color: Color.fromARGB(255, 16, 206, 47)),
              );
            } else {
              */
            return Column(
              children: [
                _loginForm(),
                SizedBox(
                  height: 8,
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/home');
                  },
                  child: Text('Force Login'),
                ),
                SizedBox(
                  height: 8,
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/signup');
                  },
                  child: Text("Don't have an account? Sign Up"),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  bool enterLoginSuspendedOnce = true;

  Widget _loginForm() {
    return BlocListener<Login2Bloc, Login2State>(
        listener: (context, state) {
          final formStatus = state.formStatus;
          if (formStatus is SubmissionFailed && enterLoginSuspendedOnce) {
            _showSnackBar(context, formStatus.exception.toString());
            context.read<Login2Bloc>().add(
                LoginError()); // signup error changes form status to suspended to suspend the signup untill changeing input
          } else if (formStatus is SubmissionSuspended &&
              enterLoginSuspendedOnce) {
            enterLoginSuspendedOnce = false;
            print('Login is suspended. please Try again');
            _showSnackBar(context, 'Login is suspended. please Try again');
          } else if (formStatus is SubmissionSuccess) {
            Navigator.pushNamed(context, '/home');
          }
        },
        child: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _usernameField(),
                _passwordField(),
                SizedBox(
                  height: 8,
                ),
                _loginButton(),
              ],
            ),
          ),
        ));
  }

  Widget _usernameField() {
    return BlocBuilder<Login2Bloc, Login2State>(builder: (context, state) {
      return TextFormField(
        decoration: InputDecoration(
          icon: Icon(Icons.person),
          hintText: 'Username',
        ),
        validator: (value) => state.isValidUsername
            ? null
            : 'Username is too short (> 2 charachters)',
        onChanged: (value) => context.read<Login2Bloc>().add(
              LoginUsernameChanged(username: value),
            ),
      );
    });
  }

  Widget _passwordField() {
    return BlocBuilder<Login2Bloc, Login2State>(builder: (context, state) {
      return TextFormField(
        obscureText: true,
        decoration: InputDecoration(
          icon: Icon(Icons.security),
          hintText: 'Password',
        ),
        validator: (value) => state.isValidPassword
            ? null
            : 'Password is too short (> 7 charachters)',
        onChanged: (value) => context.read<Login2Bloc>().add(
              LoginPasswordChanged(password: value),
            ),
      );
    });
  }

  Widget _loginButton() {
    return BlocBuilder<Login2Bloc, Login2State>(builder: (context, state) {
      return state.formStatus is FormSubmitting
          ? CircularProgressIndicator()
          : ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  enterLoginSuspendedOnce = true;
                  context.read<Login2Bloc>().add(LoginSubmitted());
                }
              },
              child: Text('Login'),
            );
    });
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
