import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sdp/bussiness_logic/blocs/login_bloc/login2_bloc.dart';
import 'package:sdp/bussiness_logic/blocs/tickets_bloc/tickets_bloc.dart';

class Payment extends StatefulWidget {
  @override
  _PaymentState createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  String dropdownValue = 'One Hour Ticket';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfffdfdfdf),
      appBar: AppBar(
        title: Text('Payment'),
        actions: <Widget>[],
      ),
      body: BlocListener<TicketsBloc, TicketsState>(
        listener: (context, state) {
          if (state.requestingTicket) {
            _showSnackBar(context, 'ticket requested');
            Navigator.pushNamed(context, '/generateCode');
          }
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'Select the ticket type',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.normal),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    child: DropdownButton<String>(
                  value: dropdownValue,
                  icon: const Icon(Icons.menu_book_sharp),
                  elevation: 10,
                  style: const TextStyle(color: Colors.deepPurple),
                  underline: Container(
                    height: 4,
                    color: Colors.deepPurpleAccent,
                  ),
                  onChanged: (String? newValue) {
                    setState(() {
                      dropdownValue = newValue!;
                    });
                  },
                  items: <String>[
                    'One Hour Ticket',
                    'Two Hour Ticket',
                    'One Day Ticket'
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                )),
                SizedBox(
                  width: 20,
                ),
                Container(
                  child: BlocBuilder<TicketsBloc, TicketsState>(
                    builder: (context, state) {
                      return TextButton(
                        onPressed: () async {
                          if (dropdownValue == '') {
                            _showSnackBar(
                                context, 'Please select a ticket type');
                          } else {
                            context
                                .read<TicketsBloc>()
                                .add(TicketType(type: dropdownValue));
                            // use the login username
                            context.read<TicketsBloc>().add(RequestTicket(
                                username:
                                    context.read<Login2Bloc>().state.username));
                          }
                        },
                        child: Text(
                          "Buy",
                          style: TextStyle(
                            color: Colors.deepPurpleAccent,
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                          ),
                        ),
                        // child: RoundedRectangleBorder(
                        //   side: BorderSide(color: Colors.blue, width: 3.0),
                        //   borderRadius: BorderRadius.circular(20.0)),
                      );
                    },
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
