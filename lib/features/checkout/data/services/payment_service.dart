import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'package:sole_space_user1/core/constants/stripe_constants.dart';

class PaymentService {
  // Future<void> initializeStripe(String publishableKey) async {
  //   try {
  //     Stripe.publishableKey = publishableKey;
  //     await Stripe.instance.applySettings();
  //   } catch (e) {
  //     throw Exception('Failed to initialize Stripe: $e');
  //   }
  // }

  Future<void> initializeStripe(String publishableKey) async {
    try {
      Stripe.publishableKey = publishableKey;

      // merchantIdentifier is iOS‑only but harmless elsewhere
      Stripe.merchantIdentifier = 'merchant.com.sole_space';

      // Important: no dart:io or Platform checks ⇒ works on Web
      await Stripe.instance.applySettings();
    } catch (e) {
      throw Exception('Failed to initialize Stripe: $e');
    }
  }

  Future<Map<String, dynamic>> createPaymentIntent({
    required double amount,
    required String currency,
  }) async {
    try {
      print('Creating payment intent for amount: $amount $currency');

      final response = await http.post(
        Uri.parse('${StripeConstants.baseUrl}/payment_intents'),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'Authorization': 'Bearer ${StripeConstants.secretKey}',
        },
        body: {
          'amount': (amount * 100).round().toString(),
          'currency': currency,
          'payment_method_types[]': 'card',
        },
      );

      print('Payment intent response status: ${response.statusCode}');
      print('Payment intent response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'clientSecret': data['client_secret'],
          'paymentIntentId': data['id'],
        };
      } else {
        final error = jsonDecode(response.body);
        throw Exception(
          'Failed to create payment intent: ${error['error']?['message'] ?? response.body}',
        );
      }
    } catch (e) {
      print('Error creating payment intent: $e');
      throw Exception('Error creating payment intent: $e');
    }
  }

  Future<bool> processPayment({
    required String clientSecret,
    required BillingDetails billingDetails,
  }) async {
    return kIsWeb
        ? _payOnWeb(clientSecret, billingDetails)
        : _payOnMobile(clientSecret, billingDetails);
  }

  /* --------------------  ANDROID / iOS  -------------------- */
  Future<bool> _payOnMobile(
    String clientSecret,
    BillingDetails billingDetails,
  ) async {
    await Stripe.instance.initPaymentSheet(
      paymentSheetParameters: SetupPaymentSheetParameters(
        paymentIntentClientSecret: clientSecret,
        merchantDisplayName: 'Sole Space',
        billingDetails: billingDetails,
        style: ThemeMode.system,
      ),
    );
    await Stripe.instance.presentPaymentSheet();
    return true; // success
  }

  /* ------------------------  WEB  -------------------------- */
  Future<bool> _payOnWeb(
    String clientSecret,
    BillingDetails billingDetails,
  ) async {
    // Collect card data with Stripe’s built‑in Payment Element UI
    await Stripe.instance.confirmPayment(
      paymentIntentClientSecret: clientSecret,
      data: PaymentMethodParams.card(
        paymentMethodData: PaymentMethodData(billingDetails: billingDetails),
      ),
    );
    return true;
  }

  // Future<bool> processPayment({
  //   required String clientSecret,
  //   required BillingDetails billingDetails,
  // }) async {
  //   try {
  //     print('Processing payment with client secret: $clientSecret');

  //     // Initialize payment sheet
  //     await Stripe.instance.initPaymentSheet(
  //       paymentSheetParameters: SetupPaymentSheetParameters(
  //         paymentIntentClientSecret: clientSecret,
  //         merchantDisplayName: 'Sole Space',
  //         style: ThemeMode.system,
  //         billingDetails: billingDetails,
  //         appearance: const PaymentSheetAppearance(
  //           colors: PaymentSheetAppearanceColors(primary: Colors.blue),
  //         ),
  //       ),
  //     );

  //     // Present payment sheet
  //     await Stripe.instance.presentPaymentSheet();

  //     print('Payment processed successfully');
  //     return true;
  //   } on StripeException catch (e) {
  //     print('Stripe error: ${e.error.localizedMessage}');
  //     // Check if the error message indicates user cancellation
  //     if (e.error.localizedMessage?.toLowerCase().contains('canceled') ??
  //         false) {
  //       return false;
  //     }
  //     throw Exception('Payment failed: ${e.error.localizedMessage}');
  //   } catch (e) {
  //     print('Payment processing error: $e');
  //     throw Exception('Payment failed: $e');
  //   }
  // }
}
