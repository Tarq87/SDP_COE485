import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sdp/bussiness_logic/blocs/payment_details_bloc/payment_details_bloc.dart';

class Wallet extends StatefulWidget {
  @override
  _WalletState createState() => _WalletState();
}

final paymentLabels = [
  'Credit card / Debit card',
  'Points',
];
final paymentIcons = [
  Icons.credit_card,
  Icons.star_border_outlined,
];

class _WalletState extends State<Wallet> {
  int value = 0;

  get child => null;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfffdfdfdf),
      appBar: AppBar(
        title: Text('Payment'),
        actions: <Widget>[],
        backgroundColor: Color.fromARGB(204, 63, 102, 185).withOpacity(0.9),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '\nChoose your payment method \n',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.normal),
          ),
          SizedBox(
            height: 20,
          ),
          Expanded(
            child: ListView.separated(
              itemCount: paymentLabels.length,
              itemBuilder: (context, index) {
                return BlocBuilder<PaymentDetailsBloc, PaymentDetailsState>(
                  builder: (context, state) {
                    if (state.paymentType == 'credit') {
                      value = 0;
                    } else if (state.paymentType == 'points') {
                      value = 1;
                    } else {
                      value = 0;
                    }
                    return ListTile(
                      leading: Radio<int>(
                        activeColor: Color(0xFFFF8084),
                        value: index,
                        groupValue: value,
                        onChanged: (i) => setState(() {
                          value = i!;
                          if (value == 0) {
                            state.paymentType = 'credit';
                          } else {
                            state.paymentType = 'points';
                          }
                        }),
                      ),
                      title: Text(
                        paymentLabels[index],
                        style: TextStyle(color: Color(0xFF303030)),
                      ),
                      trailing:
                          Icon(paymentIcons[index], color: Color(0xFFFF8084)),
                    );
                  },
                );
              },
              separatorBuilder: (context, index) {
                return Divider();
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(20, 5, 10, 0),
            child: TextButton(
              //padding: EdgeInsets.all(15.0),
              onPressed: () {
                if (value == 0) {
                  Navigator.pushNamed(context, '/PaymentInformation');
                } else {
                  _showPointsDialog(context);
                }
              },
              child: Text(
                "Payment Details",
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
              // child: RoundedRectangleBorder(
              //   side: BorderSide(color: Colors.blue, width: 3.0),
              //   borderRadius: BorderRadius.circular(20.0)),
            ),
          )
        ],
      ),
    );
  }

  Future<void> _showPointsDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext c) {
        // be careful to change c to context
        return AlertDialog(
          title: const Text('Total Points'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('50 Points'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                print('Total Points Dialog Reviewed.');
              },
            ),
          ],
        );
      },
    );
  }
}
