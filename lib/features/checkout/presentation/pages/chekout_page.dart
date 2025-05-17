import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sole_space_user1/config/routes/app_router.dart';
import 'package:sole_space_user1/core/utils/utils.dart';
import 'package:sole_space_user1/core/widgets/custom_app_bar.dart';
import 'package:sole_space_user1/core/widgets/custom_button.dart';
import 'package:sole_space_user1/features/checkout/presentation/blocs/address/address_bloc.dart';
import 'package:sole_space_user1/features/checkout/presentation/blocs/address/address_state.dart';
import 'package:sole_space_user1/features/checkout/presentation/widget/address_card.dart';
import 'package:sole_space_user1/features/home/models/cart_model.dart';
import 'package:sole_space_user1/features/home/presentation/blocs/cart/cart_bloc.dart';

class CheckoutPage extends StatelessWidget {
  final double shipping = 49;
  const CheckoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(title: Text('Checkout')),
        body: Column(
          children: [
            BlocBuilder<AddressBloc, AddressState>(
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
            ),
            Expanded(
              child: BlocBuilder<CartBloc, CartState>(
                builder: (context, state) {
                  if (state is CartLoading) {
                    return Center(child: CircularProgressIndicator());
                  } else if (state is CartLoaded) {
                    if (state.cartItems.isEmpty) {
                      return Center(child: Text('No product added'));
                    }
                    final total = context.read<CartBloc>().calculateTotal(
                      state.cartItems,
                      shipping,
                    );
                    return Column(
                      children: [
                        Expanded(
                          child: ListView.separated(
                            separatorBuilder:
                                (context, index) => Divider(height: 40),
                            itemCount: state.cartItems.length,
                            itemBuilder: (context, index) {
                              final item = state.cartItems[index];
                              return _listTile(item, context);
                            },
                          ),
                        ),
                        // Display total price
                        _checkOutContainer(context, total),
                      ],
                    );
                  } else if (state is CartError) {
                    return Center(child: Text(state.message));
                  }
                  return SizedBox();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container _checkOutContainer(BuildContext context, double total) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceBright,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Subtotal:"),
                Text("\$${total.toStringAsFixed(2)}"),
              ],
            ),
            mediumSpacing,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Shipping:"),
                Text(' \$${shipping.toStringAsFixed(2)}'),
              ],
            ),
            mediumSpacing,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Total: ",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  "\$${total.toStringAsFixed(2)}",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            mediumSpacing,
            CustomButton(
              onPressed: () async {
                final addressState = context.read<AddressBloc>().state;
                final cartState = context.read<CartBloc>().state;

                // Check if address and cart are valid
                if (addressState is AddressLoaded &&
                    addressState.addresses.isNotEmpty &&
                    cartState is CartLoaded &&
                    cartState.cartItems.isNotEmpty) {
                  // final selectedAddress = addressState.addresses.firstWhere(
                  //   (address) => address.isSelected,
                  //   orElse: () => addressState.addresses.first,
                  // );
                  Navigator.pushReplacementNamed(
                    context,
                    AppRouter.confirmation,
                  );
                  // Optionally, navigate to an order confirmation page
                  // Navigator.pushNamed(context, AppRouter.orderConfirmation);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Please select an address and make sure your cart is not empty.',
                      ),
                    ),
                  );
                }
              },
              text: 'Place order',
            ),
          ],
        ),
      ),
    );
  }

  ListTile _listTile(CartItem item, BuildContext context) {
    return ListTile(
      leading:
          item.imageUrl.isNotEmpty
              ? ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  item.imageUrl,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  errorBuilder:
                      (context, error, stackTrace) => Icon(Icons.error),
                ),
              )
              : Icon(Icons.image_not_supported),
      title: Text(item.name),
      subtitle: Text('Price: \$${item.price.toStringAsFixed(2)}'),
    );
  }
}
