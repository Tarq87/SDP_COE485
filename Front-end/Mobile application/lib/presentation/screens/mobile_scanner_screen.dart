import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:sdp/bussiness_logic/blocs/bus_boarding_bloc/bus_boarding_bloc.dart';
import 'package:sdp/bussiness_logic/blocs/login_bloc/login2_bloc.dart';
import 'package:sdp/bussiness_logic/blocs/tickets_bloc/tickets_bloc.dart';

class MobileScanner extends StatefulWidget {
  MobileScanner({Key? key}) : super(key: key);

  @override
  State<MobileScanner> createState() => _MobileScannerState();
}

class _MobileScannerState extends State<MobileScanner>
    with TickerProviderStateMixin {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mobile Scanner'),
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
                  doneRequesting = false;
                  Context.read<BusBoardingBloc>().add(RequestBoarding(
                    ticketid: context.read<TicketsBloc>().state.id,
                    busid: result
                        ?.code, // here scanning QR code on the bus that contain the bus id
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
                          // to trigger BlocBuilder for litsening and displaying the MobileScanner
                          context
                              .read<BusBoardingBloc>()
                              .add(InitializeBoarding());
                        },
                        child: Text("Scann again"),
                      ),
                    ],
                  );
                } else if (oneTime) {
                  return QRView(
                    key: qrKey,
                    onQRViewCreated: _onQRViewCreated,
                  );
                } else if (!state.boardingInitialized &&
                    !state.boardingStatus) {
                  context.read<BusBoardingBloc>().add(CloseSocket());
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
                  return Text(
                    "Processing...",
                    style: TextStyle(fontSize: 30.0, color: Colors.red),
                  );
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
            child: Center(
              child: (result != null)
                  ? Text(
                      'Barcode Type: //${describeEnum(result!.format)}   Data: ${result!.code}')
                  : Text('Please scan the Bus QR'),
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

  @override
  void dispose() {
    _controller.dispose();
    controller?.dispose();
    super.dispose();
  }
}
