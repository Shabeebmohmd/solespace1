import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sole_space_user1/core/utils/utils.dart';
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
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            refreshCart(context);
            await Future.delayed(const Duration(milliseconds: 500));
          },
          child: BlocBuilder<CartBloc, CartState>(
            builder: (context, state) {
              if (state is CartLoading && state.cartItems.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is CartLoaded ||
                  (state is CartLoading && state.cartItems.isNotEmpty)) {
                final cartItems =
                    state is CartLoaded
                        ? state.cartItems
                        : (state as CartLoading).cartItems;
                if (cartItems.isEmpty) {
                  return const Center(child: Text('Your cart is empty'));
                }
                final total = context.read<CartBloc>().calculateTotal(
                  cartItems,
                  shipping,
                );
                final subTotal = context.read<CartBloc>().calculateSubTotal(
                  cartItems,
                );
                return Column(
                  children: [
                    Expanded(
                      child: ListView.separated(
                        separatorBuilder:
                            (context, index) => const Divider(height: 30),
                        itemCount: cartItems.length,
                        itemBuilder: (context, index) {
                          final item = cartItems[index];
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
        ),
      ),
    );
  }
}
