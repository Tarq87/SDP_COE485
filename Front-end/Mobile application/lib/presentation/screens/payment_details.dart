import 'package:awesome_card/awesome_card.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sdp/bussiness_logic/blocs/login_bloc/login2_bloc.dart';
import 'package:sdp/bussiness_logic/blocs/payment_details_bloc/payment_details_bloc.dart';

class PaymentInformation extends StatefulWidget {
  // PaymentInformation({Key key}) : super(key: key);

  @override
  _PaymentInformationState createState() => _PaymentInformationState();
}

class _PaymentInformationState extends State<PaymentInformation> {
  final _formKey = GlobalKey<FormState>();

  // Payments Details
  String cardNumber = "5450 7879 4864 7854",
      cardExpiry = "10/25",
      cardHolderName = "Khaled Alahmadi",
      bankName = "Alrajhi Bank",
      cvv = "456";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
      appBar: AppBar(
        title: Text("Payment Details"),
        actions: <Widget>[],
        backgroundColor: Color.fromARGB(204, 63, 102, 185).withOpacity(0.9),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            BlocBuilder<Login2Bloc, Login2State>(
              builder: (context, state) {
                if (state.username != '') {
                  cardHolderName = state.username;
                }
                return BlocBuilder<PaymentDetailsBloc, PaymentDetailsState>(
                  builder: (context, state) {
                    if (state.cardNumber != '') {
                      cardNumber = state.cardNumber;
                    }
                    if (state.cardExpiry != '') {
                      cardExpiry = state.cardExpiry;
                    }
                    if (state.cardHolderName != '') {
                      cardHolderName = state.cardHolderName;
                    }
                    if (bankName != '') {
                      bankName = state.bankName;
                    }
                    if (state.cvv != '') {
                      cvv = state.cvv;
                    }
                    return CreditCard(
                      cardNumber: cardNumber,
                      cardExpiry: cardExpiry,
                      cardHolderName: cardHolderName,
                      bankName: bankName,
                      cvv: cvv,
                      height: 200,
                      // showBackSide: true,
                      frontBackground: CardBackgrounds.black,
                      backBackground: CardBackgrounds.white,
                      cardType: CardType.masterCard,
                      showShadow: true,
                    );
                  },
                );
              },
            ),
            Text(
              "\nCard Information",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.normal),
            ),
            SizedBox(height: 8.0),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 24.0),
              decoration: BoxDecoration(
                color: Color(0xFFFFFFFF),
                border: Border.all(
                  width: 0.5,
                  color: Color(0xFF808080),
                ),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: BlocBuilder<PaymentDetailsBloc, PaymentDetailsState>(
                builder: (context, state) {
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24.0,
                          vertical: 8.0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("My Perosnal Card",
                                style: TextStyle(fontSize: 18.0)),
                            Container(
                                width: 60.0,
                                child: Icon(Icons.payment,
                                    color: Color(0xFFFF8084), size: 40.0)),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Card Number",
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    color: Color(0xFF808080),
                                  ),
                                ),
                                Text(
                                  cardNumber,
                                  style: TextStyle(fontSize: 16.0),
                                ),
                              ],
                            ),
                            Container(
                              width: 45.0,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Exp.",
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      color: Color(0xFF808080),
                                    ),
                                  ),
                                  Text(
                                    cardExpiry,
                                    style: TextStyle(fontSize: 16.0),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24.0,
                          vertical: 8.0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Card Name",
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    color: Color(0xFF808080),
                                  ),
                                ),
                                BlocBuilder<Login2Bloc, Login2State>(
                                  builder: (context2, state) {
                                    if (context
                                            .read<PaymentDetailsBloc>()
                                            .state
                                            .cardHolderName !=
                                        '') {
                                      cardHolderName = context
                                          .read<PaymentDetailsBloc>()
                                          .state
                                          .cardHolderName;
                                    } else if (state.username != '') {
                                      cardHolderName = state.username;
                                    }
                                    return Text(
                                      cardHolderName,
                                      style: TextStyle(fontSize: 16.0),
                                    );
                                  },
                                ),
                              ],
                            ),
                            Container(
                              width: 45.0,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "CVV",
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      color: Color(0xFF808080),
                                    ),
                                  ),
                                  Text(
                                    cvv,
                                    style: TextStyle(fontSize: 16.0),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 48.0,
                        width: MediaQuery.of(context).size.width,
                        child: TextButton(
                          child: Text(
                            "Edit Detail",
                            style: TextStyle(fontSize: 16.0),
                          ),
                          onPressed: () {
                            _showMyDialog(context);
                          }, //edit
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            SizedBox(height: 8.0),
          ],
        ),
      ),
    );
  }

  Future<void> _showMyDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext c) {
        // be careful to change c to context
        return AlertDialog(
          title: const Text('Edit Your Payment Info'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Form(
                  key: _formKey,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _cardNumber(context),
                        _cardExpiry(context),
                        _cardHolderName(context),
                        _bankName(context),
                        _cvv(context),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
                print('Editing Canceled.');
              },
            ),
            TextButton(
              child: const Text('Save'),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  setState(() {
                    cardNumber;
                    cardExpiry;
                    cardHolderName;
                    bankName;
                    cvv;
                  });
                  Navigator.of(context).pop();
                  print('Editing Saved.');
                }
              },
            ),
          ],
        );
      },
    );
  }

  _cardNumber(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        icon: Icon(Icons.credit_card),
        hintText: 'Card Number',
      ),
      validator: (value) =>
          isNumericUsing_tryParse(value) ? null : 'Only Numbers. No spaces',
      onChanged: (value) {
        context.read<PaymentDetailsBloc>().state.cardNumber = value;
      },
    );
  }

  _cardExpiry(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        icon: Icon(Icons.date_range),
        hintText: 'Card Expiry',
      ),
      validator: (value) =>
          (value?.length == 5) ? null : 'Incorrect format. (MM/YY)',
      onChanged: (value) {
        context.read<PaymentDetailsBloc>().state.cardExpiry = value;
      },
    );
  }

  _cardHolderName(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        icon: Icon(Icons.person_outline),
        hintText: 'Card Holder Name',
      ),
      validator: (value) =>
          (value!.length >= 3) ? null : 'Incorrect format. (MM/YY)',
      onChanged: (value) {
        context.read<PaymentDetailsBloc>().state.cardHolderName = value;
      },
    );
  }

  _bankName(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        icon: Icon(Icons.add_business),
        hintText: 'Bank Name',
      ),
      validator: (value) => (value!.length >= 3) ? null : 'Incorrect Bank Name',
      onChanged: (value) {
        context.read<PaymentDetailsBloc>().state.bankName = value;
      },
    );
  }

  _cvv(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        icon: Icon(Icons.pin),
        hintText: 'CVV',
      ),
      validator: (value) =>
          (value!.length >= 3) ? null : 'Incorrect format. (MM/YY)',
      onChanged: (value) {
        context.read<PaymentDetailsBloc>().state.cvv = value;
      },
    );
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
}
