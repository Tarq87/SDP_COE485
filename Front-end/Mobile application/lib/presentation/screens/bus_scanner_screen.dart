import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:sdp/bussiness_logic/blocs/bus_boarding_bloc/bus_boarding_bloc.dart';
import 'package:sdp/bussiness_logic/blocs/login_bloc/login2_bloc.dart';

class BusScanner extends StatefulWidget {
  BusScanner({Key? key}) : super(key: key);

  @override
  State<BusScanner> createState() => _BusScannerState();
}

class _BusScannerState extends State<BusScanner> with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 2),
    vsync: this,
  )..repeat(reverse: true);
  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.elasticOut,
  );

  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  bool oneTime = true;
  bool doneOpenning = false;
  bool doneRequesting = false;
  String BUSID = '';
  bool openScanner = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bus Scanner'),
        actions: <Widget>[],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: BlocBuilder<BusBoardingBloc, BusBoardingState>(
              builder: (Context, state) {
                if (doneOpenning) {
                  doneOpenning = false; // enter once
                  context.read<BusBoardingBloc>().add(OpenSocket());
                  return Text(
                    "Processing...",
                    style: TextStyle(fontSize: 30.0, color: Colors.red),
                  );
                } else if (state.socketOpened && doneRequesting) {
                  doneRequesting = false; // enter once
                  Context.read<BusBoardingBloc>().add(RequestBoarding(
                    ticketid:
                        result?.code, // here we are scanning the ticket QR code
                    busid: BUSID, // bus id is hard coded
                    username: context.read<Login2Bloc>().state.username,
                  ));
                  return Text(
                    "Processing...",
                    style: TextStyle(fontSize: 30.0, color: Colors.red),
                  );
                } else if (state.boardingStatus) {
                  context.read<BusBoardingBloc>().add(StartLocationStreaming());
                  return Column(
                    children: <Widget>[
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Verified Thank You\n\n" + DateTime.now().toString(),
                        style: TextStyle(
                            fontSize: 30.0,
                            color: Color.fromARGB(255, 16, 206, 47)),
                      ),
                      Center(
                        child: RotationTransition(
                          turns: _animation,
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Image(
                                image: AssetImage('assets/photos/correct.png')),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // reinitialize flags
                          // if true it means did not scann anything yet
                          oneTime = true;
                          doneOpenning = false;
                          doneRequesting = false;
                          result = null;
                          context.read<BusBoardingBloc>().add(
                              CloseSocket()); // closing socket  when scanning again that is opened in the previous scan
                          // to trigger BlocBuilder for litsening and displaying the BusScanner
                          context
                              .read<BusBoardingBloc>()
                              .add(InitializeBoarding());
                        },
                        child: Text("Scann again"),
                      ),
                    ],
                  );
                } else if (oneTime &&
                    BUSID != '' &&
                    BUSID.length >= 4 &&
                    openScanner) {
                  return QRView(
                    key: qrKey,
                    onQRViewCreated: _onQRViewCreated,
                  );
                } else if (!state.boardingInitialized &&
                    !state.boardingStatus &&
                    BUSID != '' &&
                    BUSID.length >= 4 &&
                    openScanner) {
                  return Column(
                    children: <Widget>[
                      Text(
                        "Invalid Ticket.\n\nEntrance Denied",
                        style: TextStyle(
                            fontSize: 30.0,
                            color: Color.fromARGB(255, 206, 38, 16)),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // reinitialize flags
                          // if true it means did not scann anything yet
                          oneTime = true;
                          doneOpenning = false;
                          doneRequesting = false;
                          result = null;
                          context.read<BusBoardingBloc>().add(
                              CloseSocket()); // closing socket  when scanning again that is opened in the previous scan
                          // to trigger BlocBuilder for litsening and displaying the MobileScanner
                          context
                              .read<BusBoardingBloc>()
                              .add(InitializeBoarding());
                        },
                        child: Text("Scann again"),
                      ),
                    ],
                  );
                } else {
                  if (BUSID != '' && BUSID.length >= 4) {
                    return Text(
                      "Processing...",
                      style: TextStyle(fontSize: 30.0, color: Colors.red),
                    );
                  } else {
                    return Text(
                      "Please Enter the Bus ID first",
                      style: TextStyle(fontSize: 30.0, color: Colors.red),
                    );
                  }
                }
              },
            ),
          ),
          Container(
            height: 150,
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.only(bottom: 5),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  blurRadius: 3,
                  offset: Offset(5, 5),
                  color: Color.fromARGB(204, 63, 102, 185).withOpacity(0.1),
                ),
                BoxShadow(
                  blurRadius: 3,
                  offset: Offset(-5, -5),
                  color: Color.fromARGB(204, 63, 102, 185).withOpacity(0.1),
                ),
              ],
            ),
            child: Column(
              children: [
                Center(
                  child: (result != null)
                      ? Text(
                          'Barcode Type: //${describeEnum(result!.format)}   Data: ${result!.code}')
                      : Text('Position the QR to face the bus scanner'),
                ),
                TextButton.icon(
                  onPressed: () {
                    _showMyDialog(context);
                  },
                  icon: Icon(Icons.input_outlined),
                  label: const Text(
                    'Enter Bus ID First',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                Text('Current Bus: $BUSID'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) async {
      controller.pauseCamera();
      if (scanData.code != null) {
        if (scanData.code!.length >= 1) {
          doneOpenning = true;
          doneRequesting = true;
          oneTime = false;
        }
      }
      controller.resumeCamera();
      if (doneOpenning && doneRequesting) {
        setState(() {
          result = scanData;
        });
      }
    });
  }

  bool isNumericUsing_tryParse(String? string) {
    // Null or empty string is not a number
    if (string == null || string.isEmpty) {
      return false;
    }

    // Try to parse input string to number.
    // Both integer and double work.
    // Use int.tryParse if you want to check integer only.
    // Use double.tryParse if you want to check double only.
    final number = num.tryParse(string);

    if (number == null) {
      return false;
    }

    return true;
  }

  Future<void> _showMyDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext c) {
        // be careful to change c to context
        return AlertDialog(
          title: const Text('Enter the bus ID'),
          content: SingleChildScrollView(
            child: TextFormField(
              decoration: InputDecoration(
                icon: Icon(Icons.bus_alert),
                hintText: 'Bus ID (i.e. Format xxxx)',
              ),
              validator: (value) => (isNumericUsing_tryParse(value))
                  ? null
                  : 'Only Numbers (i.e. xxxx)',
              onChanged: (value) {
                BUSID = value;
              },
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () async {
                Navigator.of(context).pop();
                await Future.delayed(Duration(seconds: 1));
                setState(() {
                  openScanner = true;
                });
                context.read<BusBoardingBloc>().add(
                    InitializeBoarding()); // just to trigger the bloc listener initially false
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    controller?.dispose();
    super.dispose();
  }
}
