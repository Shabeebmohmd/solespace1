import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sole_space_user1/config/routes/app_router.dart';
import 'package:sole_space_user1/core/widgets/custom_app_bar.dart';
import 'package:sole_space_user1/features/checkout/presentation/blocs/address/address_bloc.dart';
import 'package:sole_space_user1/features/checkout/presentation/blocs/address/address_state.dart';
import 'package:sole_space_user1/features/checkout/presentation/widgets/address/address_card.dart';
import 'package:sole_space_user1/features/checkout/presentation/widgets/checkout/checkout_summary.dart';
import 'package:sole_space_user1/features/checkout/presentation/widgets/checkout/order_item_list.dart';
import 'package:sole_space_user1/features/home/presentation/blocs/cart/cart_bloc.dart';

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

  void _handlePlaceOrder(BuildContext context) {
    final addressState = context.read<AddressBloc>().state;
    final cartState = context.read<CartBloc>().state;

    if (addressState is AddressLoaded &&
        addressState.addresses.isNotEmpty &&
        cartState is CartLoaded &&
        cartState.cartItems.isNotEmpty) {
      Navigator.pushReplacementNamed(context, AppRouter.confirmation);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please select an address and make sure your cart is not empty.',
          ),
        ),
      );
    }
  }
}
