class PaymentDetails {
  String cardNumber, cardExpiry, cardHolderName, cvv;

  PaymentDetails({
    required this.cardNumber,
    required this.cardExpiry,
    required this.cardHolderName,
    required this.cvv,
  });

  factory PaymentDetails.fromJson(Map<String, dynamic> json) {
    return PaymentDetails(
      cardNumber:
          json['card_number'], // int represent total points for the user
      cardExpiry: json['expiration'], // msg just in case
      cardHolderName: json['holder_name'],
      cvv: json['cvv'],
    );
  }
}
