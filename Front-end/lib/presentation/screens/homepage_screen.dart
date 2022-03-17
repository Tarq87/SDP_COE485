import 'package:flutter/material.dart';
import 'package:sdp/nav_bar.dart';

final int points = 0;

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String dropdownValue = 'Account';
  bool yourTicketPressed = false;
  bool buyTicketPressed = false;

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 219, 223, 233),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(204, 63, 102, 185).withOpacity(0.9),
        title: Text(
          'Senior Design Project',
          style: TextStyle(
            fontSize: 20,
            // home page color
            color: Color.fromARGB(255, 219, 223, 233),
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.only(top: 5, left: 20, right: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 10),
                // Your Tickets
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 200,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color.fromARGB(199, 54, 62, 175).withOpacity(0.8),
                        Color.fromARGB(204, 63, 102, 185).withOpacity(0.9),
                      ],
                      begin: Alignment.bottomLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                      topRight: Radius.circular(80),
                    ),
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(5, 10),
                        blurRadius: 20,
                        color:
                            Color.fromARGB(199, 54, 62, 175).withOpacity(0.2),
                      ),
                    ],
                  ),
                  child: Container(
                    padding: const EdgeInsets.only(left: 10, top: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Your Tickets",
                          style: TextStyle(
                            fontSize: 25,
                            color: Color.fromARGB(255, 219, 223, 233),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            // First ticket
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(120),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color.fromARGB(199, 54, 62, 175)
                                        .withOpacity(0.8),
                                    blurRadius: 8,
                                    offset: Offset(8, 8),
                                  ),
                                ],
                              ),
                              child: IconButton(
                                iconSize: 120,
                                icon: Image.asset(
                                    "assets/photos/ticketImage.png"),
                                color: Colors.black,
                                onPressed: () {
                                  Navigator.pushNamed(context, '/generateCode');
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                // End of Your Tickets
                SizedBox(
                  height: 10,
                ),
                // Body elements
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    children: <Widget>[
                      // Start of First body row
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, '/payment');
                            },
                            child: Container(
                              height: 150,
                              width: 150,
                              padding: EdgeInsets.only(bottom: 5),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15),
                                image: DecorationImage(
                                  image: AssetImage('assets/photos/buy.png'),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: 3,
                                    offset: Offset(5, 5),
                                    color: Color.fromARGB(204, 63, 102, 185)
                                        .withOpacity(0.1),
                                  ),
                                  BoxShadow(
                                    blurRadius: 3,
                                    offset: Offset(-5, -5),
                                    color: Color.fromARGB(204, 63, 102, 185)
                                        .withOpacity(0.1),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Text(
                                    'Buy a ticket',
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 0, 4, 255),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(child: Container()),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, '/map');
                            },
                            child: Container(
                              height: 150,
                              width: 150,
                              padding: EdgeInsets.only(bottom: 5),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15),
                                image: DecorationImage(
                                  image:
                                      AssetImage('assets/photos/planTrip.png'),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: 3,
                                    offset: Offset(5, 5),
                                    color: Color.fromARGB(204, 63, 102, 185)
                                        .withOpacity(0.1),
                                  ),
                                  BoxShadow(
                                    blurRadius: 3,
                                    offset: Offset(-5, -5),
                                    color: Color.fromARGB(204, 63, 102, 185)
                                        .withOpacity(0.1),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Text(
                                    'Your Location',
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 0, 4, 255),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      // End Of First body Row
                      SizedBox(
                        height: 10,
                      ),
                      // Start of Second body row
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, '/scanner');
                            },
                            child: Container(
                              height: 150,
                              width: 150,
                              padding: EdgeInsets.only(bottom: 5),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15),
                                image: DecorationImage(
                                  fit: BoxFit.fill,
                                  image:
                                      AssetImage('assets/photos/scanner1.png'),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: 3,
                                    offset: Offset(5, 5),
                                    color: Color.fromARGB(204, 63, 102, 185)
                                        .withOpacity(0.1),
                                  ),
                                  BoxShadow(
                                    blurRadius: 3,
                                    offset: Offset(-5, -5),
                                    color: Color.fromARGB(204, 63, 102, 185)
                                        .withOpacity(0.1),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Text(
                                    'Bus Scanner',
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 0, 4, 255),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(child: Container()),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, '/wallet');
                            },
                            child: Container(
                              height: 150,
                              width: 150,
                              padding: EdgeInsets.only(bottom: 5),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15),
                                image: DecorationImage(
                                  fit: BoxFit.fill,
                                  image: AssetImage('assets/photos/wallet.png'),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: 3,
                                    offset: Offset(5, 5),
                                    color: Color.fromARGB(204, 63, 102, 185)
                                        .withOpacity(0.1),
                                  ),
                                  BoxShadow(
                                    blurRadius: 3,
                                    offset: Offset(-5, -5),
                                    color: Color.fromARGB(204, 63, 102, 185)
                                        .withOpacity(0.1),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Text(
                                    'Wallet',
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 0, 4, 255),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      // End Of Second body Row
                    ],
                  ),
                ),
                // End of Body Elements
              ],
            ),
          ),
        ),
      ),
      drawer: NavBar(),
    );
  }

  BoxDecoration myBoxDecoration() {
    return BoxDecoration(
      border: Border.all(color: Colors.black, width: 1.0),
      borderRadius: BorderRadius.all(
          Radius.circular(10.0) //                 <--- border radius here
          ),
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
