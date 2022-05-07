import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sdp/bussiness_logic/blocs/login_bloc/login2_bloc.dart';
import 'package:sdp/bussiness_logic/blocs/tickets_bloc/tickets_bloc.dart';
import 'package:number_inc_dec/number_inc_dec.dart';

class Payment extends StatefulWidget {
  @override
  _PaymentState createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  int numberOfPeople = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfffdfdfdf),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(204, 63, 102, 185).withOpacity(0.9),
        title: Text('Payment'),
        actions: <Widget>[],
      ),
      body: BlocListener<TicketsBloc, TicketsState>(
        listener: (context, state) {
          if (state.requestingTicket) {
            _showSnackBar(context, 'ticket requested');
            Navigator.pushNamed(context, '/yourTickets');
          }
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'Your tickets will be valid for one hour\n\n\nPlease select Number of Passengers per ticket',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.normal),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
/* 
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
                    'one passenger ticket',
                    'two passengers ticket',
                    'three passengers ticket',
                    'four passengers ticket',
                    'five passengers ticket'
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                )),
*/
                SizedBox(
                  width: 20,
                ),
              ],
            ),
            SizedBox(
              width: 10,
            ),
            Container(
              padding: const EdgeInsets.only(left: 100, right: 100),
              child: NumberInputPrefabbed.roundedButtons(
                controller: TextEditingController(),
                onIncrement: (num newIncrement) {
                  numberOfPeople = newIncrement.toInt();
                  print('Newly incrmented value is $newIncrement');
                },
                onDecrement: (num newDecrement) {
                  numberOfPeople = newDecrement.toInt();
                  print('Newly decremented value is $newDecrement');
                },
                initialValue: 1,
                min: 1,
                max: 5,
                incDecBgColor:
                    Color.fromARGB(204, 63, 102, 185).withOpacity(0.9),
                buttonArrangement: ButtonArrangement.incRightDecLeft,
                widgetContainerDecoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                  border: Border.all(
                    color: Color.fromARGB(204, 63, 102, 185).withOpacity(0.9),
                    width: 3,
                  ),
                ),
                incIconSize: 28,
                decIconSize: 28,
                incIcon: Icons.plus_one,
                decIcon: Icons.exposure_neg_1,
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Container(
              child: BlocBuilder<TicketsBloc, TicketsState>(
                builder: (context, state) {
                  return TextButton(
                    onPressed: () async {
                      context
                          .read<TicketsBloc>()
                          .add(TicketType(type: numberOfPeople));
                      // use the login username
                      context.read<TicketsBloc>().add(RequestTicket(
                          username: context.read<Login2Bloc>().state.username));
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
