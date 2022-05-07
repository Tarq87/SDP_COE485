part of 'payment_details_bloc.dart';

abstract class PaymentDetailsEvent {}

class ModifyPaymentDetails extends PaymentDetailsEvent {}

class PaymentDetailsError extends PaymentDetailsEvent {}
