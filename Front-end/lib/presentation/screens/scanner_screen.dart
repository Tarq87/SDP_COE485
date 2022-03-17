import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:sdp/bussiness_logic/blocs/bus_boarding_bloc/bus_boarding_bloc.dart';

class Scanner extends StatefulWidget {
  Scanner({Key? key}) : super(key: key);

  @override
  State<Scanner> createState() => _ScannerState();
}

class _ScannerState extends State<Scanner> {
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
  bool done = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Code Scanner'),
        actions: <Widget>[],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: BlocBuilder<BusBoardingBloc, BusBoardingState>(
              builder: (Context, state) {
                if (done) {
                  done = false; // enter once
                  Context.read<BusBoardingBloc>().add(RequestBoarding(
                    ticketid: result?.code,
                  ));
                  return Text(
                    "Processing...",
                    style: TextStyle(fontSize: 30.0, color: Colors.red),
                  );
                } else if (state.boardingStatus) {
                  return Column(
                    children: <Widget>[
                      Text(
                        "Verified.\n\nThank you You can enter the bus",
                        style: TextStyle(
                            fontSize: 30.0,
                            color: Color.fromARGB(255, 16, 206, 47)),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // reinitialize flags
                          // if true it means did not scann anything yet
                          oneTime = true;
                          done = false;
                          result = null;
                          // to trigger BlocBuilder for litsening and displaying the Scanner
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
                } else if (!state.boardingInitialized) {
                  return ElevatedButton(
                    onPressed: () {
                      // reinitialize flags
                      // if true it means did not scann anything yet
                      oneTime = true;
                      done = false;
                      // to trigger BlocBuilder for litsening and displaying the Scanner
                      BlocProvider.of<BusBoardingBloc>(context)
                          .add(InitializeBoarding());
                    },
                    child: Text("Scann again"),
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
          Expanded(
            flex: 1,
            child: Center(
              child: (result != null)
                  ? Text(
                      'Barcode Type: //${describeEnum(result!.format)}   Data: ${result!.code}')
                  : Text('Scan a code'),
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
        if (scanData.code!.length >= 8) {
          done = true;
          oneTime = false;
        }
      }
      controller.resumeCamera();
      if (done) {
        setState(() {
          result = scanData;
        });
      }
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
