import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sole_space_user1/core/widgets/custom_app_bar.dart';
import 'package:sole_space_user1/features/home/presentation/blocs/cart/cart_bloc.dart';
import 'package:sole_space_user1/features/home/presentation/widgets/cart/cart_list_item.dart';
import 'package:sole_space_user1/features/home/presentation/widgets/cart/cart_summary.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});
  final double shipping = 49;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: Text('Cart'), showBackButton: false),
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state is CartLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CartLoaded) {
            if (state.cartItems.isEmpty) {
              return const Center(child: Text('Your cart is empty'));
            }
            // Calculate total using the function from CartBloc
            final total = context.read<CartBloc>().calculateTotal(
              state.cartItems,
              shipping,
            );
            final subTotal = context.read<CartBloc>().calculateSubTotal(
              state.cartItems,
            );
            return Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    separatorBuilder:
                        (context, index) => const Divider(height: 30),
                    itemCount: state.cartItems.length,
                    itemBuilder: (context, index) {
                      final item = state.cartItems[index];
                      return CartListItem(item: item);
                    },
                  ),
                ),
                CartSummary(
                  total: total,
                  subTotal: subTotal,
                  shipping: shipping,
                ),
              ],
            );
          } else if (state is CartError) {
            return Center(child: Text(state.message));
          }
          return const SizedBox();
        },
      ),
    );
  }
}
