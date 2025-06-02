import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

abstract class PaymentEvent {}

class InitializePayment extends PaymentEvent {
  final String publishableKey;
  InitializePayment(this.publishableKey);
}

class ProcessPayment extends PaymentEvent {
  final double amount;
  final String currency;
  final BillingDetails billingDetails;
  final BuildContext context;
  ProcessPayment({
    required this.amount,
    required this.currency,
    required this.billingDetails,
    required this.context,
  });
}
