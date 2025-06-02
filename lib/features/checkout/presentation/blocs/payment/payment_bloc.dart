import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:sole_space_user1/features/checkout/data/services/payment_service.dart';
import 'package:sole_space_user1/features/checkout/presentation/blocs/payment/payment_state.dart';

// Events
abstract class PaymentEvent {}

class InitializePayment extends PaymentEvent {
  final String publishableKey;
  InitializePayment(this.publishableKey);
}

class ProcessPayment extends PaymentEvent {
  final double amount;
  final String currency;
  final BillingDetails billingDetails;
  ProcessPayment({
    required this.amount,
    required this.currency,
    required this.billingDetails,
  });
}

// Bloc
class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  final PaymentService _paymentService;

  PaymentBloc(this._paymentService) : super(PaymentInitial()) {
    on<InitializePayment>(_onInitializePayment);
    on<ProcessPayment>(_onProcessPayment);
  }

  Future<void> _onInitializePayment(
    InitializePayment event,
    Emitter<PaymentState> emit,
  ) async {
    try {
      await _paymentService.initializeStripe(event.publishableKey);
      emit(PaymentInitial());
    } catch (e) {
      emit(PaymentError(e.toString()));
    }
  }

  Future<void> _onProcessPayment(
    ProcessPayment event,
    Emitter<PaymentState> emit,
  ) async {
    try {
      emit(PaymentLoading());

      final paymentIntent = await _paymentService.createPaymentIntent(
        amount: event.amount,
        currency: event.currency,
      );

      await _paymentService.processPayment(
        clientSecret: paymentIntent['clientSecret'],
        billingDetails: event.billingDetails,
      );

      emit(PaymentSuccess());
    } catch (e) {
      emit(PaymentError(e.toString()));
    }
  }
}
