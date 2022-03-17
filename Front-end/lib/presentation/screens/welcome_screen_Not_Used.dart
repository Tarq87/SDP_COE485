import 'package:flutter/material.dart';

class Welcome extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => WelcomeView();
}

class WelcomeView extends State<Welcome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "WELCOME TO BUS MANAGEMENT SYSTEM",
                style: TextStyle(
                    fontSize: 28,
                    color: Color(0xFFFF8084),
                    fontWeight: FontWeight.bold),
              ),
              Text(
                "BMS",
                style: TextStyle(
                    fontSize: 45,
                    color: Color.fromARGB(255, 114, 13, 16),
                    fontWeight: FontWeight.bold),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/login');
                },
                child: Text(
                  "Login",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/signup');
                },
                child: Text(
                  "Sign Up",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
