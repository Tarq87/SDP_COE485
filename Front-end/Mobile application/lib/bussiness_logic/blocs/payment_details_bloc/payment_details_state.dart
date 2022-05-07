part of 'payment_details_bloc.dart';

class PaymentDetailsState {
  String paymentType;
  String cardNumber, cardExpiry, cardHolderName, bankName, cvv;
  bool detailsModified;

  PaymentDetailsState({
    this.paymentType = '',
    this.cardNumber = '',
    this.cardExpiry = '',
    this.cardHolderName = '',
    this.bankName = '',
    this.cvv = '',
    this.detailsModified = false,
  });

  PaymentDetailsState copyWith({
    String? paymentType,
    String? cardNumber,
    String? cardExpiry,
    String? cardHolderName,
    String? bankName,
    String? cvv,
    bool? detailsModified,
  }) {
    // if the no parameter passed in the copyWith
    // then the current state is passed
    return PaymentDetailsState(
        paymentType: paymentType ?? this.paymentType,
        cardNumber: cardNumber ?? this.cardNumber,
        cardExpiry: cardExpiry ?? this.cardExpiry,
        cardHolderName: cardHolderName ?? this.cardHolderName,
        bankName: bankName ?? this.bankName,
        detailsModified: detailsModified ?? this.detailsModified);
  }
}
