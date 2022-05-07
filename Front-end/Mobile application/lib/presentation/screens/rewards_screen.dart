import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';

class Rewards extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => RewardsView();
}

class RewardsView extends State<Rewards> {
  final int skipFlex = 0;
  @override
  Widget build(BuildContext context) => SafeArea(
        child: IntroductionScreen(
          pages: [
            PageViewModel(
              title: 'Collect Points and Buy More',
              body:
                  'your best choice for transportation\n\nsave money and help others by sharing',
              image: Image.asset('assets/photos/contribute.png'),
              decoration: getPageDecoration(),
            ),
            PageViewModel(
              title: 'How to Earn Points?',
              image: Image.asset('assets/photos/enable.jpg'),
              decoration: getPageDecoration(),
              bodyWidget: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '       Buy tickets\n\nShare Your Location',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Container(
                    child: TextButton.icon(
                      onPressed: () {
                        Navigator.pushNamed(context, '/settings');
                      },
                      icon: Icon(Icons.input_outlined),
                      label: const Text(
                        'Enable Sharing',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // PageViewModel(
            //   title: 'Collect Rewards',
            //   body: 'Get points for every ticket you buy',
            //   image: Image.asset('assets/photos/Rewards.png'),
            //   decoration: getPageDecoration(),
            // ),
          ],
          done: Text('Done', style: TextStyle(fontWeight: FontWeight.w600)),
          onDone: () => goToHome(context),
          showSkipButton: true,
          skip: Text('Skip'),
          onSkip: () => goToHome(context),
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

  void goToHome(context) => Navigator.pushNamed(context, '/home');

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
