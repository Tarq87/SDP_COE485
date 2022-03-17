import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';

class Welcome extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => WelcomeView();
}

class WelcomeView extends State<Welcome> {
  final int skipFlex = 0;
  @override
  Widget build(BuildContext context) => SafeArea(
        child: IntroductionScreen(
          pages: [
            PageViewModel(
              title: 'WELCOME TO BUS MANAGEMENT SYSTEM',
              body: 'Senior Design Project',
              image: Image.asset('assets/photos/login.jpg'),
              decoration: getPageDecoration(),
            ),
            PageViewModel(
              title: 'Your Way to Work is Faster Now',
              body: 'Buy your ticket now in 1 minute',
              image: Image.asset('assets/photos/fast.png'),
              decoration: getPageDecoration(),
            ),
            // PageViewModel(
            //   title: 'Collect Rewards',
            //   body: 'Get points for every ticket you buy',
            //   image: Image.asset('assets/photos/Rewards.png'),
            //   decoration: getPageDecoration(),
            // ),
            PageViewModel(
              title: 'Collect Rewards',
              body: 'Get points for every ticket you buy',
              footer: ElevatedButton(
                child: Text('Register Now'),
                onPressed: () => goToSignup(context),
              ),
              image: Image.asset('assets/photos/Rewards.png'),
              decoration: getPageDecoration(),
            ),
          ],
          done: Text('Login', style: TextStyle(fontWeight: FontWeight.w600)),
          onDone: () => goToSignin(context),
          showSkipButton: true,
          skip: Text('Skip'),
          onSkip: () => goToSignin(context),
          next: Icon(Icons.arrow_forward),
          dotsDecorator: getDotDecoration(),
          onChange: (index) => print('Page $index selected'),
          globalBackgroundColor: Theme.of(context).primaryColor,
          dotsFlex: 0,
          nextFlex: 0,
          // isProgressTap: false,
          // isProgress: false,
          // showNextButton: false,
          // freeze: true,
          // animationDuration: 1000,
        ),
      );

  void goToSignin(context) => Navigator.pushNamed(context, '/login');
  void goToSignup(context) => Navigator.pushNamed(context, '/signup');

  Widget buildImage(String path) =>
      Center(child: Image.asset(path, width: 350));

  DotsDecorator getDotDecoration() => DotsDecorator(
        color: Color(0xFFBDBDBD),
        //activeColor: Colors.orange,
        size: Size(10, 10),
        activeSize: Size(22, 10),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      );

  PageDecoration getPageDecoration() => PageDecoration(
        titleTextStyle: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        bodyTextStyle: TextStyle(fontSize: 20),
        //descriptionPadding: EdgeInsets.all(16).copyWith(bottom: 0),
        imagePadding: EdgeInsets.all(24),
        pageColor: Colors.white,
      );
}
