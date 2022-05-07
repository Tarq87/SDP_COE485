import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:sdp/bussiness_logic/blocs/tickets_bloc/tickets_bloc.dart';

class GeneratePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => GeneratePageState();
}

class GeneratePageState extends State<GeneratePage> {
  bool generateOnce = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Code Generator'),
        actions: <Widget>[],
      ),
      backgroundColor: Color(0xfffdfdfdf),
      body: SingleChildScrollView(
        child: BlocBuilder<TicketsBloc, TicketsState>(
          builder: (context, state) {
            if (state.requestingTicket) {
              return Text(
                "Requesting your Ticket...",
                style: TextStyle(
                    fontSize: 30.0, color: Color.fromARGB(255, 54, 244, 101)),
              );
              // if we are not requesting a ticket and it does not exists >> means no tikets received
            } else if (!state.requestingTicket && !state.ticketExists) {
              return Text(
                "Requested ticket is NOT received!!!!!",
                style: TextStyle(fontSize: 30.0, color: Colors.red),
              );
            } else {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  QrImage(
                    //plce where the QR Image will be shown
                    data: state.id,
                    version: QrVersions.auto,
                    size: 250.0,
                    errorStateBuilder: (cxt, err) {
                      return Container(
                        child: Center(
                          child: Text(
                            "Uh oh! Something went wrong...",
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    "${state.type} QR Code",
                    style: TextStyle(fontSize: 20.0),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
/*
  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
*/
}
