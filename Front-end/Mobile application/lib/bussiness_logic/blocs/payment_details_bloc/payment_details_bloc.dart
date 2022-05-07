//imports
import 'package:flutter_bloc/flutter_bloc.dart';
// be carefull with part
part 'payment_details_event.dart';
part 'payment_details_state.dart';

class PaymentDetailsBloc
    extends Bloc<PaymentDetailsEvent, PaymentDetailsState> {
  // final PaymentDetailsRepository? settingsRepos;
  // PaymentDetails? settingsResponse; no need because not requesting any settings

  PaymentDetailsBloc() : super(PaymentDetailsState()) {
    on<ModifyPaymentDetails>(((event, emit) async {
      emit(state.copyWith(
        detailsModified: true,
      ));
    }));
  }

  Future<void> close() {
    PaymentDetailsBloc().close();
    return super.close();
  }
}
