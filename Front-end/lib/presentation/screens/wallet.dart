import 'package:flutter/material.dart';
import 'package:sdp/presentation/screens/payment_details.dart';

class Wallet extends StatefulWidget {
  @override
  _WalletState createState() => _WalletState();
}

final paymentLabels = [
  'Credit card / Debit card',
  'Cash on Station',
  'Points',
  'Google wallet',
];
final paymentIcons = [
  Icons.credit_card,
  Icons.money_off,
  Icons.payment,
  Icons.account_balance_wallet,
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
        children: [
          Text(
            '\n Choose your payment method \n',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.normal),
          ),
          Expanded(
            child: ListView.separated(
              itemCount: paymentLabels.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Radio(
                    activeColor: Color(0xFFFF8084),
                    value: index,
                    groupValue: value,
                    onChanged: (i) => setState(() => value == i),
                  ),
                  title: Text(
                    paymentLabels[index],
                    style: TextStyle(color: Color(0xFF303030)),
                  ),
                  trailing: Icon(paymentIcons[index], color: Color(0xFFFF8084)),
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
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => PaymentDetails(),
              )),

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
}
