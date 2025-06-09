import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:sole_space_user1/config/routes/app_router.dart';
import 'package:sole_space_user1/core/widgets/custom_app_bar.dart';
import 'package:sole_space_user1/features/checkout/presentation/blocs/address/address_bloc.dart';
import 'package:sole_space_user1/features/checkout/presentation/blocs/address/address_state.dart';
import 'package:sole_space_user1/features/checkout/presentation/blocs/payment/payment_bloc.dart';
import 'package:sole_space_user1/features/checkout/presentation/blocs/payment/payment_state.dart';
import 'package:sole_space_user1/features/checkout/presentation/widgets/address/address_card.dart';
import 'package:sole_space_user1/features/checkout/presentation/widgets/checkout/checkout_summary.dart';
import 'package:sole_space_user1/features/checkout/presentation/widgets/checkout/order_item_list.dart';
import 'package:sole_space_user1/features/orders/model/order_model.dart';
import 'package:sole_space_user1/features/home/presentation/blocs/cart/cart_bloc.dart';
import 'package:sole_space_user1/features/orders/presentation/blocs/order/order_bloc.dart';
import 'package:sole_space_user1/features/orders/presentation/blocs/order/order_event.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CheckoutPage extends StatelessWidget {
  final double shipping = 49;
  const CheckoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(title: const Text('Checkout')),
        body: Column(
          children: [
            _buildAddressSection(context),
            Expanded(
              child: BlocBuilder<CartBloc, CartState>(
                builder: (context, state) {
                  if (state is CartLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is CartLoaded) {
                    if (state.cartItems.isEmpty) {
                      return const Center(child: Text('No product added'));
                    }
                    final total = context.read<CartBloc>().calculateTotal(
                      state.cartItems,
                      shipping,
                    );
                    return Column(
                      children: [
                        Expanded(child: OrderItemList(items: state.cartItems)),
                        CheckoutSummary(
                          subtotal: total,
                          shipping: shipping,
                          onPlaceOrder: () => _handlePlaceOrder(context),
                        ),
                      ],
                    );
                  } else if (state is CartError) {
                    return Center(child: Text(state.message));
                  }
                  return const SizedBox();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddressSection(BuildContext context) {
    return BlocBuilder<AddressBloc, AddressState>(
      builder: (context, state) {
        if (state is AddressLoaded && state.addresses.isNotEmpty) {
          final selectedAddress = state.addresses.firstWhere(
            (address) => address.isSelected,
            orElse: () => state.addresses.first,
          );
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomAddressCard(
                  address: selectedAddress,
                  onChangePressed: () {
                    Navigator.pushNamed(context, AppRouter.addressList);
                  },
                ),
              ],
            ),
          );
        } else {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomAddressCard(
                  address: null,
                  onChangePressed: () {
                    Navigator.pushNamed(context, AppRouter.address);
                  },
                ),
              ],
            ),
          );
        }
      },
    );
  }

  Future<void> _handlePlaceOrder(BuildContext context) async {
    try {
      final addressState = context.read<AddressBloc>().state;
      final cartState = context.read<CartBloc>().state;
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please login to place an order')),
        );
        return;
      }

      if (addressState is! AddressLoaded || addressState.addresses.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a delivery address')),
        );
        return;
      }

      if (cartState is! CartLoaded || cartState.cartItems.isEmpty) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Your cart is empty')));
        return;
      }

      // Get selected address
      final selectedAddress = addressState.addresses.firstWhere(
        (address) => address.isSelected,
        orElse: () => addressState.addresses.first,
      );

      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      // Process payment
      final paymentBloc = context.read<PaymentBloc>();
      final total = cartState.cartItems.fold(
        0.0,
        (sum, item) => sum + (item.price * item.quantity),
      );

      paymentBloc.add(
        ProcessPayment(
          amount: total,
          currency: 'usd',
          billingDetails: BillingDetails(
            name: selectedAddress.fullName,
            address: Address(
              city: selectedAddress.city,
              country: 'US',
              line1: selectedAddress.address,
              line2: '',
              postalCode: selectedAddress.postalCode,
              state: selectedAddress.state,
            ),
            phone: selectedAddress.phoneNumber,
          ),
        ),
      );

      // Listen to payment state changes
      await for (final state in paymentBloc.stream) {
        if (state is PaymentSuccess) {
          // Create order
          final order = Order(
            id: '', // Will be set by Firestore
            userId: user.uid,
            items: cartState.cartItems,
            total: total,
            status: 'pending',
            createdAt: DateTime.now(),
            paymentIntentId: state.paymentIntentId,
            addressId: selectedAddress.id,
            fullName: selectedAddress.fullName,
            address: selectedAddress.address,
            city: selectedAddress.city,
            state: selectedAddress.state,
            postalCode: selectedAddress.postalCode,
            phoneNumber: selectedAddress.phoneNumber,
            trackingNumber: '',
          );

          // Create order in Firestore
          context.read<OrderBloc>().add(CreateOrder(order));

          // Clear cart
          context.read<CartBloc>().add(ClearCart());

          // Hide loading indicator
          if (Navigator.canPop(context)) {
            Navigator.pop(context);
          }
          // Navigate to success page or home
          Navigator.pushReplacementNamed(context, AppRouter.confirmation);
          break;
        } else if (state is PaymentError) {
          // Hide loading indicator
          if (Navigator.canPop(context)) {
            Navigator.pop(context);
          }

          // Check if the error is due to user cancellation
          if (state.message.toLowerCase().contains('canceled')) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Payment was cancelled')),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Payment failed: ${state.message}')),
            );
          }
          break;
        }
      }
    } catch (e) {
      // Hide loading indicator if showing
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }

      // Check if the error is due to user cancellation
      if (e.toString().toLowerCase().contains('canceled')) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Payment was cancelled')));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Payment failed: ${e.toString()}')),
        );
      }
    }
  }
}
