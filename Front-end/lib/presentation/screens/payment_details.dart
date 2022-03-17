import 'package:awesome_card/awesome_card.dart';

import 'package:flutter/material.dart';

class PaymentDetails extends StatefulWidget {
  // PaymentDetails({Key key}) : super(key: key);

  @override
  _PaymentDetailsState createState() => _PaymentDetailsState();
}

class _PaymentDetailsState extends State<PaymentDetails> {
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
        backgroundColor: Color(0xFFFF8084),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CreditCard(
              cardNumber: cardNumber,
              cardExpiry: cardExpiry,
              cardHolderName: cardHolderName,
              bankName: bankName,
              cvv: cvv,
              // showBackSide: true,
              frontBackground: CardBackgrounds.black,
              backBackground: CardBackgrounds.white,
              cardType: CardType.masterCard,
              showShadow: true,
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
              child: Column(
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
                            Text(
                              cardHolderName,
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
                      onPressed: () => print("Edit Detail"), //edit
                    ),
                  ),
                ],
              ),
            ),
            // StickyLabel(text: "Transaction Details"),
            // Container(
            //   margin: EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
            //   padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
            //   decoration: BoxDecoration(
            //     color: kWhiteColor,
            //     border: Border.all(
            //       width: 0.5,
            //       color: Color(0xFF808080),
            //     ),
            //     borderRadius: BorderRadius.circular(10.0),
            //   ),
            // child: ListView.separated(
            //   shrinkWrap: true,
            //   itemCount: paymentDetailList.length,
            //   itemBuilder: (context, index) {
            //     return Row(
            //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //       children: [
            //         Text(
            //           paymentDetailList[index].date,
            //           style: TextStyle(
            //             fontSize: 16.0,
            //             color: Color(0xFF808080),
            //           ),
            //         ),
            //         Container(
            //           width: 190.0,
            //           child: Text(
            //             paymentDetailList[index].details,
            //             style: TextStyle(fontSize: 16.0),
            //           ),
            //         ),
            //         Container(
            //           width: 70.0,
            //           child: Text(
            //             "\$ ${paymentDetailList[index].amount}",
            //             style: TextStyle(
            //               fontSize: 16.0,
            //               color: paymentDetailList[index].textColor,
            //             ),
            //           ),
            //         ),
            //       ],
            //     );
            //   },
            //   separatorBuilder: (context, index) {
            //     return Divider(
            //       thickness: 0.5,
            //       color: Color(0xFF808080),
            //     );
            //   },
            // ),
            // ),
            SizedBox(height: 8.0),
          ],
        ),
      ),
    );
  }
}
